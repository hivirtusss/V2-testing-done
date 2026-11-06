package com.firebasepanel.sms.domain

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONArray
import org.json.JSONObject
import java.util.concurrent.TimeUnit

data class RawSms(
    val sender: String,
    val body: String,
    val messageAtMillis: Long?,
    val rawPath: String,
)

data class FetchResult(
    val url: String,
    val online: Boolean,
    val sms: List<RawSms>,
    /** Parsed per-device info from Firebase JSON (model, battery, SIMs, etc.) */
    val devices: Map<String, DeviceSnapshot> = emptyMap(),
    val error: String? = null,
)

private val client =
    OkHttpClient
        .Builder()
        .connectTimeout(12, TimeUnit.SECONDS)
        .readTimeout(45, TimeUnit.SECONDS)
        .callTimeout(90, TimeUnit.SECONDS)
        .followRedirects(true)
        .build()

private val MESSAGE_KEYS = setOf("message", "body", "text", "content", "sms")
private val TS_KEYS = listOf("timestamp", "time", "date", "createdAt", "message_at", "receivedAt")
private const val SMS_CAP = 8000

private data class ParsedPayload(
    val sms: List<RawSms>,
    val devices: Map<String, DeviceSnapshot>,
)

private fun parsePayload(json: JSONObject, pathPrefix: String): ParsedPayload {
    val out = mutableListOf<RawSms>()
    walkJson(json, pathPrefix, out, depth = 0)
    val devMap = mergeDeviceSnapshotsFromJson(json)
    return ParsedPayload(out, devMap)
}

private fun betterPayload(
    current: ParsedPayload?,
    candidate: ParsedPayload,
): ParsedPayload {
    if (current == null) return candidate
    return when {
        candidate.sms.size > current.sms.size -> candidate
        candidate.sms.size < current.sms.size -> current
        candidate.devices.size > current.devices.size -> candidate
        else -> current
    }
}

suspend fun fetchSmsFromFirebase(baseUrl: String): FetchResult =
    withContext(Dispatchers.IO) {
        val base = normalizeFirebaseUrl(baseUrl)
        val tryPaths =
            listOf(
                "$base.json",
                "$base/messages.json",
                "$base/sms.json",
            )
        var online = false
        var lastErr: String? = null
        var best: ParsedPayload? = null
        for (path in tryPaths) {
            try {
                val json = httpGetJson(path) ?: continue
                online = true
                val payload = parsePayload(json, "")
                if (payload.sms.isNotEmpty()) {
                    best = betterPayload(best, payload)
                }
            } catch (e: Exception) {
                lastErr = e.message
            }
        }
        if (best != null && best!!.sms.isNotEmpty()) {
            val cap = trimCap(best!!.sms.toMutableList())
            return@withContext FetchResult(base, true, cap, best!!.devices, null)
        }
        // deep root when shallow / empty children
        try {
            val rootFull = httpGetJson("$base.json")
            if (rootFull != null) {
                online = true
                val payload = parsePayload(rootFull, "root")
                if (payload.sms.isNotEmpty()) {
                    val cap = trimCap(payload.sms.toMutableList())
                    return@withContext FetchResult(base, true, cap, payload.devices, null)
                }
            }
        } catch (e: Exception) {
            lastErr = e.message
        }
        try {
            val shallow = httpGetJson("$base.json?shallow=true")
            if (shallow != null) {
                online = true
                val payload = parsePayload(shallow, "")
                if (payload.sms.isNotEmpty()) {
                    val cap = trimCap(payload.sms.toMutableList())
                    return@withContext FetchResult(base, true, cap, payload.devices, null)
                }
            }
        } catch (e: Exception) {
            lastErr = e.message
        }
        FetchResult(base, online, emptyList(), emptyMap(), lastErr)
    }

private fun trimCap(list: MutableList<RawSms>): List<RawSms> {
    if (list.size <= SMS_CAP) return list
    return list.takeLast(SMS_CAP)
}

suspend fun fetchManyParallel(urls: List<String>, concurrency: Int = 8): List<FetchResult> =
    coroutineScope {
        urls.chunked(concurrency.coerceAtLeast(1)).flatMap { batch ->
            batch.map { url -> async(Dispatchers.IO) { fetchSmsFromFirebase(url) } }.awaitAll()
        }
    }

private fun httpGetJson(url: String): JSONObject? {
    val req = Request.Builder().url(url).get().build()
    client.newCall(req).execute().use { resp ->
        if (!resp.isSuccessful) return null
        val body = resp.body?.string() ?: return null
        if (body.isBlank() || body.trim() == "null") return null
        return try {
            JSONObject(body)
        } catch (_: Exception) {
            try {
                val arr = JSONArray(body)
                val wrap = JSONObject()
                wrap.put("_root", arr)
                wrap
            } catch (_: Exception) {
                null
            }
        }
    }
}

private fun walkJson(node: Any?, path: String, out: MutableList<RawSms>, depth: Int) {
    if (depth > 10) return
    when (node) {
        is JSONObject -> {
            val keys = node.keys().asSequence().toList()
            if (keys.any { it in MESSAGE_KEYS }) {
                val body =
                    (node.optString("body")
                        .ifEmpty { node.optString("message") }
                        .ifEmpty { node.optString("text") }
                        .ifEmpty { node.optString("content") }
                        .ifEmpty { node.optString("sms") })
                if (body.length >= 2) {
                    val sender =
                        node.optString("sender")
                            .ifEmpty { node.optString("from") }
                            .ifEmpty { node.optString("address") }
                            .ifEmpty { node.optString("phone") }
                    val ts = extractMillis(node)
                    out.add(RawSms(sender.ifBlank { "(no sender)" }, body, ts, path))
                }
            }
            for (k in keys) {
                if (k in setOf("metadata", "config", "settings")) continue
                val child = node.opt(k) ?: continue
                walkJson(child, if (path.isEmpty()) k else "$path/$k", out, depth + 1)
            }
        }
        is JSONArray -> {
            for (i in 0 until node.length()) {
                walkJson(node.opt(i), "$path/$i", out, depth + 1)
            }
        }
    }
}

private fun extractMillis(obj: JSONObject): Long? {
    for (key in TS_KEYS) {
        if (!obj.has(key)) continue
        val v = obj.opt(key) ?: continue
        when (v) {
            is Number -> {
                var t = v.toLong()
                if (t > 1_000_000_000_000L) t /= 1000
                if (t > 1_000_000_000L) return t
            }
            is String -> {
                if (v.all { it.isDigit() }) {
                    var t = v.toLongOrNull() ?: continue
                    if (t > 1_000_000_000_000L) t /= 1000
                    if (t > 1_000_000_000L) return t
                }
            }
        }
    }
    return null
}
