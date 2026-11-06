package com.firebasepanel.sms

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBalance
import androidx.compose.material.icons.filled.FlashOn
import androidx.compose.material.icons.filled.FolderOpen
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.UploadFile
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.OutlinedTextFieldDefaults
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.firebasepanel.sms.domain.ConnectionFilter
import com.firebasepanel.sms.domain.FilterConfig
import com.firebasepanel.sms.domain.InboxMode
import com.firebasepanel.sms.domain.PinFilter
import com.firebasepanel.sms.domain.SortMode
import com.firebasepanel.sms.ui.DeviceRow
import com.firebasepanel.sms.ui.FirebasePanelTheme
import com.firebasepanel.sms.ui.LiveSmsRow
import com.firebasepanel.sms.ui.PanelViewModel
import com.firebasepanel.sms.ui.SmsRow
import com.firebasepanel.sms.ui.VirtusColors
import java.text.NumberFormat
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MainActivity : ComponentActivity() {
    private val vm: PanelViewModel by viewModels()

    private val pickTxt =
        registerForActivityResult(ActivityResultContracts.OpenDocument()) { uri ->
            if (uri != null) {
                vm.loadUrlsFromTxt(this, uri)
            }
        }

    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            FirebasePanelTheme {
                val state by vm.state.collectAsState()
                val sheetState = rememberModalBottomSheetState(skipPartiallyExpanded = true)

                Box(
                    modifier =
                        Modifier
                            .fillMaxSize()
                            .background(VirtusColors.bg),
                ) {
                    LazyColumn(
                        modifier =
                            Modifier
                                .fillMaxSize()
                                .padding(horizontal = 14.dp, vertical = 10.dp),
                    ) {
                        item {
                            VirtusHeader()
                            Spacer(Modifier.height(10.dp))
                            TopActionRow(
                                onTxt = { pickTxt.launch(arrayOf("text/*", "application/octet-stream")) },
                                onFetchLive = {
                                    vm.setAutoLiveRefresh(true)
                                    vm.refreshNow()
                                },
                                onExport = { vm.exportDeviceListTxt() },
                                panels = state.urlsLoaded,
                                fetchEnabled = !state.fetching && state.urlsLoaded > 0,
                                exportEnabled = state.devices.isNotEmpty(),
                            )
                            Spacer(Modifier.height(12.dp))
                            DashboardMetrics(state = state)
                            Spacer(Modifier.height(12.dp))
                            SearchBar(
                                query = state.searchQuery,
                                onQueryChange = { vm.setSearchQuery(it) },
                            )
                            Spacer(Modifier.height(10.dp))
                            FilterDashboard(vm = vm, cfg = state.config)
                            Spacer(Modifier.height(10.dp))
                            ActiveStrip(cfg = state.config)
                            Spacer(Modifier.height(10.dp))
                            StartFetchButton(
                                busy = state.fetching,
                                enabled = !state.fetching && state.urlsLoaded > 0,
                                onClick = { vm.refreshNow() },
                            )
                        }
                        if (state.fetching) {
                            item {
                                Row(
                                    Modifier
                                        .fillMaxWidth()
                                        .padding(top = 8.dp),
                                    verticalAlignment = Alignment.CenterVertically,
                                ) {
                                    CircularProgressIndicator(
                                        modifier = Modifier.size(22.dp),
                                        color = VirtusColors.orange,
                                        strokeWidth = 2.dp,
                                    )
                                    Spacer(Modifier.width(10.dp))
                                    Text(
                                        state.progress.ifEmpty { "Fetching…" },
                                        color = VirtusColors.yellow,
                                        fontSize = 13.sp,
                                    )
                                }
                            }
                        }
                        state.error?.let { err ->
                            item {
                                Text(
                                    err,
                                    color = MaterialTheme.colorScheme.error,
                                    fontSize = 12.sp,
                                    modifier = Modifier.padding(top = 6.dp),
                                )
                            }
                        }
                        if (!state.fetching && state.lastFetchEpochMs > 0L) {
                            item {
                                Text(
                                    "Last sync: ${formatTs(state.lastFetchEpochMs)}",
                                    color = VirtusColors.onMuted,
                                    fontSize = 11.sp,
                                    modifier = Modifier.padding(top = 4.dp),
                                )
                            }
                        }
                        item {
                            Spacer(Modifier.height(8.dp))
                            Text(
                                "TXT upload → Fetch Live",
                                color = VirtusColors.yellow.copy(alpha = 0.85f),
                                fontSize = 11.sp,
                                modifier = Modifier.fillMaxWidth(),
                                textAlign = TextAlign.Center,
                            )
                            Spacer(Modifier.height(6.dp))
                            Row(
                                modifier = Modifier.fillMaxWidth(),
                                verticalAlignment = Alignment.CenterVertically,
                            ) {
                                Text(
                                    "Live SMS",
                                    color = VirtusColors.green,
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 14.sp,
                                )
                                Spacer(Modifier.weight(1f))
                                Icon(
                                    Icons.Filled.AccountBalance,
                                    contentDescription = null,
                                    tint = VirtusColors.blue,
                                    modifier = Modifier.size(22.dp),
                                )
                            }
                        }
                        if (state.liveFeedSms.isEmpty()) {
                            item {
                                Text(
                                    "Fetch ke baad yahan recent SMS dikhenge",
                                    color = VirtusColors.onMuted,
                                    fontSize = 12.sp,
                                    modifier = Modifier.padding(vertical = 8.dp),
                                )
                            }
                        } else {
                            items(state.liveFeedSms) { row ->
                                LiveSmsCard(row)
                            }
                        }
                        item {
                            HorizontalDivider(
                                color = VirtusColors.onMuted.copy(alpha = 0.25f),
                                modifier = Modifier.padding(vertical = 8.dp),
                            )
                            Text(
                                "Devices (${state.devices.size})",
                                color = Color.White,
                                fontWeight = FontWeight.SemiBold,
                                fontSize = 14.sp,
                            )
                            Spacer(Modifier.height(6.dp))
                        }
                        items(state.devices) { row ->
                            DeviceCardVirtus(row) { vm.selectDevice(row) }
                        }
                    }
                }

                state.selected?.let { d ->
                    ModalBottomSheet(
                        onDismissRequest = { vm.clearSelection() },
                        sheetState = sheetState,
                        containerColor = VirtusColors.card,
                    ) {
                        Column(Modifier.padding(16.dp).fillMaxWidth()) {
                            Text("Device", style = MaterialTheme.typography.labelMedium, color = VirtusColors.orange)
                            Text(d.deviceId, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold, color = Color.White)
                            Spacer(Modifier.height(4.dp))
                            Text(
                                d.firebaseUrl,
                                style = MaterialTheme.typography.bodySmall,
                                color = VirtusColors.onMuted,
                            )
                            Row {
                                Text(
                                    if (d.online) "Online" else "Offline",
                                    color = if (d.online) VirtusColors.green else VirtusColors.onMuted,
                                )
                                Text(
                                    "  ·  PIN device: ${if (d.deviceHasPin) "Yes" else "No"}",
                                    color = VirtusColors.onMuted,
                                    modifier = Modifier.padding(start = 8.dp),
                                )
                            }
                            HorizontalDivider(Modifier.padding(vertical = 12.dp), color = VirtusColors.onMuted.copy(alpha = 0.3f))
                            Text("${d.messages.size} messages", style = MaterialTheme.typography.labelLarge, color = Color.White)
                            Column(
                                modifier =
                                    Modifier
                                        .fillMaxWidth()
                                        .heightIn(max = 420.dp)
                                        .verticalScroll(rememberScrollState()),
                            ) {
                                d.messages.forEach { m -> SmsBubbleVirtus(m) }
                            }
                            Spacer(Modifier.height(24.dp))
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun VirtusHeader() {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Box(
            modifier =
                Modifier
                    .size(44.dp)
                    .clip(RoundedCornerShape(10.dp))
                    .background(VirtusColors.orange),
            contentAlignment = Alignment.Center,
        ) {
            Text("₹", color = VirtusColors.yellow, fontWeight = FontWeight.Black, fontSize = 22.sp)
        }
        Spacer(Modifier.width(12.dp))
        Column {
            Text(
                "Virtus Panel Viewer Pro",
                color = Color.White,
                fontWeight = FontWeight.Bold,
                fontSize = 18.sp,
            )
            Text(
                "Firebase + live SMS",
                color = VirtusColors.onMuted,
                fontSize = 12.sp,
            )
        }
    }
}

@Composable
private fun TopActionRow(
    onTxt: () -> Unit,
    onFetchLive: () -> Unit,
    onExport: () -> Unit,
    panels: Int,
    fetchEnabled: Boolean,
    exportEnabled: Boolean,
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        VirtusSmallButton(
            onClick = onTxt,
            container = VirtusColors.card,
            content = VirtusColors.yellow,
            icon = { Icon(Icons.Filled.FolderOpen, null) },
            label = "TXT",
        )
        Button(
            onClick = onFetchLive,
            enabled = fetchEnabled,
            modifier = Modifier.weight(1f),
            shape = RoundedCornerShape(14.dp),
            colors =
                ButtonDefaults.buttonColors(
                    containerColor = VirtusColors.orange,
                    contentColor = Color.White,
                    disabledContainerColor = VirtusColors.card,
                    disabledContentColor = VirtusColors.onMuted,
                ),
        ) {
            Icon(Icons.Filled.FlashOn, contentDescription = null, modifier = Modifier.size(18.dp))
            Spacer(Modifier.width(6.dp))
            Text("Fetch Live", fontWeight = FontWeight.Bold)
        }
        VirtusSmallButton(
            onClick = onExport,
            container = VirtusColors.card,
            content = VirtusColors.yellow,
            enabled = exportEnabled,
            icon = { Icon(Icons.Filled.UploadFile, null) },
            label = "Export",
        )
        Text(
            "$panels",
            color = VirtusColors.onMuted,
            fontSize = 12.sp,
            modifier = Modifier.padding(start = 2.dp),
        )
    }
}

@Composable
private fun VirtusSmallButton(
    onClick: () -> Unit,
    container: Color,
    content: Color,
    label: String,
    icon: @Composable () -> Unit,
    enabled: Boolean = true,
) {
    Button(
        onClick = onClick,
        enabled = enabled,
        modifier = Modifier.height(44.dp),
        shape = RoundedCornerShape(14.dp),
        colors =
            ButtonDefaults.buttonColors(
                containerColor = container,
                contentColor = content,
                disabledContainerColor = VirtusColors.card,
                disabledContentColor = VirtusColors.onMuted,
            ),
        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 8.dp),
    ) {
        icon()
        Spacer(Modifier.width(4.dp))
        Text(label, fontSize = 12.sp, fontWeight = FontWeight.SemiBold)
    }
}

@Composable
private fun DashboardMetrics(state: com.firebasepanel.sms.ui.UiState) {
    val devices = state.devices
    val totalDev = devices.size
    val onlineDev = devices.count { it.online }
    val maxBal = devices.maxOfOrNull { it.maxBalance } ?: 0.0
    val totalSms = devices.sumOf { it.smsCount }
    val nf = NumberFormat.getNumberInstance(Locale.US)
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        MetricCard("DEVICES", totalDev.toString(), VirtusColors.orange, Modifier.weight(1f))
        MetricCard("ONLINE", onlineDev.toString(), VirtusColors.green, Modifier.weight(1f))
        MetricCard(
            "BALANCE",
            if (maxBal > 0) "₹${nf.format(maxBal.toLong())}" else "—",
            VirtusColors.yellow,
            Modifier.weight(1f),
        )
    }
    Spacer(Modifier.height(8.dp))
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        MetricCard("BANK SMS", totalSms.toString(), VirtusColors.blue, Modifier.weight(1f))
        MetricCard("PANELS", state.urlsLoaded.toString(), VirtusColors.green, Modifier.weight(1f))
        Spacer(Modifier.weight(1f))
    }
}

@Composable
private fun MetricCard(
    title: String,
    value: String,
    valueColor: Color,
    modifier: Modifier = Modifier,
) {
    Card(
        modifier = modifier,
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = VirtusColors.card),
    ) {
        Column(Modifier.padding(horizontal = 10.dp, vertical = 10.dp)) {
            Text(title, color = VirtusColors.onMuted, fontSize = 10.sp, letterSpacing = 0.5.sp)
            Spacer(Modifier.height(4.dp))
            Text(
                value,
                color = valueColor,
                fontWeight = FontWeight.Bold,
                fontSize = 16.sp,
                maxLines = 1,
                overflow = TextOverflow.Ellipsis,
            )
        }
    }
}

@Composable
private fun SearchBar(
    query: String,
    onQueryChange: (String) -> Unit,
) {
    OutlinedTextField(
        value = query,
        onValueChange = onQueryChange,
        modifier = Modifier.fillMaxWidth(),
        placeholder = { Text("Search Here", color = VirtusColors.onMuted) },
        leadingIcon = {
            Icon(Icons.Filled.Search, contentDescription = null, tint = VirtusColors.onMuted)
        },
        singleLine = true,
        shape = RoundedCornerShape(16.dp),
        colors =
            OutlinedTextFieldDefaults.colors(
                focusedContainerColor = VirtusColors.card,
                unfocusedContainerColor = VirtusColors.card,
                focusedBorderColor = VirtusColors.orange.copy(alpha = 0.6f),
                unfocusedBorderColor = VirtusColors.onMuted.copy(alpha = 0.3f),
                focusedTextColor = Color.White,
                unfocusedTextColor = Color.White,
                cursorColor = VirtusColors.yellow,
            ),
    )
}

@Composable
private fun FilterDashboard(
    vm: PanelViewModel,
    cfg: FilterConfig,
) {
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("Mode", color = VirtusColors.onMuted, fontSize = 11.sp, fontWeight = FontWeight.Medium)
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(6.dp),
        ) {
            VirtusFilterPill(
                selected = cfg.inboxMode == InboxMode.BANK_FILTERED,
                label = "Bank+Band",
                emoji = "🏦",
                onClick = { vm.setInboxMode(InboxMode.BANK_FILTERED) },
            )
            VirtusFilterPill(
                selected = cfg.inboxMode == InboxMode.BANK_ALL,
                label = "All bank",
                emoji = "🏛",
                onClick = { vm.setInboxMode(InboxMode.BANK_ALL) },
            )
            VirtusFilterPill(
                selected = cfg.inboxMode == InboxMode.OTP_AND_ALERTS,
                label = "OTP",
                emoji = "📱",
                onClick = { vm.setInboxMode(InboxMode.OTP_AND_ALERTS) },
            )
            VirtusFilterPill(
                selected = cfg.inboxMode == InboxMode.FULL_INBOX,
                label = "Full",
                emoji = "📥",
                onClick = { vm.setInboxMode(InboxMode.FULL_INBOX) },
            )
        }
        if (cfg.inboxMode == InboxMode.BANK_FILTERED || cfg.inboxMode == InboxMode.BANK_ALL) {
            Text("Balance", color = VirtusColors.onMuted, fontSize = 11.sp, fontWeight = FontWeight.Medium)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                VirtusFilterPill(
                    selected = cfg.sortMode == SortMode.HIGH_TO_LOW,
                    label = "High 50K–90L",
                    emoji = "⬇",
                    onClick = { vm.updateConfig { it.copy(sortMode = SortMode.HIGH_TO_LOW) } },
                )
                VirtusFilterPill(
                    selected = cfg.sortMode == SortMode.LOW_TO_HIGH,
                    label = "Low→High 2K–50K",
                    emoji = "⬆",
                    onClick = { vm.updateConfig { it.copy(sortMode = SortMode.LOW_TO_HIGH) } },
                )
            }
            Text("PIN (device)", color = VirtusColors.onMuted, fontSize = 11.sp, fontWeight = FontWeight.Medium)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                VirtusFilterPill(
                    selected = cfg.pinFilter == PinFilter.WITH,
                    label = "PIN",
                    emoji = "🔑",
                    onClick = { vm.updateConfig { it.copy(pinFilter = PinFilter.WITH) } },
                )
                VirtusFilterPill(
                    selected = cfg.pinFilter == PinFilter.WITHOUT,
                    label = "No PIN",
                    emoji = "🚫",
                    onClick = { vm.updateConfig { it.copy(pinFilter = PinFilter.WITHOUT) } },
                )
                VirtusFilterPill(
                    selected = cfg.pinFilter == PinFilter.BOTH,
                    label = "Both",
                    emoji = "➕",
                    onClick = { vm.updateConfig { it.copy(pinFilter = PinFilter.BOTH) } },
                )
            }
        }
        Text("Connection", color = VirtusColors.onMuted, fontSize = 11.sp, fontWeight = FontWeight.Medium)
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(6.dp),
        ) {
            VirtusFilterPill(
                selected = cfg.connection == ConnectionFilter.ONLINE,
                label = "Online",
                emoji = "🟢",
                onClick = { vm.updateConfig { it.copy(connection = ConnectionFilter.ONLINE) } },
            )
            VirtusFilterPill(
                selected = cfg.connection == ConnectionFilter.OFFLINE,
                label = "Offline",
                emoji = "⚪",
                onClick = { vm.updateConfig { it.copy(connection = ConnectionFilter.OFFLINE) } },
            )
            VirtusFilterPill(
                selected = cfg.connection == ConnectionFilter.BOTH,
                label = "Both",
                emoji = "🔁",
                onClick = { vm.updateConfig { it.copy(connection = ConnectionFilter.BOTH) } },
            )
        }
        Text("SMS age", color = VirtusColors.onMuted, fontSize = 11.sp, fontWeight = FontWeight.Medium)
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(6.dp),
        ) {
            listOf(1, 3, 7, 15, 30).forEach { d ->
                VirtusFilterPill(
                    selected = cfg.days == d,
                    label = "${d}d",
                    emoji = "🕐",
                    compact = true,
                    onClick = { vm.updateConfig { it.copy(days = d) } },
                )
            }
            VirtusFilterPill(
                selected = cfg.days == null,
                label = "All",
                emoji = "∞",
                compact = true,
                onClick = { vm.updateConfig { it.copy(days = null) } },
            )
        }
    }
}

@Composable
private fun VirtusFilterPill(
    selected: Boolean,
    label: String,
    emoji: String,
    onClick: () -> Unit,
    compact: Boolean = false,
) {
    val bg = if (selected) VirtusColors.orange.copy(alpha = 0.35f) else VirtusColors.card
    val border = if (selected) VirtusColors.yellow else VirtusColors.onMuted.copy(alpha = 0.2f)
    val padH = if (compact) 8.dp else 10.dp
    Row(
        modifier =
            Modifier
                .clip(RoundedCornerShape(20.dp))
                .background(bg)
                .border(1.dp, border, RoundedCornerShape(20.dp))
                .clickable(onClick = onClick)
                .padding(horizontal = padH, vertical = 8.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text(emoji, fontSize = if (compact) 11.sp else 13.sp)
        Spacer(Modifier.width(4.dp))
        Text(
            label,
            color = if (selected) VirtusColors.yellow else Color.White,
            fontSize = if (compact) 11.sp else 12.sp,
            fontWeight = if (selected) FontWeight.Bold else FontWeight.Normal,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
        )
    }
}

@Composable
private fun ActiveStrip(cfg: FilterConfig) {
    val parts = mutableListOf<String>()
    parts.add(
        when (cfg.inboxMode) {
            InboxMode.BANK_FILTERED -> "Bank+Band"
            InboxMode.BANK_ALL -> "All bank"
            InboxMode.OTP_AND_ALERTS -> "OTP/Alerts"
            InboxMode.FULL_INBOX -> "Full inbox"
        },
    )
    if (cfg.inboxMode == InboxMode.BANK_FILTERED || cfg.inboxMode == InboxMode.BANK_ALL) {
        parts.add(
            when (cfg.sortMode) {
                SortMode.HIGH_TO_LOW -> "High→Low"
                SortMode.LOW_TO_HIGH -> "Low→High"
            },
        )
        parts.add(
            when (cfg.pinFilter) {
                PinFilter.WITH -> "PIN"
                PinFilter.WITHOUT -> "No PIN"
                PinFilter.BOTH -> "PIN both"
            },
        )
    }
    parts.add(
        when (cfg.connection) {
            ConnectionFilter.ONLINE -> "Online"
            ConnectionFilter.OFFLINE -> "Offline"
            ConnectionFilter.BOTH -> "Conn both"
        },
    )
    parts.add(
        when (cfg.days) {
            null -> "All time"
            else -> "${cfg.days}d"
        },
    )
    Row(
        modifier =
            Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(14.dp))
                .background(VirtusColors.card)
                .border(1.dp, VirtusColors.onMuted.copy(alpha = 0.2f), RoundedCornerShape(14.dp))
                .padding(horizontal = 12.dp, vertical = 10.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        Text("ACTIVE", color = VirtusColors.green, fontWeight = FontWeight.Bold, fontSize = 11.sp)
        Spacer(Modifier.width(10.dp))
        Row(
            horizontalArrangement = Arrangement.spacedBy(6.dp),
            modifier = Modifier.weight(1f),
        ) {
            parts.forEach { p ->
                Box(
                    modifier =
                        Modifier
                            .clip(RoundedCornerShape(12.dp))
                            .background(VirtusColors.orange.copy(alpha = 0.25f))
                            .padding(horizontal = 8.dp, vertical = 4.dp),
                ) {
                    Text(p, color = VirtusColors.yellow, fontSize = 10.sp, maxLines = 1, overflow = TextOverflow.Ellipsis)
                }
            }
        }
    }
}

@Composable
private fun StartFetchButton(
    busy: Boolean,
    enabled: Boolean,
    onClick: () -> Unit,
) {
    Button(
        onClick = onClick,
        enabled = enabled && !busy,
        modifier =
            Modifier
                .fillMaxWidth()
                .height(52.dp),
        shape = RoundedCornerShape(16.dp),
        colors =
            ButtonDefaults.buttonColors(
                containerColor = VirtusColors.green,
                contentColor = Color(0xFF052E16),
                disabledContainerColor = VirtusColors.card,
                disabledContentColor = VirtusColors.onMuted,
            ),
    ) {
        if (busy) {
            CircularProgressIndicator(
                modifier = Modifier.size(22.dp),
                color = Color(0xFF052E16),
                strokeWidth = 2.dp,
            )
            Spacer(Modifier.width(10.dp))
            Text("Fetching…", fontWeight = FontWeight.Bold)
        } else {
            Icon(Icons.Filled.PlayArrow, contentDescription = null)
            Spacer(Modifier.width(8.dp))
            Text("Start Fetch", fontWeight = FontWeight.Bold, fontSize = 16.sp)
        }
    }
}

@Composable
private fun LiveSmsCard(row: LiveSmsRow) {
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 4.dp),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = VirtusColors.card.copy(alpha = 0.92f)),
    ) {
        Column(Modifier.padding(10.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text(
                    "From: ${row.sender}",
                    color = VirtusColors.yellow,
                    fontWeight = FontWeight.Bold,
                    fontSize = 12.sp,
                    modifier = Modifier.weight(1f),
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
                Text(
                    formatTs(row.messageAtMillis ?: 0L),
                    color = VirtusColors.onMuted,
                    fontSize = 10.sp,
                )
            }
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    row.deviceId,
                    color = if (row.online) VirtusColors.green else VirtusColors.onMuted,
                    fontSize = 10.sp,
                )
                Text(" · ", color = VirtusColors.onMuted, fontSize = 10.sp)
                Text(row.kindLabel, color = VirtusColors.blue, fontSize = 10.sp)
            }
            if (row.balance != null) {
                Text(
                    "₹ ${formatInr(row.balance)}",
                    color = VirtusColors.orange,
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 12.sp,
                )
            }
            Text(
                row.body,
                color = Color.White.copy(alpha = 0.92f),
                fontSize = 11.sp,
                maxLines = 3,
                overflow = TextOverflow.Ellipsis,
                modifier = Modifier.padding(top = 4.dp),
            )
        }
    }
}

@Composable
private fun DeviceCardVirtus(
    row: DeviceRow,
    onClick: () -> Unit,
) {
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 5.dp)
                .clickable(onClick = onClick),
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.cardColors(containerColor = VirtusColors.card),
    ) {
        Column(Modifier.padding(12.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text(
                    row.deviceId,
                    color = Color.White,
                    fontWeight = FontWeight.Bold,
                    fontSize = 14.sp,
                    modifier = Modifier.weight(1f),
                    maxLines = 1,
                    overflow = TextOverflow.Ellipsis,
                )
                Text(
                    if (row.online) "ON" else "OFF",
                    color = if (row.online) VirtusColors.green else VirtusColors.onMuted,
                    fontWeight = FontWeight.Bold,
                    fontSize = 12.sp,
                )
            }
            Text(
                "₹ ${formatInr(row.maxBalance)} max · ${row.smsCount} SMS · ${if (row.deviceHasPin) "🔑 PIN" else "No PIN"}",
                color = VirtusColors.orange,
                fontSize = 12.sp,
            )
            if (row.previewSender.isNotEmpty()) {
                Text(
                    "Latest: ${row.previewSender}",
                    color = VirtusColors.onMuted,
                    fontSize = 10.sp,
                )
            }
            Text(
                row.firebaseUrl,
                color = VirtusColors.onMuted,
                fontSize = 10.sp,
                maxLines = 2,
                overflow = TextOverflow.Ellipsis,
            )
        }
    }
}

@Composable
private fun SmsBubbleVirtus(msg: SmsRow) {
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 6.dp),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = VirtusColors.bg),
    ) {
        Column(Modifier.padding(12.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        "From: ${msg.sender}",
                        color = VirtusColors.yellow,
                        fontWeight = FontWeight.Bold,
                        fontSize = 13.sp,
                    )
                    Text(msg.kindLabel, color = VirtusColors.blue, fontSize = 10.sp)
                }
                Text(formatTs(msg.messageAtMillis ?: 0L), color = VirtusColors.onMuted, fontSize = 10.sp)
            }
            if (msg.balance != null) {
                Text("₹ ${formatInr(msg.balance)}", color = VirtusColors.orange, fontWeight = FontWeight.SemiBold)
            }
            if (msg.hasPinText) {
                Text("PIN-related SMS", color = VirtusColors.red, fontSize = 10.sp)
            }
            Text(msg.body, color = Color.White.copy(alpha = 0.9f), fontSize = 12.sp, modifier = Modifier.padding(top = 6.dp))
        }
    }
}

private fun formatInr(v: Double): String {
    val nf = NumberFormat.getNumberInstance(Locale.US)
    return nf.format(v.toLong())
}

private fun formatTs(ms: Long): String {
    if (ms <= 0L) return "—"
    return SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.US).format(Date(ms))
}
