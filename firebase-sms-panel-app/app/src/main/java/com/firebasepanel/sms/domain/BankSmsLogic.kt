package com.firebasepanel.sms.domain

import java.util.Calendar
import java.util.Locale
import java.util.regex.Pattern

/** Bank SMS + balance — spam/junk ko hatao (standalone; repo ke bots se alag). */

/** Rs.10000 / Rs 10,000 / ₹500 — space optional after Rs. */
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
        "\\b(?:credited|debited|credit|debit|avl|available|a/c|ac\\s*bal|balance|sent|received|paid|pay|upi|" +
            "imps|neft|rtgs|transfer|transferred|withdrawn|withdrawal|deposited|txn|transaction|ref\\s*no|utr)\\b",
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

/** Preset balance band (bank filtered mode) — matches Virtus panel pill labels */
enum class BalanceTier {
    /** 2K – 50K bank band (sort dir = SortMode on config) */
    LOW_2K_50K,
    /** 50K – 90L “high balance” band (High→Low list) */
    HIGH_50K_90L,
    /** Legacy / unused in current Virtus-simple UI */
    MEDIUM_5K_1L,
    HIGH_1L_20L,
    BOOM_20L_90L,
}

fun tierRange(tier: BalanceTier): ClosedFloatingPointRange<Double> =
    when (tier) {
        BalanceTier.LOW_2K_50K -> 2_000.0..50_000.0
        BalanceTier.HIGH_50K_90L -> 50_000.0..9_000_000.0
        BalanceTier.MEDIUM_5K_1L -> 5_000.0..100_000.0
        BalanceTier.HIGH_1L_20L -> 100_000.0..2_000_000.0
        BalanceTier.BOOM_20L_90L -> 2_000_000.0..9_000_000.0
    }

fun amountInTier(amount: Double?, tier: BalanceTier): Boolean {
    if (amount == null) return false
    return amount in tierRange(tier)
}

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
    /** Bank filtered: which preset band (High 1L–20L, Boom, …) */
    val balanceTier: BalanceTier = BalanceTier.LOW_2K_50K,
    /** Bank modes: sort device list by battery % instead of parsed balance */
    val sortByBattery: Boolean = false,
    val lowMin: Double = 2_000.0,
    val lowMax: Double = 50_000.0,
    val highMin: Double = 50_000.0,
    val highMax: Double = 9_000_000.0, // 90 lakh — legacy; BANK_FILTERED uses balanceTier
)

fun balanceInRangeForSort(amount: Double?, config: FilterConfig): Boolean {
    if (amount == null) return false
    if (config.inboxMode == InboxMode.BANK_FILTERED) {
        return amountInTier(amount, config.balanceTier)
    }
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
            // Amount miss hone par bhi bank txn dikhao — tier tab "unknown" treat (list/sort me 0)
            if (bal == null) return true
            return balanceInRangeForSort(bal, cfg)
        }
        InboxMode.BANK_ALL -> return isBankLikeSms(body, sender)
        InboxMode.OTP_AND_ALERTS -> return isOtpOrServiceSms(body, sender)
        InboxMode.FULL_INBOX -> return !isHardSpamOnly(body, sender)
    }
}
