package com.hivirtus.virtuscontroller

data class BackupEntry(
    val id: String,
    val note: String,
    val createdAt: String,
    val sizeHuman: String
)

object BackupManager {
    private fun script(): String = "${ModulePaths.MODULE_DIR}/bin/virtus_backup.sh"

    fun list(pkg: String): List<BackupEntry> {
        val r = RootShell.run("'${script()}' list '${pkg.replace("'", "")}'")
        if (!r.ok || r.stdout.isBlank()) return emptyList()
        return r.stdout.lines()
            .filter { it.contains('|') }
            .mapNotNull { line ->
                val p = line.split('|')
                if (p.size < 4) return@mapNotNull null
                BackupEntry(p[0].trim(), p.getOrElse(2) { "" }.trim(), p.getOrElse(1) { "" }.trim(), p.getOrElse(3) { "" }.trim())
            }
    }

    fun create(pkg: String, note: String): RootShell.Result {
        val safeNote = note.replace("'", "'\\''")
        return RootShell.run("'${script()}' create '${pkg.replace("'", "")}' '$safeNote'", 300)
    }

    fun restore(pkg: String, backupId: String): RootShell.Result {
        return RootShell.run("'${script()}' restore '${pkg.replace("'", "")}' '${backupId.replace("'", "")}'", 300)
    }

    fun delete(pkg: String, backupId: String): RootShell.Result {
        return RootShell.run("'${script()}' delete '${pkg.replace("'", "")}' '${backupId.replace("'", "")}'")
    }
}
