package com.hivirtus.virtuscontroller

import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.drawable.Drawable

data class AppInfo(
    val label: String,
    val packageName: String,
    val icon: Drawable?
)

object AppRepository {
    fun load(pm: PackageManager): List<AppInfo> {
        val blocked = setOf(
            "com.android.systemui", "com.android.settings", "com.google.android.gms",
            "me.weishu.kernelsu", "com.sukisu.ultra", "com.topjohnwu.magisk"
        )
        return pm.getInstalledApplications(PackageManager.GET_META_DATA)
            .filter { (it.flags and ApplicationInfo.FLAG_SYSTEM) == 0 || it.packageName.startsWith("com.") }
            .filter { !it.packageName.startsWith("com.android.") }
            .filter { !it.packageName.startsWith("com.google.android.") }
            .filter { it.packageName !in blocked }
            .map {
                AppInfo(
                    label = pm.getApplicationLabel(it).toString(),
                    packageName = it.packageName,
                    icon = runCatching { pm.getApplicationIcon(it.packageName) }.getOrNull()
                )
            }
            .sortedBy { it.label.lowercase() }
    }
}

object ModuleStatus {
    fun isInstalled(): Boolean {
        val r = RootShell.run("[ -d '${ModulePaths.MODULE_DIR}' ] && echo ok")
        return r.stdout.contains("ok")
    }

    fun summary(): String {
        if (!isInstalled()) return "Module NOT found at ${ModulePaths.MODULE_DIR}"
        val targets = RootShell.run("wc -l < '${ModulePaths.TARGET_FILE}' 2>/dev/null").stdout
        val backups = RootShell.run("find '${ModulePaths.BACKUP_DIR}' -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l").stdout
        return "Module OK | target apps: ${targets.trim()} | backup roots: ${backups.trim()}"
    }
}
