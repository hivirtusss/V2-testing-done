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
        "\\b(?:bank|sbi|hdfc|icici|axis|kotak|pnb|bob|idfc|yes|canara|union|indusind|federal|rbl|dcb|tap|uco|iob|" +
            "paytm|phonepe|gpay|google\\s*pay|bharatpe|cred|razorpay|airtel|jio\\s*payments|nbad|wallets)\\b",
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
            val v = m.group(1)?.replace(",", "")?.toDoubleOrNull() ?: continue
            best = maxOf(best ?: 0.0, v)
        }
    }
    val m2 = MONEY.matcher(s)
    while (m2.find()) {
        val v = m2.group(1)?.replace(",", "")?.toDoubleOrNull() ?: continue
        if (best == null || v > best) best = v
    }
    return best
}

fun messageHasPinText(body: String): Boolean = PIN_PATTERN.matcher(body).find()

private val OTP_HINT =
    Pattern.compile(
        "\\b(?:otp|o\\.?t\\.?p\\.?|one[-\\s]?time\\s+password|verification\\s+code|is your|use otp)\\b",
        Pattern.CASE_INSENSITIVE,
    )
private val TELCO_SENDER =
    Pattern.compile(
        "^(?:JIO|JIOTP|V[IT]-|AIRTEL|BSNL|IDEA|VODAFONE|MTNL|DOT|DM-|\\+?91)", Pattern.CASE_INSENSITIVE,
    )

/** Hard spam — hamesha hatao. Baaki SMS (OTP, bank, offers) user dekh sakta. */
fun isHardSpamOnly(body: String, sender: String): Boolean {
    val blob = "$sender $body"
    if (SPAM_PHRASE.matcher(blob).find()) return true
    if (Pattern.compile("(?:bit\\.ly|tinyurl|t\\.me/|cutt\\.ly)", Pattern.CASE_INSENSITIVE).matcher(blob).find()) {
        return true
    }
    return false
}

fun isOtpOrServiceSms(body: String, sender: String): Boolean {
    if (isHardSpamOnly(body, sender)) return false
    val b = body.trim()
    if (b.length < 4) return false
    if (OTP_HINT.matcher(b).find()) return true
    if (TELCO_SENDER.matcher(sender.trim()).find()) return true
    val low = b.lowercase()
    if ("jio" in low && (OTP_HINT.matcher(b).find() || Regex("\\b\\d{4,8}\\b").containsMatchIn(b))) return true
    return false
}

fun isJunkSms(body: String, sender: String): Boolean = isHardSpamOnly(body, sender)

fun isBankLikeSms(body: String, sender: String): Boolean {
    if (isHardSpamOnly(body, sender)) return false
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

enum class InboxMode {
    /** Bank SMS + balance band (High/Low sort) */
    BANK_FILTERED,
    /** Saari bank/txn SMS — amount band mat lagao */
    BANK_ALL,
    /** OTP / Jio / telco / net banking OTP — sender ID dikhega */
    OTP_AND_ALERTS,
    /** Jo device Firebase pe hai — spam short-links hata ke sab (purani + nayi) */
    FULL_INBOX,
}

data class FilterConfig(
    val sortMode: SortMode,
    val pinFilter: PinFilter,
    val connection: ConnectionFilter,
    val days: Int?, // null = all time (purani SMS bhi)
    val inboxMode: InboxMode = InboxMode.BANK_FILTERED,
    /** Bank modes: sort device list by battery % instead of parsed balance */
    val sortByBattery: Boolean = false,
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

fun messageWithinDays(messageAtMillis: Long?, @Suppress("UNUSED_PARAMETER") body: String, days: Int?): Boolean {
    if (days == null) return true
    val cutoff = daysCutoff(days) ?: return true
    if (messageAtMillis == null) return true
    return messageAtMillis >= cutoff.timeInMillis
}

fun passesInboxMode(body: String, sender: String, cfg: FilterConfig): Boolean {
    when (cfg.inboxMode) {
        InboxMode.BANK_FILTERED -> {
            if (!isBankLikeSms(body, sender)) return false
            val bal = mainBalanceForSort(body)
            return balanceInRangeForSort(bal, cfg)
        }
        InboxMode.BANK_ALL -> return isBankLikeSms(body, sender)
        InboxMode.OTP_AND_ALERTS -> return isOtpOrServiceSms(body, sender)
        InboxMode.FULL_INBOX -> return !isHardSpamOnly(body, sender)
    }
}
