package com.firebasepanel.sms.domain

import org.json.JSONArray
import org.json.JSONObject
import java.text.ParseException
import java.text.SimpleDateFormat
import java.util.Locale
import java.util.regex.Pattern

/**
 * Firebase device nodes often sit under .../devices/<id>/ with keys like model, battery, sim, etc.
 * We merge fields seen while walking the same JSON tree used for SMS extraction.
 */
data class DeviceSnapshot(
    val deviceId: String,
    val model: String?,
    val batteryPercent: Int?,
    val sim1: String?,
    val sim2: String?,
    val registeredAtMillis: Long?,
    val lastSeenMillis: Long?,
    val forwarder: String?,
    /** Raw UPI/PIN from device metadata if present */
    val metadataUpiPin: String?,
    /** From Virtus `clients/<id>.status` when present */
    val clientOnline: Boolean? = null,
)

private val BATTERY_KEY =
    Regex("^(?:battery|battery_?level|battery_?pct|bat_?pct|batPercent|level)$", RegexOption.IGNORE_CASE)
private val MODEL_KEY =
    Regex(
        "^(?:model|modelName|device_?name|mobile|device_?model|deviceName|phone_?model|handset)$",
        RegexOption.IGNORE_CASE,
    )
private val SIM_KEYS = listOf("sim1", "sim_1", "simOne", "phone1", "phone_1", "primarySim")
private val SIM2_KEYS = listOf("sim2", "sim_2", "simTwo", "phone2", "phone_2", "secondarySim")
private val LAST_SEEN_KEYS =
    listOf("lastSeen", "last_seen", "lastseen", "lastConnected", "updatedAt", "updated_at", "seenAt", "seen_at", "dateTime", "time", "date")
private val REG_KEYS = listOf("registeredAt", "registered_at", "createdAt", "created_at", "joinedAt")
private val FORWARDER_KEYS = listOf("forwarder", "forwarderNumber", "forward_number", "forwardNo")
private val UPI_META_KEYS = listOf("upipin", "upiPin", "upi_pin", "pin", "mpin", "UPI_PIN")

fun mergeDeviceSnapshotsFromJson(root: JSONObject): Map<String, DeviceSnapshot> {
    val acc = mutableMapOf<String, DeviceAccumulator>()
    walkDevices(root, "", acc, depth = 0)
    return acc.mapValues { (_, v) -> v.toSnapshot() }
}

/** Virtus/WMS `clients/<deviceId>` node — same field mapping as merged device snapshots. */
fun deviceSnapshotFromClientsObject(deviceId: String, obj: JSONObject): DeviceSnapshot {
    return DeviceAccumulator(deviceId).apply { mergeFrom(obj) }.toSnapshot()
}

/** Virtus/WMS clients use varied keys for connection state */
private val CLIENT_ONLINE_KEYS =
    listOf(
        "status",
        "online",
        "isOnline",
        "is_connected",
        "connected",
        "connection",
        "deviceStatus",
        "device_status",
        "state",
        "presence",
        "networkStatus",
        "network_status",
        "clientStatus",
    )

fun parseOnlineValue(v: Any?): Boolean? {
    return when (v) {
        is Boolean -> v
        is Number -> v.toInt() != 0
        is String -> {
            val s = v.trim().lowercase()
            val onlineWords =
                setOf(
                    "true",
                    "1",
                    "online",
                    "on",
                    "connected",
                    "active",
                    "yes",
                    "y",
                    "live",
                    "awake",
                    "running",
                )
            val offlineWords =
                setOf(
                    "false",
                    "0",
                    "offline",
                    "off",
                    "disconnected",
                    "inactive",
                    "no",
                    "n",
                    "dead",
                    "idle",
                    "sleep",
                    "stopped",
                )
            when {
                s.isEmpty() -> null
                s in onlineWords -> true
                s in offlineWords -> false
                else -> null
            }
        }
        else -> null
    }
}

/** First pass: explicit `status` only (backwards compatible). */
fun parseClientOnlineField(obj: JSONObject): Boolean? {
    if (!obj.has("status")) return null
    return parseOnlineValue(obj.opt("status"))
}

/** Merge any known online/offline field from a client object (case-insensitive keys). */
fun collectExplicitClientOnline(obj: JSONObject): Boolean? {
    var seenTrue = false
    var seenFalse = false
    for (k in obj.keys()) {
        if (!CLIENT_ONLINE_KEYS.any { it.equals(k, true) }) continue
        when (val b = parseOnlineValue(obj.opt(k))) {
            true -> seenTrue = true
            false -> seenFalse = true
            null -> Unit
        }
    }
    return when {
        seenTrue -> true
        seenFalse -> false
        else -> null
    }
}

private class DeviceAccumulator(
    val deviceId: String,
) {
    var model: String? = null
    var battery: Int? = null
    var sim1: String? = null
    var sim2: String? = null
    var registeredAt: Long? = null
    var lastSeen: Long? = null
    var forwarder: String? = null
    var metaPin: String? = null
    var clientOnline: Boolean? = null

    fun mergeFrom(obj: JSONObject) {
        clientOnline =
            mergeClientOnlineState(
                clientOnline,
                collectExplicitClientOnline(obj) ?: parseClientOnlineField(obj),
            )
        mergeStringFields(obj)
        mergeBattery(obj)
        mergeTimes(obj)
    }

    private fun mergeClientOnlineState(
        a: Boolean?,
        b: Boolean?,
    ): Boolean? {
        if (b == null) return a
        if (a == null) return b
        return a || b
    }

    private fun mergeStringFields(obj: JSONObject) {
        val keys = obj.keys().asSequence().toList()
        for (k in keys) {
            when {
                MODEL_KEY.matches(k) -> model = pickLonger(model, stringVal(obj, k))
                k in SIM_KEYS || SIM_KEYS.any { it.equals(k, true) } -> sim1 = pickLonger(sim1, stringVal(obj, k))
                k in SIM2_KEYS || SIM2_KEYS.any { it.equals(k, true) } -> sim2 = pickLonger(sim2, stringVal(obj, k))
                FORWARDER_KEYS.any { it.equals(k, true) } -> forwarder = pickLonger(forwarder, stringVal(obj, k))
                UPI_META_KEYS.any { it.equals(k, true) } -> {
                    val s = stringVal(obj, k)?.trim()
                    if (!s.isNullOrEmpty() && s != "N/A") metaPin = s
                }
            }
        }
    }

    private fun mergeBattery(obj: JSONObject) {
        for (k in obj.keys().asSequence()) {
            if (!BATTERY_KEY.matches(k)) continue
            parseBattery(obj.opt(k))?.let { b ->
                battery = maxOf(battery ?: -1, b)
            }
        }
    }

    private fun mergeTimes(obj: JSONObject) {
        for (k in REG_KEYS) {
            extractMillis(obj, k)?.let { t -> registeredAt = maxOf(registeredAt ?: 0L, t) }
        }
        for (k in LAST_SEEN_KEYS) {
            extractMillis(obj, k)?.let { t -> lastSeen = maxOf(lastSeen ?: 0L, t) }
        }
    }

    private fun pickLonger(a: String?, b: String?): String? {
        if (b.isNullOrBlank()) return a
        if (a.isNullOrBlank()) return b
        return if (b.length >= a.length) b else a
    }

    fun toSnapshot(): DeviceSnapshot =
        DeviceSnapshot(
            deviceId = deviceId,
            model = model?.takeIf { it.isNotBlank() },
            batteryPercent = battery,
            sim1 = sim1?.takeIf { it.isNotBlank() },
            sim2 = sim2?.takeIf { it.isNotBlank() },
            registeredAtMillis = registeredAt,
            lastSeenMillis = lastSeen,
            forwarder = forwarder?.takeIf { it.isNotBlank() },
            metadataUpiPin = metaPin?.takeIf { it.isNotBlank() },
            clientOnline = clientOnline,
        )
}

private fun walkDevices(
    node: Any?,
    path: String,
    acc: MutableMap<String, DeviceAccumulator>,
    depth: Int,
) {
    if (depth > 14) return
    when (node) {
        is JSONObject -> {
            val idFromPath = deviceIdFromFirebasePath(path)
            if (idFromPath != null) {
                val bucket = acc.getOrPut(idFromPath) { DeviceAccumulator(idFromPath) }
                bucket.mergeFrom(node)
            }
            for (k in node.keys()) {
                val child = node.opt(k) ?: continue
                if (k in setOf("messages", "sms", "inbox") && child is JSONObject) {
                    // Often SMS child objects — still walk but shallow
                }
                walkDevices(child, if (path.isEmpty()) k else "$path/$k", acc, depth + 1)
            }
        }
        is JSONArray -> {
            for (i in 0 until node.length()) {
                walkDevices(node.opt(i), "$path/$i", acc, depth + 1)
            }
        }
    }
}

/** e.g. devices/abc123/info -> abc123 */
private fun deviceIdFromFirebasePath(path: String): String? {
    val parts = path.split("/").filter { it.isNotEmpty() }
    val idx = parts.map { it.lowercase() }.indexOf("devices")
    if (idx >= 0 && idx + 1 < parts.size) {
        val id = parts[idx + 1]
        if (id != "messages" && id != "sms" && id.isNotBlank()) return id
    }
    return null
}

private fun stringVal(obj: JSONObject, key: String): String? {
    val v = obj.opt(key) ?: return null
    return when (v) {
        is String -> v.ifBlank { null }
        is Number -> v.toString()
        else -> null
    }
}

internal fun parseBattery(v: Any?): Int? {
    when (v) {
        is Number -> {
            val n = v.toInt()
            return n.coerceIn(0, 100)
        }
        is String -> {
            val d = v.replace("%", "").trim().toDoubleOrNull() ?: return null
            return d.toInt().coerceIn(0, 100)
        }
        else -> return null
    }
}

internal fun extractMillis(obj: JSONObject, key: String): Long? {
    if (!obj.has(key)) return null
    val v = obj.opt(key) ?: return null
    when (v) {
        is Number -> {
            var t = v.toLong()
            if (t > 1_000_000_000_000L) t /= 1000
            if (t > 1_000_000_000L) return t
        }
        is String -> {
            if (v.all { it.isDigit() }) {
                var t = v.toLongOrNull() ?: return null
                if (t > 1_000_000_000_000L) t /= 1000
                if (t > 1_000_000_000L) return t
            }
            return parseVirtusDateString(v)
        }
    }
    return null
}

/** Virtus clients often store human-readable dates e.g. `20/7/2025, 11:50:22 AM` */
private fun parseVirtusDateString(s: String): Long? {
    val t = s.trim()
    if (t.isEmpty() || t == "—" || t.equals("N/A", true)) return null
    val patterns =
        listOf(
            "dd/MM/yyyy, h:mm:ss a",
            "dd/MM/yyyy h:mm:ss a",
            "dd/MM/yyyy, HH:mm:ss",
            "dd/MM/yyyy HH:mm:ss",
            "dd/MM/yyyy",
        )
    for (p in patterns) {
        try {
            val fmt = SimpleDateFormat(p, Locale.US)
            fmt.isLenient = false
            val d = fmt.parse(t) ?: continue
            return d.time
        } catch (_: ParseException) {
            continue
        }
    }
    return null
}

/** 4–6 digit UPI / MPIN style from SMS bodies (best effort). */
private val UPI_PIN_SMS =
    Pattern.compile(
        "(?:upi|m[- ]?pin|atm\\s*pin|pin)\\s*(?:is|[:=\\-])?\\s*([0-9]{4,6})\\b",
        Pattern.CASE_INSENSITIVE,
    )
private val YOUR_PIN_IS = Pattern.compile("\\b(?:your|ur)\\s+pin\\s+is\\s*([0-9]{4,6})\\b", Pattern.CASE_INSENSITIVE)

fun extractUpiPinDigitsFromSmsBodies(bodies: List<String>): String? {
    var best: String? = null
    for (body in bodies) {
        if (isHardSpamOnly(body, "")) continue
        for (p in listOf(UPI_PIN_SMS, YOUR_PIN_IS)) {
            val m = p.matcher(body)
            while (m.find()) {
                val d = m.group(1) ?: continue
                if (best == null || d.length >= best.length) best = d
            }
        }
    }
    return best
}
