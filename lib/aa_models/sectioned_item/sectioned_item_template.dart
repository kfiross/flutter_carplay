import 'package:uuid/uuid.dart';

import '../../models/common/image_tint.dart';
import '../list/list_section.dart';
import '../template.dart';

class AAActionItem {
  final String? title;
  final String? imageUrl;
  final AutoImageTint? imageTint;
  final String _elementId;
  final Function() onPress;

  AAActionItem({this.title, this.imageUrl, this.imageTint, String? id, required this.onPress})
    : _elementId = id ?? const Uuid().v4();

  String get uniqueId => _elementId;

  Map<String, dynamic> toJson() => {
    'title': title,
    'imageUrl': imageUrl,
    'elementId': _elementId,
    'imageTint': imageTint?.toJson(),
  };
}

class AASectionedItemTemplate implements AATemplate {
  /// Unique id of the object.
  final String _elementId;

  final String title;
  final List<AAListSection> sections;

  /// An array of title variants displayed when the list is empty.
  ///
  /// Android Auto uses the first element as the message passed to
  /// `ItemList.Builder.setNoItemsMessage()`. When [sections] is empty and
  /// this list is null, the template falls back to a loading indicator.
  final List<String>? emptyViewTitleVariants;

  /// Label displayed on the tab bar item when this template is used as a tab
  /// inside an [AATabBarTemplate]. Falls back to [title] when not set.
  final String? tabTitle;

  /// Icon displayed in the tab when this template is used inside an
  /// [AATabBarTemplate]. Supports mapped system icon names, Flutter assets,
  /// local files, and network URLs.
  ///
  /// When [iconUrl] is also set, [iconUrl] takes precedence.
  final String? systemIcon;

  /// URL of an image to use as the tab bar icon. Loaded asynchronously.
  /// Takes precedence over [systemIcon] when set.
  final String? iconUrl;

  /// Sets whether this list can be indexed alphabetically, by item title.
  /// By default, this is false.
  final bool? isAlphabeticalIndexingAllowed;

  /// Sets a template scoped action(s) outside the rows.
  final List<AAActionItem> actions;

  AASectionedItemTemplate({
    required this.title,
    required this.sections,
    this.emptyViewTitleVariants,
    this.tabTitle,
    this.systemIcon,
    this.iconUrl,
    this.isAlphabeticalIndexingAllowed,
    this.actions = const [],
    String? id,
  })  : assert(
          !sections.any((section) => section.isSelectable) ||
              sections.length == 1,
          'Android Auto selectable list sections cannot be mixed with other sections.',
        ),
        _elementId = id ?? const Uuid().v4();

  @override
  String get uniqueId => _elementId;

  @override
  Map<String, dynamic> toJson() => {
        '_elementId': _elementId,
        'title': title,
        'sections':
            sections.map((AAListSection section) => section.toJson()).toList(),
        'emptyViewTitleVariants': emptyViewTitleVariants,
        'tabTitle': tabTitle,
        'systemIcon': systemIcon,
        'iconUrl': iconUrl,
        'isAlphabeticalIndexingAllowed': isAlphabeticalIndexingAllowed ?? false,
        'actions': actions.map((action) => action.toJson()).toList(),
      };

  void updateSections(List<AAListSection> newSections) {
    final copy = List<AAListSection>.from(newSections);
    sections
      ..clear()
      ..addAll(copy);
  }
}
