package com.hivirtus.virtuscontroller

import android.content.Context
import java.security.SecureRandom

object VirtusPrefs {
    private const val PREF = "virtus_identity"

    fun getId(context: Context, pkg: String): String? =
        context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
            .getString("android_id_$pkg", null)

    fun setId(context: Context, pkg: String, id: String) {
        context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
            .edit()
            .putString("android_id_$pkg", id)
            .apply()
    }
}

data class IdentityConfig(
    val packageName: String,
    val androidId: String
) {
    companion object {
        fun randomId(): String {
            val hex = "0123456789abcdef"
            val rnd = SecureRandom()
            return buildString(16) {
                repeat(16) { append(hex[rnd.nextInt(hex.length)]) }
            }
        }

        fun load(context: Context, pkg: String): IdentityConfig {
            VirtusPrefs.getId(context, pkg)?.let {
                if (it.length == 16) return IdentityConfig(pkg, it)
            }
            val dev = RootShell.run(
                "cat '${ModulePaths.MODULE_DIR}/device_id_${pkg.replace('.', '_')}' 2>/dev/null"
            )
            if (dev.ok && dev.stdout.trim().length == 16) {
                return IdentityConfig(pkg, dev.stdout.trim())
            }
            return IdentityConfig(pkg, randomId())
        }

        /** Store ID locally — written into backup on Create Backup (not module clutter). */
        fun saveLocal(context: Context, config: IdentityConfig): Boolean {
            val id = config.androidId.trim().lowercase()
            if (id.length != 16) return false
            VirtusPrefs.setId(context, config.packageName, id)
            return true
        }

        /** Apply ID now: clear app data + module device_id (runtime). */
        fun applyNow(config: IdentityConfig): RootShell.Result {
            val pkg = config.packageName
            val id = config.androidId.trim().lowercase()
            RootShell.run("am force-stop '$pkg'")
            RootShell.run("pm clear '$pkg'")
            Thread.sleep(1500)
            return RootShell.runScript(
                "${ModulePaths.MODULE_DIR}/bin/virtus_backup.sh",
                "save_id",
                pkg,
                id,
                timeoutSec = 60
            )
        }
    }
}
