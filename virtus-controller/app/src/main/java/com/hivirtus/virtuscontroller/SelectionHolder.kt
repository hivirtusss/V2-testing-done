package com.hivirtus.virtuscontroller

object SelectionHolder {
    @Volatile
    var selectedPackage: String? = null

    @Volatile
    var selectedLabel: String? = null
}
