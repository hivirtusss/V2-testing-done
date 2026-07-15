package com.hivirtus.virtuscontroller

import android.content.pm.PackageManager
import android.graphics.drawable.Drawable

data class AppInfo(
    val label: String,
    val packageName: String,
    val icon: Drawable?
)

object TargetAppRepository {
    private val script = "${ModulePaths.MODULE_DIR}/bin/virtus_backup.sh"

    fun ensureModuleDirs() {
        RootShell.run(
            "mkdir -p '${ModulePaths.CONFIG_DIR}' '${ModulePaths.BACKUP_DIR}' '${ModulePaths.MODULE_DIR}/bin' && " +
                "chmod 755 '$script' 2>/dev/null; chmod 755 '${ModulePaths.MODULE_DIR}/bin' 2>/dev/null"
        )
    }

    fun loadTargetApps(pm: PackageManager): List<AppInfo> {
        ensureModuleDirs()
        val r = RootShell.run("cat '${ModulePaths.TARGET_FILE}' 2>/dev/null")
        val packages = r.stdout.lines()
            .map { it.trim() }
            .filter { it.isNotEmpty() && it != "*" }
            .distinct()

        return packages.mapNotNull { pkg ->
            try {
                val info = pm.getApplicationInfo(pkg, 0)
                AppInfo(
                    label = pm.getApplicationLabel(info).toString(),
                    packageName = pkg,
                    icon = runCatching { pm.getApplicationIcon(pkg) }.getOrNull()
                )
            } catch (_: Exception) {
                AppInfo(label = pkg, packageName = pkg, icon = null)
            }
        }
    }
}

object ModuleStatus {
    fun isInstalled(): Boolean {
        val r = RootShell.run("[ -d '${ModulePaths.MODULE_DIR}' ] && echo ok")
        return r.stdout.contains("ok")
    }
}
