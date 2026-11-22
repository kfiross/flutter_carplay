package com.oguzhnatly.flutter_android_auto

data class FAAListItem(
    val elementId: String,
    val title: String,
    val subtitle: String? = null,
    val imageUrl: String? = null,
    val imageData: ByteArray? = null,
    val imageTint: FAAImageTint? = null,
    val trailingImage: String? = null,
    val trailingImageData: ByteArray? = null,
    val trailingImageTint: FAAImageTint? = null,
    val loadingMessage: String? = null,
    val isBrowsable: Boolean? = null,
    val toggle: FAAToggle? = null,
    val isOnPressListenerActive: Boolean,
    val numericDecoration: Int,
    val trailingActionsButtons: List<FAAListItemAction> = emptyList(),
    val subtitleSpans: List<FAAListItemSpannable> = emptyList(),
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAListItem {
            val elementId = map["_elementId"] as? String ?: ""
            val title = map["title"] as? String ?: ""
            val subtitle = map["subtitle"] as? String
            val imageUrl = map["imageUrl"] as? String ?: map["image"] as? String
            val imageData = map["imageData"] as? ByteArray
            val imageTint = FAAImageTint.fromJson(map["imageTint"] as? Map<String, Any?>)
            val trailingImage = map["trailingImage"] as? String
            val trailingImageData = map["trailingImageData"] as? ByteArray
            val trailingImageTint =
                FAAImageTint.fromJson(map["trailingImageTint"] as? Map<String, Any?>)
            val loadingMessage = map["loadingMessage"] as? String
            val isBrowsable = map["isBrowsable"] as? Boolean
            val toggle = (map["toggle"] as? Map<*, *>)?.mapKeys { entry ->
                entry.key.toString()
            }?.let { FAAToggle.fromJson(it) }
            val isOnPressListenerActive = map["onPress"] as? Boolean ?: false
            val numericDecoration = map["numericDecoration"] as? Int ?: 0
            val trailingActionsButtons = (map["trailingActionsButtons"] as? List<Map<String, Any?>>)
                ?.map { FAAListItemAction.fromJson(it) }
            val subtitleSpans = (map["subtitleSpans"] as? List<Map<String, Any?>>)
                ?.map { FAAListItemSpannable.fromJson(it) }

            return FAAListItem(
                elementId,
                title,
                subtitle,
                imageUrl,
                imageData,
                imageTint,
                trailingImage,
                trailingImageData,
                trailingImageTint,
                loadingMessage,
                isBrowsable,
                toggle,
                isOnPressListenerActive,
                numericDecoration,
                trailingActionsButtons ?: emptyList(),
                subtitleSpans ?: emptyList(),
            )
        }
    }
}

data class FAAToggle(
    val isChecked: Boolean = false,
    val isEnabled: Boolean? = null,
    val isOnCheckedChangeListenerActive: Boolean = false,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAToggle {
            val isChecked = map["isChecked"] as? Boolean ?: false
            val isEnabled = map["isEnabled"] as? Boolean
            val isOnCheckedChangeListenerActive =
                map["onCheckedChange"] as? Boolean ?: false

            return FAAToggle(
                isChecked, isEnabled, isOnCheckedChangeListenerActive
            )
        }
    }
}


data class FAAListItemAction(
    val image: String? = null,
    val callbackId: String? = null,
    val text: String? = null
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAListItemAction {
            val image = map["image"] as? String

            val text = map["text"] as? String

            val callbackId = map["callbackId"] as? String

            return FAAListItemAction(
                image,
                callbackId,
                text
            )
        }
    }
}

data class FAAListItemSpannable(
    val color: FAAImageTint? = null,
    val start: Int? = 0,
    val end: Int? = null,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAAListItemSpannable {
            val color = FAAImageTint.fromJson(map["color"] as Map<String, Any?>)
            val start = map["start"] as? Int ?: 0
            val end = map["end"] as? Int

            return FAAListItemSpannable(
                color,
                start,
                end
            )
        }
    }
}