package com.oguzhnatly.flutter_android_auto


data class FAASectionedItemTemplate(
    val elementId: String,
    val title: String,
    val sections: List<FAAListSection>,
    val emptyViewTitleVariants: List<String>,
    val actions: List<FAATemplateFABActionItem>,
    val isAlphabeticalIndexingAllowed: Boolean? = false,
) {
    companion object {
        fun fromJson(map: Map<String, Any?>): FAASectionedItemTemplate {
            val elementId = map["_elementId"] as? String ?: ""
            val title = map["title"] as? String ?: ""
            val sections = (map["sections"] as? List<*>)?.mapNotNull {
                (it as? Map<*, *>)?.mapKeys { entry -> entry.key.toString() }
                    ?.let { FAAListSection.fromJson(it) }
            } ?: emptyList()
            val emptyViewTitleVariants = (map["emptyViewTitleVariants"] as? List<*>)
                ?.filterIsInstance<String>() ?: emptyList()
            val actions = (map["actions"] as? List<Map<String, Any?>>)
                ?.map { FAATemplateFABActionItem.fromJson(it) } ?: emptyList()
            val useSort = map["isAlphabeticalIndexingAllowed"] as? Boolean ?: false

            return FAASectionedItemTemplate(elementId, title, sections, emptyViewTitleVariants, actions.filterNotNull(), useSort)
        }
    }
}
