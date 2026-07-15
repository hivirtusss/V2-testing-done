package com.hivirtus.virtuscontroller

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageButton
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.hivirtus.virtuscontroller.databinding.ActivityMainBinding
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var adapter: TargetAppAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        adapter = TargetAppAdapter(
            onLaunch = { launchApp(it) },
            onSettings = { openSettings(it) }
        )
        binding.appList.layoutManager = LinearLayoutManager(this)
        binding.appList.adapter = adapter

        binding.btnOpenWebUi.setOnClickListener { openWebUi() }
        refresh()
    }

    override fun onResume() {
        super.onResume()
        refresh()
    }

    private fun refresh() {
        lifecycleScope.launch {
            val root = withContext(Dispatchers.IO) { RootShell.hasRoot() }
            val mod = withContext(Dispatchers.IO) { ModuleStatus.isInstalled() }
            val status = buildString {
                if (!root) append(getString(R.string.root_required))
                else if (!mod) append(getString(R.string.module_missing))
                else append("Ready")
            }
            binding.statusBar.text = status

            val apps = withContext(Dispatchers.IO) {
                TargetAppRepository.loadTargetApps(packageManager)
            }
            val empty = apps.isEmpty()
            binding.emptyState.visibility = if (empty) View.VISIBLE else View.GONE
            binding.appList.visibility = if (empty) View.GONE else View.VISIBLE
            adapter.submit(apps)
        }
    }

    private fun launchApp(app: AppInfo) {
        val intent = packageManager.getLaunchIntentForPackage(app.packageName)
        if (intent != null) startActivity(intent)
        else Toast.makeText(this, "Cannot launch ${app.packageName}", Toast.LENGTH_SHORT).show()
    }

    private fun openSettings(app: AppInfo) {
        startActivity(Intent(this, AppSettingsActivity::class.java).apply {
            putExtra(AppSettingsActivity.EXTRA_PKG, app.packageName)
            putExtra(AppSettingsActivity.EXTRA_LABEL, app.label)
        })
    }

    private fun openWebUi() {
        runCatching {
            startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(ModulePaths.WEBUI_URI)))
        }.onFailure {
            Toast.makeText(this, "Open module Action tab manually", Toast.LENGTH_LONG).show()
        }
    }

    private class TargetAppAdapter(
        private val onLaunch: (AppInfo) -> Unit,
        private val onSettings: (AppInfo) -> Unit
    ) : RecyclerView.Adapter<TargetAppAdapter.VH>() {
        private var items: List<AppInfo> = emptyList()

        class VH(v: View) : RecyclerView.ViewHolder(v) {
            val icon: ImageView = v.findViewById(R.id.appIcon)
            val name: TextView = v.findViewById(R.id.appName)
            val pkg: TextView = v.findViewById(R.id.appPackage)
            val launch: View = v.findViewById(R.id.btnLaunch)
            val settings: ImageButton = v.findViewById(R.id.btnSettings)
        }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
            val v = LayoutInflater.from(parent.context)
                .inflate(R.layout.item_target_app, parent, false)
            return VH(v)
        }

        override fun onBindViewHolder(holder: VH, position: Int) {
            val item = items[position]
            holder.name.text = item.label
            holder.pkg.text = item.packageName
            holder.icon.setImageDrawable(
                item.icon ?: holder.itemView.context.getDrawable(android.R.drawable.sym_def_app_icon)
            )
            holder.launch.setOnClickListener { onLaunch(item) }
            holder.settings.setOnClickListener { onSettings(item) }
        }

        override fun getItemCount() = items.size

        fun submit(list: List<AppInfo>) {
            items = list
            notifyDataSetChanged()
        }
    }
}
