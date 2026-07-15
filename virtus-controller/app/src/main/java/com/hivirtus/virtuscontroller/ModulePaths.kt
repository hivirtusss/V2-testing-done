package com.hivirtus.virtuscontroller

object ModulePaths {
    const val MODULE_ID = "zygisk_floating_menu"
    const val MODULE_DIR = "/data/adb/modules/$MODULE_ID"
    const val BACKUP_DIR = "/storage/emulated/0/VirtusBackup"
    const val TARGET_FILE = "$MODULE_DIR/target_packages.txt"
    const val SYNC_FLAG = "$MODULE_DIR/.virtus_sync"
    const val WEBUI_URI = "ksu://webui?id=$MODULE_ID"
}
