import 'package:flutter_carplay/aa_models/sectioned_item/sectioned_item_template.dart';
import 'package:flutter_carplay/flutter_carplay.dart';

class FlutterAutoAndroidHelper {
  const FlutterAutoAndroidHelper();

  AAListItem? findAAListItem({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (final template in templates) {
      for (final listTemplate in _listTemplates(template)) {
        for (final section in listTemplate.sections) {
          for (final item in section.items) {
            if (item.uniqueId == elementId) return item;
          }
        }
      }
    }
    return null;
  }

  AAListSection? findAAListSection({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (final template in templates) {
      for (final listTemplate in _listTemplates(template)) {
        for (final section in listTemplate.sections) {
          if (section.uniqueId == elementId) return section;
        }
      }
    }
    return null;
  }

  AAGridButton? findAAGridButton({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (final template in templates) {
      print('_gridTemplates: template=${template.uniqueId} ');
      for (final gridTemplate in _gridTemplates(template)) {
        for (final button in gridTemplate.buttons) {
          print('_gridTemplates: button.elId=${button.uniqueId} ');
          if (button.uniqueId == elementId) return button;
        }
      }
    }
    return null;
  }

  AAPaneAction? findAAPaneAction({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (final template in templates) {
      if (template is AAPaneTemplate) {
        for (final action in template.actions) {
          if (action.uniqueId == elementId) return action;
        }
      }
    }
    return null;
  }

  AAActionItem? findAAFabAction({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (final template in templates) {
      if (template is AAListTemplate) {
        final action = template.action;
        if (action?.uniqueId == elementId) return action;
      }
      if (template is AASectionedItemTemplate) {
        for (final action in template.actions) {
          if (action.uniqueId == elementId) return action;
        }
      }
    }
    return null;
  }

  AAActionItem? findAAHeaderAction({
    required List<AATemplate> templates,
    required String elementId,
  }) {
    for (final template in templates) {
      if (template is AAListTemplate) {
        final action = template.endHeaderAction;
        if (action?.uniqueId == elementId) return action;
      }
    }
    return null;
  }



  Iterable<AAListTemplate> _listTemplates(AATemplate template) sync* {
    if (template is AAListTemplate) {
      yield template;
    } else if (template is AATabBarTemplate) {
      for (final tab in template.tabs) {
        if (tab is AAListTemplate) yield tab;
      }
    }
  }

  Iterable<AAGridTemplate> _gridTemplates(AATemplate template) sync* {
    if (template is AAGridTemplate) {
      yield template;
    } else if (template is AATabBarTemplate) {
      for (final tab in template.tabs) {
        if (tab is AAGridTemplate) yield tab;
      }
    }
  }

  String makeFAAChannelId({String event = ''}) =>
      'com.oguzhnatly.flutter_android_auto$event';
}
