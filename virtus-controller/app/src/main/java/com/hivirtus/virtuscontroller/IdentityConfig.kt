package com.hivirtus.virtuscontroller

import org.json.JSONObject
import java.security.SecureRandom

data class IdentityConfig(
    val packageName: String,
    val androidId: String,
    val signatureSpoofEnabled: Boolean = true,
    val signatureSha256: String = "",
    val versionCode: Int = 0,
    val versionName: String = "",
    val updatedAt: Long = System.currentTimeMillis()
) {
    fun toJson(): String = JSONObject().apply {
        put("package", packageName)
        put("android_id", androidId)
        put("signature_spoof", signatureSpoofEnabled)
        put("signature_sha256", signatureSha256)
        put("version_code", versionCode)
        put("version_name", versionName)
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
                    signatureSpoofEnabled = o.optBoolean("signature_spoof", true),
                    signatureSha256 = o.optString("signature_sha256", ""),
                    versionCode = o.optInt("version_code", 0),
                    versionName = o.optString("version_name", ""),
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

        fun load(pkg: String): IdentityConfig {
            TargetAppRepository.ensureModuleDirs()
            val r = RootShell.runScript(identityScript(), "load", pkg)
            if (r.ok && r.stdout.contains("android_id")) {
                return fromJson(r.stdout.lines().first { it.contains("android_id") }, pkg)
            }
            val backupId = RootShell.runScript(
                "${ModulePaths.MODULE_DIR}/bin/virtus_backup.sh",
                "load_id",
                pkg
            )
            if (backupId.ok && backupId.stdout.length == 16) {
                return IdentityConfig(pkg, backupId.stdout.trim())
            }
            return IdentityConfig(pkg, randomId())
        }

        fun enrichFromInstalled(config: IdentityConfig): IdentityConfig {
            val pkg = config.packageName
            val dump = RootShell.run("dumpsys package $pkg | head -80")
            if (!dump.ok) return config
            var vc = config.versionCode
            var vn = config.versionName
            var sig = config.signatureSha256
            for (line in dump.stdout.lines()) {
                when {
                    line.contains("versionCode=") && vc == 0 ->
                        vc = line.substringAfter("versionCode=").trim().substringBefore(' ').toIntOrNull() ?: vc
                    line.contains("versionName=") && vn.isBlank() ->
                        vn = line.substringAfter("versionName=").trim().removeSurrounding("'")
                    line.contains("signatures:") || line.contains("SHA-256") ->
                        Regex("[0-9a-fA-F]{64}").find(line)?.value?.lowercase()?.let { sig = it }
                }
            }
            return config.copy(
                versionCode = vc,
                versionName = vn,
                signatureSha256 = sig,
                signatureSpoofEnabled = true
            )
        }

        fun save(config: IdentityConfig): RootShell.Result {
            TargetAppRepository.ensureModuleDirs()
            val enriched = enrichFromInstalled(config)
            val id = enriched.androidId.trim().lowercase()
            return RootShell.runScript(
                identityScript(),
                "save",
                enriched.packageName,
                id,
                if (enriched.signatureSpoofEnabled) "1" else "0",
                enriched.signatureSha256,
                enriched.versionCode.toString(),
                enriched.versionName
            )
        }

        /** Clear app data + apply new Android ID (System Error style). */
        fun inject(config: IdentityConfig): RootShell.Result {
            TargetAppRepository.ensureModuleDirs()
            val enriched = enrichFromInstalled(config.copy(signatureSpoofEnabled = true))
            val id = enriched.androidId.trim().lowercase()
            return RootShell.runScript(
                identityScript(),
                "inject",
                enriched.packageName,
                id,
                if (enriched.signatureSpoofEnabled) "1" else "0",
                enriched.signatureSha256,
                enriched.versionCode.toString(),
                enriched.versionName,
                timeoutSec = 120
            )
        }
    }
}
