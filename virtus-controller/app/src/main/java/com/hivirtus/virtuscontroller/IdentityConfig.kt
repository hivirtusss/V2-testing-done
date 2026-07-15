package com.hivirtus.virtuscontroller

import org.json.JSONObject
import java.io.File
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
            val path = configPath(pkg)
            val r = RootShell.run("cat '$path' 2>/dev/null")
            return if (r.ok && r.stdout.isNotBlank()) fromJson(r.stdout, pkg)
            else IdentityConfig(pkg, randomId(), false, "")
        }

        fun save(config: IdentityConfig): RootShell.Result {
            val json = config.toJson().replace("'", "'\\''")
            val path = configPath(config.packageName)
            val cmd = """
                mkdir -p '${ModulePaths.CONFIG_DIR}' && \
                chmod 755 '${ModulePaths.CONFIG_DIR}' && \
                printf '%s' '$json' > '$path' && \
                chmod 644 '$path' && \
                date +%s > '${ModulePaths.SYNC_FLAG}' && \
                chmod 644 '${ModulePaths.SYNC_FLAG}'
            """.trimIndent().replace("\n", " ")
            return RootShell.run(cmd)
        }
    }
}
