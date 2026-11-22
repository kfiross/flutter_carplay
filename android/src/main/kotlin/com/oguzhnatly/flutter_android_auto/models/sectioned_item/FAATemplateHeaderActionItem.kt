package com.oguzhnatly.flutter_android_auto

data class FAATemplateHeaderActionItem(
    val title: String,
    val imageUrl: String? = null,
    val imageTint: FAAImageTint? = null,
    val elementId: String? = null,
    ) {
    companion object {
        fun fromJson(map: Map<String, Any?>?): FAATemplateHeaderActionItem? {
            if (map == null) return null

            val title =  map["title"] as String
            val icon = map["imageUrl"] as? String
            val imageTint = FAAImageTint.fromJson(map["imageTint"] as? Map<String, Any?>)
            val elementId = map["elementId"] as? String

            return FAATemplateHeaderActionItem(
                title,
                icon,
                imageTint,
                elementId
            )
        }
    }
}
