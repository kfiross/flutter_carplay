package com.oguzhnatly.flutter_android_auto

data class FAAListTemplate(
    val elementId: String,
    val title: String,
    val sections: List<FAAListSection>,
    val emptyViewTitleVariants: List<String>,
    val action: FAATemplateFABActionItem? = null,
    val endHeaderAction: FAATemplateHeaderActionItem? = null,
) {
    init {
        val hasSelectableList = sections.any { it.isSelectable }
        val isSingleUntitledList = sections.size == 1 && sections.first().title.isEmpty()
        require(!hasSelectableList || isSingleUntitledList) {
            "A selectable AAListSection must be the only section in an AAListTemplate and must not have a title."
        }
    }

    companion object {
        fun fromJson(map: Map<String, Any?>): FAAListTemplate {
            val elementId = map["_elementId"] as? String ?: ""
            val title = map["title"] as? String ?: ""
            val sections = (map["sections"] as? List<*>)?.mapNotNull {
                (it as? Map<*, *>)?.mapKeys { entry -> entry.key.toString() }
                    ?.let { FAAListSection.Companion.fromJson(it) }
            } ?: emptyList()
            val emptyViewTitleVariants = (map["emptyViewTitleVariants"] as? List<*>)
                ?.filterIsInstance<String>() ?: emptyList()
            val action = FAATemplateFABActionItem.fromJson(map["action"] as? Map<String, Any?>)
            val endHeaderAction = FAATemplateHeaderActionItem.fromJson(map["endHeaderAction"] as? Map<String, Any?>)

            return FAAListTemplate(elementId, title, sections, emptyViewTitleVariants, action, endHeaderAction)
        }
    }
}
