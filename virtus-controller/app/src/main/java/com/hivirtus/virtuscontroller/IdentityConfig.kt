package com.hivirtus.virtuscontroller

import org.json.JSONObject
import java.security.SecureRandom

data class IdentityConfig(
    val packageName: String,
    val androidId: String,
    val signatureSpoofEnabled: Boolean = false,
    val signatureSha256: String = "",
    val updatedAt: Long = System.currentTimeMillis()
) {
    fun toJson(): String = JSONObject().apply {
        put("package", packageName)
        put("android_id", androidId)
        put("signature_spoof", signatureSpoofEnabled)
        put("signature_sha256", signatureSha256)
        put("updated_at", updatedAt)
    }.toString()

    companion object {
        fun fromJson(raw: String, pkg: String): IdentityConfig {
            return try {
                val o = JSONObject(raw)
                IdentityConfig(
                    packageName = pkg,
                    androidId = o.optString("android_id", randomId()),
                    signatureSpoofEnabled = o.optBoolean("signature_spoof", false),
                    signatureSha256 = o.optString("signature_sha256", ""),
                    updatedAt = o.optLong("updated_at", 0L)
                )
            } catch (_: Exception) {
                IdentityConfig(pkg, randomId())
            }
        }

        fun randomId(): String {
            val hex = "0123456789abcdef"
            val rnd = SecureRandom()
            return buildString(16) {
                repeat(16) { append(hex[rnd.nextInt(hex.length)]) }
            }
        }

        fun configPath(pkg: String): String =
            "${ModulePaths.CONFIG_DIR}/${pkg.replace('.', '_')}.json"

        fun load(pkg: String): IdentityConfig {
            val path = configPath(pkg)
            val r = RootShell.run("cat '$path' 2>/dev/null")
            if (r.ok && r.stdout.isNotBlank()) return fromJson(r.stdout, pkg)
            val dev = RootShell.run(
                "cat '${ModulePaths.MODULE_DIR}/device_id_${pkg.replace('.', '_')}' 2>/dev/null"
            )
            if (dev.ok && dev.stdout.trim().length == 16) {
                return IdentityConfig(pkg, dev.stdout.trim())
            }
            return IdentityConfig(pkg, randomId())
        }

        fun save(config: IdentityConfig): RootShell.Result {
            TargetAppRepository.ensureModuleDirs()
            val id = config.androidId.trim().lowercase()
            val json = config.copy(androidId = id).toJson().replace("'", "'\\''")
            val path = configPath(config.packageName)
            val safe = config.packageName.replace('.', '_')
            val cmd = """
                mkdir -p '${ModulePaths.CONFIG_DIR}' && \
                printf '%s' '$json' > '$path' && \
                chmod 644 '$path' && \
                printf '%s' '$id' > '${ModulePaths.MODULE_DIR}/device_id_$safe' && \
                printf '%s' '$id' > '${ModulePaths.MODULE_DIR}/device_id' && \
                chmod 644 '${ModulePaths.MODULE_DIR}/device_id_$safe' '${ModulePaths.MODULE_DIR}/device_id' && \
                date +%s > '${ModulePaths.SYNC_FLAG}'
            """.trimIndent().replace("\n", " ")
            return RootShell.run(cmd)
        }

        /** Clear app + apply Device ID (v25 module paths). */
        fun inject(config: IdentityConfig): RootShell.Result {
            val pkg = config.packageName
            val id = config.androidId.trim().lowercase()
            RootShell.run("am force-stop '$pkg'")
            RootShell.run("pm clear '$pkg'")
            Thread.sleep(1500)
            val saved = save(config.copy(androidId = id))
            if (!saved.ok) return saved
            return RootShell.runScript(
                "${ModulePaths.MODULE_DIR}/bin/virtus_backup.sh",
                "save_id",
                pkg,
                id
            )
        }
    }
}
