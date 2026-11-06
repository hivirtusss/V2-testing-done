package com.firebasepanel.sms.domain

import java.util.regex.Pattern

private val URL_RE =
    Pattern.compile(
        "https?://[a-zA-Z0-9._-]+(?:\\.firebaseio\\.com|\\.firebasedatabase\\.app)(?:/[^\\s,\"']*)?",
        Pattern.CASE_INSENSITIVE,
    )

/** Virtus TXT: URL line + Auth Key line per panel (same rules as Virtus WebView `parseTxtCredentials`). */
data class FirebasePanel(
    val url: String,
    val authKey: String,
)

fun extractFirebaseUrls(text: String): List<String> = extractFirebasePanels(text).map { it.url }

fun extractFirebasePanels(text: String): List<FirebasePanel> {
    val map = LinkedHashMap<String, FirebasePanel>()
    var currentUrl: String? = null
    var currentKey: String? = null

    fun flush() {
        val u = currentUrl ?: return
        val k = currentKey.orEmpty()
        val low = u.lowercase()
        val existing = map[low]
        if (existing == null || (k.isNotBlank() && existing.authKey.isBlank())) {
            map[low] = FirebasePanel(url = normalizeFirebaseUrl(u), authKey = k)
        }
        currentUrl = null
        currentKey = null
    }

    val urlLine =
        Pattern.compile(
            "(?:Firebase URL|📍|^URL:|Firebase:-)",
            Pattern.CASE_INSENSITIVE,
        )
    val keyLine =
        Pattern.compile(
            "(?:Auth Key|🔑|^KEY:)",
            Pattern.CASE_INSENSITIVE,
        )
    val flushLine = Pattern.compile("(?:New Firebase Credentials|Panda Group)", Pattern.CASE_INSENSITIVE)

    for (raw in text.lines()) {
        val line = raw.trim()
        if (flushLine.matcher(line).find()) {
            flush()
            continue
        }
        val um = URL_RE.matcher(line)
        if (urlLine.matcher(line).find() && um.find()) {
            flush()
            var u = um.group().trim().trimEnd(',').trim('"', '\'')
            u = u.substringBefore(" ").trim()
            currentUrl = u
        }
        if (keyLine.matcher(line).find()) {
            val parts = line.split(":", limit = 2)
            val v = parts.getOrNull(1)?.trim().orEmpty()
            if (v.isNotEmpty()) currentKey = v
        }
        // Plain URL line (no "Firebase URL" label) — common in simple lists
        if (currentUrl == null && um.reset(line).find() && !keyLine.matcher(line).find()) {
            flush()
            var u = um.group().trim().trimEnd(',').trim('"', '\'')
            u = u.substringBefore(" ").trim()
            currentUrl = u
        }
    }
    flush()
    if (map.isEmpty()) {
        val m = URL_RE.matcher(text)
        val simple = LinkedHashSet<String>()
        while (m.find()) {
            var u = m.group().trim().trimEnd(',').trim('"', '\'')
            u = u.substringBefore(" ").trim()
            simple.add(normalizeFirebaseUrl(u))
        }
        return simple.map { FirebasePanel(it, "") }.toList()
    }
    return map.values.toList()
}

fun normalizeFirebaseUrl(raw: String): String {
    var s = raw.trim().trimEnd('/')
    if (!s.startsWith("http")) s = "https://$s"
    val uri = java.net.URI(s)
    return "${uri.scheme}://${uri.host}".trimEnd('/')
}
