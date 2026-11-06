package com.firebasepanel.sms.domain

import java.util.Calendar
import java.util.Locale
import java.util.regex.Pattern

/** Bank SMS + balance — spam/junk ko hatao (standalone; repo ke bots se alag). */

private val MONEY = Pattern.compile("(?:Rs\\.?|INR|₹)\\s*([\\d,]+(?:\\.\\d{1,2})?)", Pattern.CASE_INSENSITIVE)
private val AVL_PATTERNS = listOf(
    Pattern.compile(
        "(?:available|avl\\.?)\\s*(?:bal\\.?|balance)?\\s*[:.]?\\s*(?:is\\s*)?(?:Rs\\.?|INR|₹)?\\s*([\\d,]+(?:\\.\\d{1,2})?)",
        Pattern.CASE_INSENSITIVE,
    ),
    Pattern.compile(
        "(?:a/c|ac)\\s*(?:bal\\.?|balance)\\s*[:.]?\\s*(?:Rs\\.?|INR|₹)?\\s*([\\d,]+(?:\\.\\d{1,2})?)",
        Pattern.CASE_INSENSITIVE,
    ),
)

private val BANK_HINT =
    Pattern.compile(
        "\\b(?:bank|sbi|hdfc|icici|axis|kotak|pnb|bob|idfc|yes|canara|union|paytm|phonepe|gpay|credit|debit)\\b",
        Pattern.CASE_INSENSITIVE,
    )
private val TXN_HINT =
    Pattern.compile(
        "\\b(?:credited|debited|credit|debit|avl|available|a/c|ac\\s*bal|balance|sent|received|paid|upi)\\b",
        Pattern.CASE_INSENSITIVE,
    )
private val SPAM_PHRASE =
    Pattern.compile(
        "(?:dear staffn|gaming wallet|click to view|loan approved|win\\+\\s*rs|lottery|free recharge)",
        Pattern.CASE_INSENSITIVE,
    )
private val PIN_PATTERN =
    Pattern.compile(
        "\\b(?:upi\\s*pin|mpin|m-pin|atm\\s*pin|pin\\s*set|set\\s+(?:your\\s+)?(?:upi\\s+)?pin)\\b",
        Pattern.CASE_INSENSITIVE,
    )

fun parseAmount(s: String): Double? {
    var best: Double? = null
    for (p in AVL_PATTERNS) {
        val m = p.matcher(s)
        while (m.find()) {
            val v = m.group(1).replace(",", "").toDoubleOrNull() ?: continue
            best = maxOf(best ?: 0.0, v)
        }
    }
    val m2 = MONEY.matcher(s)
    while (m2.find()) {
        val v = m2.group(1).replace(",", "").toDoubleOrNull() ?: continue
        if (best == null || v > best) best = v
    }
    return best
}

fun messageHasPinText(body: String): Boolean = PIN_PATTERN.matcher(body).find()

fun isJunkSms(body: String, sender: String): Boolean {
    val blob = "$sender $body"
    if (SPAM_PHRASE.matcher(blob).find()) return true
    return false
}

fun isBankLikeSms(body: String, sender: String): Boolean {
    if (isJunkSms(body, sender)) return false
    val blob = "$sender $body"
    val hasMoney = parseAmount(body) != null
    val bank = BANK_HINT.matcher(blob).find()
    val txn = TXN_HINT.matcher(blob).find()
    return (bank && (txn || hasMoney)) || (txn && hasMoney)
}

fun mainBalanceForSort(body: String): Double? = parseAmount(body)

enum class SortMode { HIGH_TO_LOW, LOW_TO_HIGH }

enum class PinFilter { WITH, WITHOUT, BOTH }

enum class ConnectionFilter { ONLINE, OFFLINE, BOTH }

data class FilterConfig(
    val sortMode: SortMode,
    val pinFilter: PinFilter,
    val connection: ConnectionFilter,
    val days: Int?, // null = all time
    val lowMin: Double = 2_000.0,
    val lowMax: Double = 50_000.0,
    val highMin: Double = 50_000.0,
    val highMax: Double = 9_000_000.0, // 90 lakh
)

fun balanceInRangeForSort(amount: Double?, config: FilterConfig): Boolean {
    if (amount == null) return false
    return when (config.sortMode) {
        SortMode.LOW_TO_HIGH -> amount in config.lowMin..config.lowMax
        SortMode.HIGH_TO_LOW -> amount in config.highMin..config.highMax
    }
}

fun daysCutoff(days: Int?): Calendar? {
    if (days == null) return null
    return Calendar.getInstance(Locale.US).apply { add(Calendar.DAY_OF_YEAR, -days) }
}

fun messageWithinDays(messageAtMillis: Long?, body: String, days: Int?): Boolean {
    if (days == null) return true
    val cutoff = daysCutoff(days) ?: return true
    val t = messageAtMillis ?: return true
    return t >= cutoff.timeInMillis
}
