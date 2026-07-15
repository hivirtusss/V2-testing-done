package com.hivirtus.virtuscontroller

data class BackupEntry(
    val id: String,
    val note: String,
    val createdAt: String,
    val sizeHuman: String,
    val mtReady: Boolean,
    val androidId: String,
    val fileCount: Int = 0
) {
    val displayName: String
        get() = note.ifBlank { id }
}

object BackupManager {
    private fun script(): String = "${ModulePaths.MODULE_DIR}/bin/virtus_backup.sh"

    fun list(pkg: String): List<BackupEntry> {
        TargetAppRepository.ensureModuleDirs()
        val r = RootShell.runScript(script(), "list", pkg)
        if (!r.ok || r.stdout.isBlank()) return emptyList()
        return r.stdout.lines()
            .filter { it.contains('|') }
            .mapNotNull { line ->
                val p = line.split('|')
                if (p.isEmpty()) return@mapNotNull null
                BackupEntry(
                    id = p[0].trim(),
                    createdAt = p.getOrElse(1) { "" }.trim(),
                    note = p.getOrElse(2) { "" }.trim(),
                    sizeHuman = p.getOrElse(3) { "" }.trim(),
                    mtReady = p.getOrElse(4) { "0" }.trim() == "1",
                    androidId = p.getOrElse(5) { "" }.trim(),
                    fileCount = p.getOrElse(6) { "0" }.trim().toIntOrNull() ?: 0
                )
            }
            .sortedByDescending { it.createdAt }
    }

    fun create(pkg: String, note: String): RootShell.Result {
        TargetAppRepository.ensureModuleDirs()
        return RootShell.runScript(script(), "create", pkg, note, timeoutSec = 600)
    }

    fun restore(pkg: String, backupId: String): RootShell.Result {
        return RootShell.runScript(script(), "restore", pkg, backupId, timeoutSec = 600)
    }

    fun delete(pkg: String, backupId: String): RootShell.Result {
        return RootShell.runScript(script(), "delete", pkg, backupId)
    }

    fun setNote(pkg: String, backupId: String, note: String): RootShell.Result {
        return RootShell.runScript(script(), "set_note", pkg, backupId, note)
    }

    fun resetData(pkg: String): RootShell.Result {
        return RootShell.runScript(script(), "reset", pkg)
    }

    fun checkData(pkg: String): RootShell.Result {
        TargetAppRepository.ensureModuleDirs()
        return RootShell.runScript(script(), "check", pkg, timeoutSec = 60)
    }
}
