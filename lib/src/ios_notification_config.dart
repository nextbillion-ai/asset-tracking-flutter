import 'dart:convert';
import 'package:nb_asset_tracking_flutter/src/nb_encode.dart';

class IOSNotificationConfig with NBEncode {
  IOSNotificationConfig();

  factory IOSNotificationConfig.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);

    final IOSNotificationConfig iosNotificationConfig = IOSNotificationConfig()
      ..assetEnableNotificationConfig = AssetEnableNotificationConfig.fromJson(
          json['assetEnableNotificationConfig'])
      ..assetDisableNotificationConfig =
          AssetDisableNotificationConfig.fromJson(
              json['assetDisableNotificationConfig'])
      ..lowBatteryNotificationConfig =
          LowBatteryStatusNotificationConfig.fromJson(
              json['lowBatteryNotificationConfig'])
      ..showAssetEnableNotification = json['showAssetEnableNotification']
      ..showAssetDisableNotification = json['showAssetDisableNotification']
      ..showLowBatteryNotification = json['showLowBatteryNotification'];
    return iosNotificationConfig;
  }

  // Configuration for asset enable notification
  AssetEnableNotificationConfig assetEnableNotificationConfig =
      AssetEnableNotificationConfig(identifier: 'startTrackingIdentifier');

  // Configuration for asset disable notification
  AssetDisableNotificationConfig assetDisableNotificationConfig =
      AssetDisableNotificationConfig(identifier: 'stopTrackingIdentifier');

  // Configuration for low battery notification
  LowBatteryStatusNotificationConfig lowBatteryNotificationConfig =
      LowBatteryStatusNotificationConfig(identifier: 'lowBatteryIdentifier');

  // A Boolean value to determine whether to show the asset enable notification.
  bool showAssetEnableNotification = true;

  // A Boolean value to determine whether to show the asset disable notification.
  bool showAssetDisableNotification = true;

  // A Boolean value to determine whether to show the low battery notification.
  bool showLowBatteryNotification = false;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'assetEnableNotificationConfig': assetEnableNotificationConfig.toJson(),
        'assetDisableNotificationConfig':
            assetDisableNotificationConfig.toJson(),
        'lowBatteryNotificationConfig': lowBatteryNotificationConfig.toJson(),
        'showAssetEnableNotification': showAssetEnableNotification,
        'showAssetDisableNotification': showAssetDisableNotification,
        'showLowBatteryNotification': showLowBatteryNotification,
      };
}

class _DefaultAssetNotificationConfig {
  // Initializes a new instance of the notification configuration.
  _DefaultAssetNotificationConfig(
      {required this.identifier, required this.title, required this.content});
  // A unique identifier for the notification configuration.
  String identifier;

  // The title of the notification.
  String title;

  // The content of the notification.
  String content;
}

class AssetEnableNotificationConfig extends _DefaultAssetNotificationConfig {
  AssetEnableNotificationConfig({required super.identifier})
      : super(
          title: '',
          content:
              "Asset tracking is now enabled and your device's location will be tracked",
        );

  factory AssetEnableNotificationConfig.fromJson(Map<String, dynamic> json) {
    final AssetEnableNotificationConfig assetEnableNotificationConfig =
        AssetEnableNotificationConfig(
      identifier: json['identifier'],
    )
          ..title = json['title']
          ..content = json['content'];
    return assetEnableNotificationConfig;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier,
        'title': title,
        'content': content,
      };
}

class AssetDisableNotificationConfig extends _DefaultAssetNotificationConfig {
  AssetDisableNotificationConfig({required super.identifier})
      : super(
          title: '',
          content:
              "Asset tracking is now disabled and your device's location will no longer be tracked",
        );

  factory AssetDisableNotificationConfig.fromJson(Map<String, dynamic> json) {
    final AssetDisableNotificationConfig assetDisableNotificationConfig =
        AssetDisableNotificationConfig(
      identifier: json['identifier'],
    )
          ..title = json['title']
          ..content = json['content']
          ..assetIDTrackedContent = json['assetIDTrackedContent'];
    return assetDisableNotificationConfig;
  }
  String assetIDTrackedContent =
      'Asset [assetId] is being tracked on another device. Tracking has been stopped on this device';

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier,
        'title': title,
        'content': content,
        'assetIDTrackedContent': assetIDTrackedContent,
      };
}

class LowBatteryStatusNotificationConfig
    extends _DefaultAssetNotificationConfig {
  LowBatteryStatusNotificationConfig({
    required super.identifier,
    this.minBatteryLevel = 10,
  }) : super(
          title: '',
          content:
              "Your device's battery level is lower than $minBatteryLevel. Please recharge to continue tracking assets",
        );

  factory LowBatteryStatusNotificationConfig.fromJson(
      Map<String, dynamic> json) {
    final LowBatteryStatusNotificationConfig
        lowBatteryStatusNotificationConfig = LowBatteryStatusNotificationConfig(
            identifier: json['identifier'],
            minBatteryLevel: double.parse(json['minBatteryLevel'].toString()))
          ..title = json['title']
          ..content = json['content'];
    return lowBatteryStatusNotificationConfig;
  }
  late double minBatteryLevel;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier,
        'title': title,
        'content': content,
        'minBatteryLevel': minBatteryLevel,
      };
}
