package com.oguzhnatly.flutter_android_auto

data class FAATemplateFABActionItem(
    val imageUrl: String? = null,
    val imageTint: FAAImageTint? = null,
    val elementId: String? = null,

    ) {
    companion object {
        fun fromJson(map: Map<String, Any?>?): FAATemplateFABActionItem? {
            if (map == null) return null

            val icon = map["imageUrl"] as? String
            val imageTint = FAAImageTint.fromJson(map["imageTint"] as? Map<String, Any?>)
            val elementId = map["elementId"] as? String

            return FAATemplateFABActionItem(
                icon,
                imageTint,
                elementId
            )
        }
    }
}
