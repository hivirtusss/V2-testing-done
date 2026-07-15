package com.hivirtus.virtuscontroller

object ModulePaths {
    const val MODULE_ID = "zygisk_floating_menu"
    const val MODULE_DIR = "/data/adb/modules/$MODULE_ID"
    const val CONFIG_DIR = "$MODULE_DIR/virtus_config"
    const val BACKUP_DIR = "$MODULE_DIR/backups"
    const val TARGET_FILE = "$MODULE_DIR/target_packages.txt"
    const val SYNC_FLAG = "$MODULE_DIR/.virtus_sync"
    const val WEBUI_URI = "ksu://webui?id=$MODULE_ID"
}
