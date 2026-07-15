package com.hivirtus.virtuscontroller

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.hivirtus.virtuscontroller.databinding.FragmentBackupBinding
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class BackupFragment : Fragment() {
    private var _binding: FragmentBackupBinding? = null
    private val binding get() = _binding!!
    private lateinit var adapter: BackupAdapter

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FragmentBackupBinding.inflate(inflater, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        adapter = BackupAdapter(
            onRestore = { entry -> restore(entry) },
            onDelete = { entry -> delete(entry) }
        )
        binding.backupList.layoutManager = LinearLayoutManager(requireContext())
        binding.backupList.adapter = adapter
        binding.btnCreateBackup.setOnClickListener { create() }
        refreshSelection()
    }

    fun refreshSelection() {
        val pkg = SelectionHolder.selectedPackage
        binding.backupPkgLabel.text = if (pkg == null) "Select app from Apps tab"
        else "${SelectionHolder.selectedLabel} — $pkg"
        if (pkg != null) loadBackups(pkg)
    }

    private fun loadBackups(pkg: String) {
        CoroutineScope(Dispatchers.Main).launch {
            val list = withContext(Dispatchers.IO) { BackupManager.list(pkg) }
            adapter.submit(list)
        }
    }

    private fun create() {
        val pkg = SelectionHolder.selectedPackage ?: run {
            Toast.makeText(requireContext(), "Select an app first", Toast.LENGTH_SHORT).show()
            return
        }
        val note = binding.backupNoteInput.text.toString()
        CoroutineScope(Dispatchers.Main).launch {
            Toast.makeText(requireContext(), "Creating backup...", Toast.LENGTH_SHORT).show()
            val r = withContext(Dispatchers.IO) { BackupManager.create(pkg, note) }
            Toast.makeText(
                requireContext(),
                if (r.ok) "Backup created" else "Failed: ${r.stderr.ifBlank { r.stdout }}",
                Toast.LENGTH_LONG
            ).show()
            loadBackups(pkg)
        }
    }

    private fun restore(entry: BackupEntry) {
        val pkg = SelectionHolder.selectedPackage ?: return
        CoroutineScope(Dispatchers.Main).launch {
            Toast.makeText(requireContext(), "Restoring... app will reset data", Toast.LENGTH_SHORT).show()
            val r = withContext(Dispatchers.IO) { BackupManager.restore(pkg, entry.id) }
            Toast.makeText(
                requireContext(),
                if (r.ok) "Restored ${entry.id}" else "Failed: ${r.stderr.ifBlank { r.stdout }}",
                Toast.LENGTH_LONG
            ).show()
        }
    }

    private fun delete(entry: BackupEntry) {
        val pkg = SelectionHolder.selectedPackage ?: return
        CoroutineScope(Dispatchers.Main).launch {
            val r = withContext(Dispatchers.IO) { BackupManager.delete(pkg, entry.id) }
            Toast.makeText(
                requireContext(),
                if (r.ok) "Deleted" else "Failed: ${r.stderr.ifBlank { r.stdout }}",
                Toast.LENGTH_LONG
            ).show()
            loadBackups(pkg)
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

    private class BackupAdapter(
        private val onRestore: (BackupEntry) -> Unit,
        private val onDelete: (BackupEntry) -> Unit
    ) : RecyclerView.Adapter<BackupAdapter.VH>() {
        private var items: List<BackupEntry> = emptyList()

        class VH(v: View) : RecyclerView.ViewHolder(v) {
            val name: TextView = v.findViewById(R.id.backupName)
            val meta: TextView = v.findViewById(R.id.backupMeta)
            val restore: Button = v.findViewById(R.id.btnRestore)
            val delete: Button = v.findViewById(R.id.btnDelete)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
            val v = LayoutInflater.from(parent.context).inflate(R.layout.item_backup, parent, false)
            return VH(v)
        }

        override fun onBindViewHolder(holder: VH, position: Int) {
            val item = items[position]
            holder.name.text = item.id
            holder.meta.text = "${item.createdAt} | ${item.note.ifBlank { "no note" }} | ${item.sizeHuman}"
            holder.restore.setOnClickListener { onRestore(item) }
            holder.delete.setOnClickListener { onDelete(item) }
        }

        override fun getItemCount() = items.size

        fun submit(list: List<BackupEntry>) {
            items = list
            notifyDataSetChanged()
        }
    }
}
