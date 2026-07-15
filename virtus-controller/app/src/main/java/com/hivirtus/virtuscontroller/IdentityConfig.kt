package com.hivirtus.virtuscontroller

import org.json.JSONObject
import java.security.SecureRandom

data class IdentityConfig(
    val packageName: String,
    val androidId: String,
    val signatureSpoofEnabled: Boolean,
    val signatureSha256: String,
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
        private fun identityScript(): String =
            "${ModulePaths.MODULE_DIR}/bin/virtus_identity.sh"

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
                IdentityConfig(pkg, randomId(), false, "")
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
            TargetAppRepository.ensureModuleDirs()
            val r = RootShell.runScript(identityScript(), "load", pkg)
            if (r.ok && r.stdout.contains("android_id")) {
                return fromJson(r.stdout.lines().first { it.contains("android_id") }, pkg)
            }
            return IdentityConfig(pkg, randomId(), false, "")
        }

        fun save(config: IdentityConfig): RootShell.Result {
            TargetAppRepository.ensureModuleDirs()
            val id = config.androidId.trim().lowercase()
            return RootShell.runScript(identityScript(), "save", config.packageName, id)
        }
    }
}
