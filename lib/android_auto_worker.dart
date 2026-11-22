import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_carplay/aa_models/sectioned_item/sectioned_item_template.dart';
import 'package:flutter_carplay/flutter_carplay.dart';

import 'controllers/android_auto_controller.dart';

/// An object used to integrate Android Auto navigation and manage user
/// interface elements displayed on the Android Auto screen.
class FlutterAndroidAuto {
  static final FlutterAndroidAutoController _androidAutoController =
      FlutterAndroidAutoController();

  late final StreamSubscription<dynamic>? _eventBroadcast;

  static String _connectionStatus = ConnectionStatusTypes.unknown.name;
  static String _lifecycleState = LifeCycleStateTypes.unknown.name;

  /// The size used when rasterizing Flutter asset SVGs referenced by image
  /// fields before they are sent to the native side.
  static int svgRasterSize = defaultSvgRasterSize;

  Function(ConnectionStatusTypes status)? _onAndroidAutoConnectionChange;
  Function(String elementId)? _onAndroidAutoBackButtonPressed;
  Function(LifeCycleStateTypes state)? _onAndroidAutoLifecycleStateChange;

  FlutterAndroidAuto() {
    if (defaultTargetPlatform != TargetPlatform.android) return;

    _eventBroadcast = _androidAutoController.eventChannel
        .receiveBroadcastStream()
        .listen((event) async {
          final FAAChannelTypes receivedChannelType = EnumUtils.enumFromString(
            FAAChannelTypes.values,
            event['type'],
          );

          switch (receivedChannelType) {
            case FAAChannelTypes.onAndroidAutoConnectionChange:
              final ConnectionStatusTypes connectionStatus =
                  EnumUtils.enumFromString(
                    ConnectionStatusTypes.values,
                    event['data']['status'],
                  );
              _connectionStatus = connectionStatus.name;
              _onAndroidAutoConnectionChange?.call(connectionStatus);
              break;

            case FAAChannelTypes.onListItemSelected:
              await _androidAutoController.processFAAListItemSelectedChannel(
                event['data']['elementId'],
              );
              break;

            case FAAChannelTypes.onListSectionSelected:
              _androidAutoController.processFAAListSectionSelectedChannel(
                event['data']['elementId'],
                event['data']['selectedIndex'],
              );
              break;

            case FAAChannelTypes.onToggleCheckedChange:
              _androidAutoController.processFAAToggleCheckedChangeChannel(
                event['data']['elementId'],
                event['data']['checked'],
              );
              break;

            case FAAChannelTypes.onPaneActionPressed:
              _androidAutoController.processFAAPaneActionPressedChannel(
                event['data']['elementId'],
              );
              break;

            case FAAChannelTypes.onScreenBackButtonPressed:
              FlutterAndroidAutoController.templateHistory.removeWhere(
                (AATemplate item) => item.uniqueId == event['data']['elementId'],
              );
              _onAndroidAutoBackButtonPressed?.call(event['data']['elementId']);
              break;

            case FAAChannelTypes.onAlertActionPressed:
              _androidAutoController.processFAAAlertActionPressed(
                event['data']['elementId'],
              );
              break;

            case FAAChannelTypes.onPresentStateChanged:
              final bool completed =
                  event['data']['completed'] as bool? ?? false;
              _androidAutoController.processFAAPresentStateChanged(
                event['data']['elementId'],
                completed,
              );
              break;

            case FAAChannelTypes.onTabBarItemSelected:
              break;

            case FAAChannelTypes.onGridButtonPressed:
              await _androidAutoController.processFAAGridButtonPressed(
                event['data']['elementId'],
              );
              break;
    
            case FAAChannelTypes.onListItemActionPressed:
              await _androidAutoController.processFAAListItemActionPressed(
                event['data']['elementId'],
                event['data']['callbackId'],
              );
              break;
    
            case FAAChannelTypes.onTemplateFABPressed:
              await _androidAutoController.processFAAFabIconPressed(
                event['data']['elementId'],
              );
              break;
    
            case FAAChannelTypes.onHeaderActionPressed:
              await _androidAutoController.processFAAHeaderActionPressed(
                event['data']['elementId'],
              );
              break;
    
            case FAAChannelTypes.onAndroidAutoLifecycleChange:
              final LifeCycleStateTypes lifecycleState =
                EnumUtils.enumFromString(
                  LifeCycleStateTypes.values,
                  event['data']['state'],
                );
              _lifecycleState = lifecycleState.name;
              _onAndroidAutoLifecycleStateChange?.call(lifecycleState);
              break;
    
    
            default:
              break;
          }
    });
  }

  void closeConnection() {
    _eventBroadcast!.cancel();
  }

  void resumeConnection() {
    _eventBroadcast!.resume();
  }

  void pauseConnection() {
    _eventBroadcast!.pause();
  }

  void addListenerOnConnectionChange(
    Function(ConnectionStatusTypes status) onAndroidAutoConnectionChange,
  ) {
    _onAndroidAutoConnectionChange = onAndroidAutoConnectionChange;
  }

  void removeListenerOnConnectionChange() {
    _onAndroidAutoConnectionChange = null;
  }

  static String get connectionStatus => _connectionStatus;
  static String get lifecycleState => _lifecycleState;

  static Future<void> setRootTemplate({required AATemplate template}) async {
    final bool? isCompleted = await _androidAutoController
        .flutterToNativeModule<bool>(FAAChannelTypes.setRootTemplate, {
      'template': template.toJson(),
      'runtimeType': _getAARuntimeTypeString(template),
    });

    if (isCompleted == true) {
      if (FlutterAndroidAutoController.templateHistory.isEmpty) {
        FlutterAndroidAutoController.templateHistory.add(template);
      } else {
        FlutterAndroidAutoController.templateHistory[0] = template;
      }
    }
  }

  Future<void> updateListTemplateSections({
    required String elementId,
    required List<AAListSection> sections,
  }) {
    return FlutterAndroidAutoController.updateAAListTemplateSections(
      elementId: elementId,
      sections: sections,
    );
  }

  static Future<bool> updatePaneTemplate({
    required AAPaneTemplate template,
  }) async {
    final bool? isCompleted = await _androidAutoController
        .flutterToNativeModule<bool>(FAAChannelTypes.updatePaneTemplate, {
      'template': template.toJson(),
    });

    if (isCompleted == true) {
      final int index = FlutterAndroidAutoController.templateHistory.indexWhere(
        (AATemplate item) => item.uniqueId == template.uniqueId,
      );
      if (index != -1) {
        FlutterAndroidAutoController.templateHistory[index] = template;
      }
    }

    return isCompleted ?? false;
  }

  Future<void> forceUpdateRootTemplate() {
    return _androidAutoController.flutterToNativeModule<bool>(
      FAAChannelTypes.forceUpdateRootTemplate,
    );
  }

  static dynamic get rootTemplate =>
      FlutterAndroidAutoController.currentRootTemplate;

  static Future<void> showAlert({required AAAlertTemplate template}) async {
    final bool? isCompleted = await _androidAutoController
        .flutterToNativeModule<bool>(FAAChannelTypes.setAlert, {
      'template': template.toJson(),
    });

    if (isCompleted == true) {
      FlutterAndroidAutoController.currentPresentTemplate = template;
    }
    template.onPresent?.call(isCompleted ?? false);
  }

  static Future<bool> popModal() async {
    FlutterAndroidAutoController.currentPresentTemplate = null;
    final bool? isCompleted = await _androidAutoController
        .flutterToNativeModule<bool>(FAAChannelTypes.closePresent);
    return isCompleted ?? false;
  }

  static Future<void> updateTabBarTemplates({
    required AATabBarTemplate template,
  }) async {
    await _androidAutoController
        .flutterToNativeModule<bool>(FAAChannelTypes.updateTabBarTemplates, {
      'template': template.toJson(),
    });

    final index = FlutterAndroidAutoController.templateHistory.indexWhere(
      (item) => item.uniqueId == template.uniqueId,
    );
    if (index >= 0) {
      FlutterAndroidAutoController.templateHistory[index] = template;
    }
  }

  static Future<bool> pop() async {
    final bool? isCompleted = await _androidAutoController
        .flutterToNativeModule<bool>(FAAChannelTypes.popTemplate);
    return isCompleted ?? false;
  }

  static Future<bool> popToRoot() async {
    final bool? isCompleted = await _androidAutoController
        .flutterToNativeModule<bool>(FAAChannelTypes.popToRootTemplate);
    return isCompleted ?? false;
  }

  static Future<bool> push({required AATemplate template}) async {
    final bool? isCompleted = await _androidAutoController
        .flutterToNativeModule<bool>(FAAChannelTypes.pushTemplate, <String, dynamic>{
      'template': template.toJson(),
      'runtimeType': _getAARuntimeTypeString(template),
    });
    if (isCompleted == true) {
      FlutterAndroidAutoController.templateHistory.add(template);
    }
    return isCompleted ?? false;
  }

  static Future<bool> showSharedNowPlaying() async => false;


  static Future<bool> showToast(String text) async {
    final bool? isCompleted = await _androidAutoController
        .flutterToNativeModule<bool>(FAAChannelTypes.showToast, <String, dynamic>{
          'text': text,
    });
    return isCompleted ?? false;
  }

  void addListenerOnBackButtonPressed(
      Function(String elementId) onAndroidAutoBackButtonPressed,
      ) {
    _onAndroidAutoBackButtonPressed = onAndroidAutoBackButtonPressed;
  }

  void removeListenerOnBackButtonPressed() {
    _onAndroidAutoBackButtonPressed = null;
  }

  static Future<int> getContentLimit() async {
    final limit = await _androidAutoController
        .flutterToNativeModule<int>(FAAChannelTypes.getContentLimit);

    return limit ?? 10;
  }

  void addListenerOnLifecycleStateChange(
      Function(LifeCycleStateTypes state) onAndroidAutoLifecycleStateChange,
      ) {
    _onAndroidAutoLifecycleStateChange = onAndroidAutoLifecycleStateChange;
  }

  void removeListenerOnLifecycleStateChange() {
    _onAndroidAutoLifecycleStateChange = null;
  }

  static String _getAARuntimeTypeString(AATemplate template) {
    if (template is AAListTemplate) return 'FAAListTemplate';
    if (template is AAGridTemplate) return 'FAAGridTemplate';
    if (template is AATabBarTemplate) return 'FAATabBarTemplate';
    if (template is AAPaneTemplate) return 'FAAPaneTemplate';
    if (template is AAMessageTemplate) return 'FAAMessageTemplate';
    if (template is AALongMessageTemplate) return 'FAALongMessageTemplate';
    if (template is AAAlertTemplate) return 'FAAAlertTemplate';
    if (template is AASectionedItemTemplate) return 'FAASectionedItemTemplate';
    return 'FAA${template.runtimeType}';
  }
}
