package com.hivirtus.virtuscontroller

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.hivirtus.virtuscontroller.databinding.ActivityAppSettingsBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class AppSettingsActivity : AppCompatActivity() {
    companion object {
        const val EXTRA_PKG = "pkg"
        const val EXTRA_LABEL = "label"
    }

    private lateinit var binding: ActivityAppSettingsBinding
    private lateinit var backupAdapter: BackupAdapter
    private lateinit var packageName: String
    private lateinit var appLabel: String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityAppSettingsBinding.inflate(layoutInflater)
        setContentView(binding.root)

        packageName = intent.getStringExtra(EXTRA_PKG) ?: run { finish(); return }
        appLabel = intent.getStringExtra(EXTRA_LABEL) ?: packageName

        supportActionBar?.apply {
            title = appLabel
            setDisplayHomeAsUpEnabled(true)
            setBackgroundDrawable(android.graphics.drawable.ColorDrawable(getColor(R.color.virtus_black)))
        }

        binding.packageName.text = packageName

        backupAdapter = BackupAdapter(
            onRestore = { restore(it) },
            onNote = { editNote(it) },
            onDelete = { delete(it) }
        )
        binding.backupList.layoutManager = LinearLayoutManager(this)
        binding.backupList.adapter = backupAdapter

        binding.btnRefreshId.setOnClickListener {
            binding.androidIdInput.setText(IdentityConfig.randomId())
        }
        binding.btnSaveId.setOnClickListener { saveIdentity() }
        binding.btnResetData.setOnClickListener { resetData() }
        binding.btnCreateBackup.setOnClickListener { createBackup() }

        loadAll()
    }

    override fun onSupportNavigateUp(): Boolean {
        finish()
        return true
    }

    override fun onResume() {
        super.onResume()
        loadBackups()
    }

    private fun loadAll() {
        lifecycleScope.launch {
            val cfg = withContext(Dispatchers.IO) { IdentityConfig.load(packageName) }
            binding.androidIdInput.setText(cfg.androidId)
            loadBackups()
        }
    }

    private fun loadBackups() {
        lifecycleScope.launch {
            val list = withContext(Dispatchers.IO) { BackupManager.list(packageName) }
            backupAdapter.submit(list)
        }
    }

    private fun saveIdentity() {
        val id = binding.androidIdInput.text.toString().trim().lowercase()
        if (id.length != 16 || !id.all { it in "0123456789abcdef" }) {
            toast("Android ID must be 16 hex characters")
            return
        }
        val cfg = IdentityConfig(
            packageName = packageName,
            androidId = id,
            signatureSpoofEnabled = false,
            signatureSha256 = ""
        )
        lifecycleScope.launch {
            val r = withContext(Dispatchers.IO) { IdentityConfig.save(cfg) }
            toast(if (r.ok) getString(R.string.saved_ok) else r.message)
        }
    }

    private fun resetData() {
        AlertDialog.Builder(this)
            .setTitle(R.string.reset_data)
            .setMessage("Clear all app data for $appLabel?")
            .setPositiveButton(R.string.reset_data) { _, _ ->
                lifecycleScope.launch {
                    val r = withContext(Dispatchers.IO) { BackupManager.resetData(packageName) }
                    toast(if (r.ok) getString(R.string.reset_ok) else r.message)
                }
            }
            .setNegativeButton(android.R.string.cancel, null)
            .show()
    }

    private fun createBackup() {
        val note = binding.backupNoteInput.text.toString().trim()
        lifecycleScope.launch {
            val check = withContext(Dispatchers.IO) { BackupManager.checkData(packageName) }
            if (!check.ok || check.stdout.startsWith("not_installed")) {
                toast("App not installed: $packageName")
                return@launch
            }
            if (check.stdout.startsWith("no_data")) {
                toast("Pehle app ek baar kholo (login/setup), phir backup banao")
                return@launch
            }
            toast("Creating backup...")
            val id = binding.androidIdInput.text.toString().trim().lowercase()
            if (id.length == 16) {
                withContext(Dispatchers.IO) {
                    IdentityConfig.save(IdentityConfig(packageName, id, false, ""))
                }
            }
            val r = withContext(Dispatchers.IO) { BackupManager.create(packageName, note) }
            if (r.ok && r.stdout.isNotBlank()) {
                toast(getString(R.string.backup_created))
                binding.backupNoteInput.text?.clear()
                loadBackups()
            } else {
                toast("Failed: ${r.message}")
            }
        }
    }

    private fun restore(entry: BackupEntry) {
        AlertDialog.Builder(this)
            .setTitle(R.string.restore)
            .setMessage("Restore \"${entry.displayName}\"?\nDevice ID + data will be applied.")
            .setPositiveButton(R.string.restore) { _, _ ->
                lifecycleScope.launch {
                    toast("Restoring...")
                    val r = withContext(Dispatchers.IO) {
                        BackupManager.restore(packageName, entry.id)
                    }
                    if (r.ok) {
                        val cfg = withContext(Dispatchers.IO) { IdentityConfig.load(packageName) }
                        binding.androidIdInput.setText(cfg.androidId)
                        toast(getString(R.string.restored_ok))
                        loadBackups()
                    } else {
                        toast("Failed: ${r.message}")
                    }
                }
            }
            .setNegativeButton(android.R.string.cancel, null)
            .show()
    }

    private fun editNote(entry: BackupEntry) {
        val input = EditText(this).apply {
            setText(entry.note)
            setHint(R.string.edit_note)
            setPadding(48, 32, 48, 32)
            setTextColor(getColor(R.color.virtus_text))
            setHintTextColor(getColor(R.color.virtus_text_dim))
        }
        AlertDialog.Builder(this)
            .setTitle(R.string.edit_note)
            .setView(input)
            .setPositiveButton(R.string.save) { _, _ ->
                val note = input.text.toString()
                lifecycleScope.launch {
                    val r = withContext(Dispatchers.IO) {
                        BackupManager.setNote(packageName, entry.id, note)
                    }
                    toast(if (r.ok) getString(R.string.note_saved) else r.message)
                    loadBackups()
                }
            }
            .setNegativeButton(android.R.string.cancel, null)
            .show()
    }

    private fun delete(entry: BackupEntry) {
        AlertDialog.Builder(this)
            .setTitle(R.string.delete)
            .setMessage("Delete backup \"${entry.displayName}\"?")
            .setPositiveButton(R.string.delete) { _, _ ->
                lifecycleScope.launch {
                    val r = withContext(Dispatchers.IO) {
                        BackupManager.delete(packageName, entry.id)
                    }
                    toast(if (r.ok) getString(R.string.deleted_ok) else r.message)
                    loadBackups()
                }
            }
            .setNegativeButton(android.R.string.cancel, null)
            .show()
    }

    private fun toast(msg: String) {
        Toast.makeText(this, msg, Toast.LENGTH_LONG).show()
    }

    private class BackupAdapter(
        private val onRestore: (BackupEntry) -> Unit,
        private val onNote: (BackupEntry) -> Unit,
        private val onDelete: (BackupEntry) -> Unit
    ) : RecyclerView.Adapter<BackupAdapter.VH>() {
        private var items: List<BackupEntry> = emptyList()

        class VH(v: View) : RecyclerView.ViewHolder(v) {
            val title: TextView = v.findViewById(R.id.backupTitle)
            val meta: TextView = v.findViewById(R.id.backupMeta)
            val restore: ImageButton = v.findViewById(R.id.btnRestore)
            val note: ImageButton = v.findViewById(R.id.btnNote)
            val delete: ImageButton = v.findViewById(R.id.btnDelete)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
            val v = LayoutInflater.from(parent.context)
                .inflate(R.layout.item_backup_row, parent, false)
            return VH(v)
        }

        override fun onBindViewHolder(holder: VH, position: Int) {
            val item = items[position]
            holder.title.text = item.displayName
            val idPart = if (item.androidId.isNotBlank()) " | ID: ${item.androidId.take(8)}..." else ""
            holder.meta.text = "${item.createdAt} | ${item.sizeHuman}$idPart"
            holder.restore.setOnClickListener { onRestore(item) }
            holder.note.setOnClickListener { onNote(item) }
            holder.delete.setOnClickListener { onDelete(item) }
        }

        override fun getItemCount() = items.size

        fun submit(list: List<BackupEntry>) {
            items = list
            notifyDataSetChanged()
        }
    }
}
