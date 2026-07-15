package com.hivirtus.virtuscontroller

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.google.android.material.tabs.TabLayoutMediator
import com.hivirtus.virtuscontroller.databinding.ActivityMainBinding
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : AppCompatActivity() {
    private lateinit var binding: ActivityMainBinding
    private lateinit var identityFragment: IdentityFragment
    private lateinit var backupFragment: BackupFragment
    private lateinit var moduleFragment: ModuleFragment

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setSupportActionBar(binding.toolbar)

        identityFragment = IdentityFragment()
        backupFragment = BackupFragment()
        moduleFragment = ModuleFragment()

        binding.viewPager.adapter = object : FragmentStateAdapter(this) {
            override fun getItemCount() = 4
            override fun createFragment(position: Int): Fragment = when (position) {
                0 -> AppsFragment()
                1 -> identityFragment
                2 -> backupFragment
                3 -> moduleFragment
                else -> AppsFragment()
            }
        }

        TabLayoutMediator(binding.tabLayout, binding.viewPager) { tab, pos ->
            tab.text = when (pos) {
                0 -> getString(R.string.tab_apps)
                1 -> getString(R.string.tab_identity)
                2 -> getString(R.string.tab_backup)
                3 -> getString(R.string.tab_module)
                else -> ""
            }
        }.attach()

        refreshStatus()
    }

    fun onAppSelected(app: AppInfo) {
        identityFragment.refreshSelection()
        backupFragment.refreshSelection()
        binding.statusText.text = "Selected: ${app.label}"
    }

    private fun refreshStatus() {
        CoroutineScope(Dispatchers.Main).launch {
            val root = withContext(Dispatchers.IO) { RootShell.hasRoot() }
            val mod = withContext(Dispatchers.IO) { ModuleStatus.isInstalled() }
            val parts = mutableListOf<String>()
            parts += if (root) getString(R.string.root_ok) else getString(R.string.root_fail)
            parts += if (mod) getString(R.string.module_ok) else getString(R.string.module_missing)
            binding.statusText.text = parts.joinToString(" | ")
            moduleFragment.refresh()
        }
    }
}
