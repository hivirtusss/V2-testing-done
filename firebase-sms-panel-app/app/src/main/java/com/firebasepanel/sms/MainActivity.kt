package com.firebasepanel.sms

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.viewModels
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.CloudUpload
import androidx.compose.material.icons.filled.Refresh
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Switch
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.firebasepanel.sms.domain.ConnectionFilter
import com.firebasepanel.sms.domain.InboxMode
import com.firebasepanel.sms.domain.PinFilter
import com.firebasepanel.sms.domain.SortMode
import com.firebasepanel.sms.ui.FirebasePanelTheme
import com.firebasepanel.sms.ui.PanelViewModel
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

                Scaffold(
                    topBar = {
                        TopAppBar(
                            title = {
                                Column {
                                    Text("Firebase SMS Panel", style = MaterialTheme.typography.titleLarge)
                                    Text(
                                        "Sender ID + live fetch",
                                        style = MaterialTheme.typography.labelSmall,
                                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                                    )
                                }
                            },
                            actions = {
                                IconButton(onClick = { vm.refreshNow() }, enabled = !state.fetching && state.urlsLoaded > 0) {
                                    Icon(Icons.Default.Refresh, contentDescription = "Refresh")
                                }
                            },
                        )
                    },
                ) { padding ->
                    Column(
                        modifier =
                            Modifier
                                .fillMaxSize()
                                .padding(padding)
                                .padding(horizontal = 16.dp),
                    ) {
                        Row(
                            Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(8.dp),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            Button(
                                onClick = { pickTxt.launch(arrayOf("text/*", "application/octet-stream")) },
                                modifier = Modifier.weight(1f),
                            ) {
                                Icon(Icons.Default.CloudUpload, contentDescription = null)
                                Spacer(Modifier.width(8.dp))
                                Text("TXT — Firebase URLs")
                            }
                        }
                        Row(
                            Modifier.fillMaxWidth(),
                            verticalAlignment = Alignment.CenterVertically,
                        ) {
                            Text("Live refresh (45s)", modifier = Modifier.weight(1f))
                            Switch(
                                checked = state.autoLiveRefresh,
                                onCheckedChange = { vm.setAutoLiveRefresh(it) },
                                enabled = state.urlsLoaded > 0,
                            )
                        }
                        if (state.fetching) {
                            Row(verticalAlignment = Alignment.CenterVertically) {
                                CircularProgressIndicator(Modifier.padding(end = 8.dp))
                                Text("Fetching… ${state.progress}", style = MaterialTheme.typography.bodyMedium)
                            }
                        } else {
                            Text(
                                "${state.urlsLoaded} URLs · ${state.progress}",
                                style = MaterialTheme.typography.bodySmall,
                                color = MaterialTheme.colorScheme.onSurfaceVariant,
                            )
                            if (state.lastFetchEpochMs > 0) {
                                Text(
                                    "Last sync: ${formatTs(state.lastFetchEpochMs)}",
                                    style = MaterialTheme.typography.labelSmall,
                                    color = MaterialTheme.colorScheme.tertiary,
                                )
                            }
                        }
                        state.error?.let {
                            Text("Error: $it", color = MaterialTheme.colorScheme.error, modifier = Modifier.padding(vertical = 4.dp))
                        }

                        Spacer(Modifier.height(8.dp))
                        FilterSections(vm, state.config.inboxMode)
                        Spacer(Modifier.height(8.dp))
                        HorizontalDivider()

                        LazyColumn(modifier = Modifier.weight(1f)) {
                            items(state.devices) { row ->
                                DeviceCard(row) { vm.selectDevice(row) }
                            }
                        }
                    }
                }

                state.selected?.let { d ->
                    ModalBottomSheet(
                        onDismissRequest = { vm.clearSelection() },
                        sheetState = sheetState,
                    ) {
                        Column(Modifier.padding(16.dp).fillMaxWidth()) {
                            Text("Device", style = MaterialTheme.typography.labelMedium, color = MaterialTheme.colorScheme.primary)
                            Text(d.deviceId, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                            Spacer(Modifier.height(4.dp))
                            Text(d.firebaseUrl, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
                            Row {
                                Text(if (d.online) "🟢 Online" else "🔴 Offline")
                                Text("  ·  PIN device: ${if (d.deviceHasPin) "Yes" else "No"}", modifier = Modifier.padding(start = 8.dp))
                            }
                            HorizontalDivider(Modifier.padding(vertical = 12.dp))
                            Text("${d.messages.size} messages", style = MaterialTheme.typography.labelLarge)
                            Column(
                                modifier =
                                    Modifier
                                        .fillMaxWidth()
                                        .height(420.dp)
                                        .verticalScroll(rememberScrollState()),
                            ) {
                                d.messages.forEach { m -> SmsBubble(m) }
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
private fun DeviceCard(row: com.firebasepanel.sms.ui.DeviceRow, onClick: () -> Unit) {
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 6.dp)
                .clickable(onClick = onClick),
        colors =
            CardDefaults.cardColors(
                containerColor = MaterialTheme.colorScheme.surfaceVariant,
            ),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp),
    ) {
        Column(Modifier.padding(14.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Text(row.deviceId, fontWeight = FontWeight.SemiBold, style = MaterialTheme.typography.titleSmall)
                Text(
                    if (row.online) "🟢" else "🔴",
                    style = MaterialTheme.typography.titleMedium,
                )
            }
            Text(
                "₹ ${formatInr(row.maxBalance)} max · ${row.smsCount} msgs",
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.primary,
            )
            if (row.previewSender.isNotEmpty()) {
                Text(
                    "Latest sender: ${row.previewSender}",
                    style = MaterialTheme.typography.labelSmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
            Text(
                row.firebaseUrl,
                style = MaterialTheme.typography.bodySmall,
                color = MaterialTheme.colorScheme.onSurfaceVariant,
                maxLines = 2,
            )
        }
    }
}

@Composable
private fun SmsBubble(m: SmsRow) {
    Card(
        modifier =
            Modifier
                .fillMaxWidth()
                .padding(vertical = 6.dp),
        colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
    ) {
        Column(Modifier.padding(12.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Column(modifier = Modifier.weight(1f)) {
                    Text("From: ${m.sender}", fontWeight = FontWeight.Bold, style = MaterialTheme.typography.bodyMedium)
                    Text(m.kindLabel, style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.tertiary)
                }
                Text(formatTs(m.messageAtMillis ?: 0L), style = MaterialTheme.typography.labelSmall)
            }
            if (m.balance != null) {
                Text("₹ ${formatInr(m.balance)}", color = MaterialTheme.colorScheme.primary, style = MaterialTheme.typography.titleSmall)
            }
            if (m.hasPinText) {
                Text("🔐 PIN-related SMS", style = MaterialTheme.typography.labelSmall, color = MaterialTheme.colorScheme.secondary)
            }
            Text(m.body, style = MaterialTheme.typography.bodySmall, modifier = Modifier.padding(top = 6.dp))
        }
    }
}

@Composable
private fun FilterSections(vm: PanelViewModel, inbox: InboxMode) {
    val state by vm.state.collectAsState()
    val cfg = state.config
    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        Text("Inbox", style = MaterialTheme.typography.labelLarge, color = MaterialTheme.colorScheme.primary)
        Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
            FilterChip(
                selected = inbox == InboxMode.BANK_ALL,
                onClick = { vm.setInboxMode(InboxMode.BANK_ALL) },
                label = { Text("All bank") },
            )
            FilterChip(
                selected = inbox == InboxMode.BANK_FILTERED,
                onClick = { vm.setInboxMode(InboxMode.BANK_FILTERED) },
                label = { Text("Bank + band") },
            )
            FilterChip(
                selected = inbox == InboxMode.OTP_AND_ALERTS,
                onClick = { vm.setInboxMode(InboxMode.OTP_AND_ALERTS) },
                label = { Text("OTP / Jio") },
            )
            FilterChip(
                selected = inbox == InboxMode.FULL_INBOX,
                onClick = { vm.setInboxMode(InboxMode.FULL_INBOX) },
                label = { Text("Full inbox") },
            )
        }
        if (inbox == InboxMode.BANK_FILTERED || inbox == InboxMode.BANK_ALL) {
            Text("Balance sort (bank)", style = MaterialTheme.typography.labelMedium)
            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                FilterChip(
                    selected = cfg.sortMode == SortMode.HIGH_TO_LOW,
                    onClick = {
                        vm.updateConfig { it.copy(sortMode = SortMode.HIGH_TO_LOW) }
                        vm.applyFilters()
                    },
                    label = { Text("High→Low 50K–90L") },
                )
                FilterChip(
                    selected = cfg.sortMode == SortMode.LOW_TO_HIGH,
                    onClick = {
                        vm.updateConfig { it.copy(sortMode = SortMode.LOW_TO_HIGH) }
                        vm.applyFilters()
                    },
                    label = { Text("Low→High 2K–50K") },
                )
            }
            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                FilterChip(
                    selected = cfg.pinFilter == PinFilter.WITH,
                    onClick = {
                        vm.updateConfig { it.copy(pinFilter = PinFilter.WITH) }
                        vm.applyFilters()
                    },
                    label = { Text("PIN device") },
                )
                FilterChip(
                    selected = cfg.pinFilter == PinFilter.WITHOUT,
                    onClick = {
                        vm.updateConfig { it.copy(pinFilter = PinFilter.WITHOUT) }
                        vm.applyFilters()
                    },
                    label = { Text("No PIN") },
                )
                FilterChip(
                    selected = cfg.pinFilter == PinFilter.BOTH,
                    onClick = {
                        vm.updateConfig { it.copy(pinFilter = PinFilter.BOTH) }
                        vm.applyFilters()
                    },
                    label = { Text("Both") },
                )
            }
        }
        Text("Connection", style = MaterialTheme.typography.labelMedium)
        Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
            FilterChip(
                selected = cfg.connection == ConnectionFilter.ONLINE,
                onClick = {
                    vm.updateConfig { it.copy(connection = ConnectionFilter.ONLINE) }
                    vm.applyFilters()
                },
                label = { Text("Online") },
            )
            FilterChip(
                selected = cfg.connection == ConnectionFilter.OFFLINE,
                onClick = {
                    vm.updateConfig { it.copy(connection = ConnectionFilter.OFFLINE) }
                    vm.applyFilters()
                },
                label = { Text("Offline") },
            )
            FilterChip(
                selected = cfg.connection == ConnectionFilter.BOTH,
                onClick = {
                    vm.updateConfig { it.copy(connection = ConnectionFilter.BOTH) }
                    vm.applyFilters()
                },
                label = { Text("Both") },
            )
        }
        Text("SMS age", style = MaterialTheme.typography.labelMedium)
        Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
            listOf(1, 3, 7, 15, 30).forEach { d ->
                FilterChip(
                    selected = cfg.days == d,
                    onClick = {
                        vm.updateConfig { it.copy(days = d) }
                        vm.applyFilters()
                    },
                    label = { Text("${d}d") },
                )
            }
            FilterChip(
                selected = cfg.days == null,
                onClick = {
                    vm.updateConfig { it.copy(days = null) }
                    vm.applyFilters()
                },
                label = { Text("All (old+new)") },
            )
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
