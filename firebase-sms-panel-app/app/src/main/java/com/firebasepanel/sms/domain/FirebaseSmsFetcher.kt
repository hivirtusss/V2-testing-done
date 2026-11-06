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
        var bestList: MutableList<RawSms>? = null
        for (path in tryPaths) {
            try {
                val json = httpGetJson(path) ?: continue
                online = true
                val out = mutableListOf<RawSms>()
                walkJson(json, "", out, depth = 0)
                if (out.isNotEmpty()) {
                    if (bestList == null || out.size > bestList.size) {
                        bestList = out
                    }
                }
            } catch (e: Exception) {
                lastErr = e.message
            }
        }
        if (bestList != null && bestList.isNotEmpty()) {
            return@withContext FetchResult(base, true, trimCap(bestList), null)
        }
        // deep root when shallow / empty children
        try {
            val rootFull = httpGetJson("$base.json")
            if (rootFull != null) {
                online = true
                val out = mutableListOf<RawSms>()
                walkJson(rootFull, "root", out, depth = 0)
                if (out.isNotEmpty()) {
                    return@withContext FetchResult(base, true, trimCap(out), null)
                }
            }
        } catch (e: Exception) {
            lastErr = e.message
        }
        try {
            val shallow = httpGetJson("$base.json?shallow=true")
            if (shallow != null) {
                online = true
                val out = mutableListOf<RawSms>()
                walkJson(shallow, "", out, depth = 0)
                if (out.isNotEmpty()) {
                    return@withContext FetchResult(base, true, trimCap(out), null)
                }
            }
        } catch (e: Exception) {
            lastErr = e.message
        }
        FetchResult(base, online, emptyList(), lastErr)
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
