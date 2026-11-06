package com.firebasepanel.sms.domain

import java.util.regex.Pattern

private val URL_RE =
    Pattern.compile(
        "https?://[a-zA-Z0-9._-]+(?:\\.firebaseio\\.com|\\.firebasedatabase\\.app)(?:/[^\\s,\"']*)?",
        Pattern.CASE_INSENSITIVE,
    )

fun extractFirebaseUrls(text: String): List<String> {
    val seen = LinkedHashSet<String>()
    val m = URL_RE.matcher(text)
    while (m.find()) {
        var u = m.group().trim().trimEnd(',').trim('"', '\'')
        u = u.substringBefore(" ").trim()
        val norm = normalizeFirebaseUrl(u)
        seen.add(norm)
    }
    return seen.toList()
}

fun normalizeFirebaseUrl(raw: String): String {
    var s = raw.trim().trimEnd('/')
    if (!s.startsWith("http")) s = "https://$s"
    val uri = java.net.URI(s)
    return "${uri.scheme}://${uri.host}".trimEnd('/')
}
