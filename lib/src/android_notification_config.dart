import 'dart:convert';
import 'low_battery_notification_config.dart';
import 'nb_encode.dart';

class AndroidNotificationConfig with NBEncode {
  int serviceId;
  String channelId;
  String channelName;
  String title;
  String content;
  String smallIcon;
  String largeIcon;
  bool showLowBatteryNotification;
  LowBatteryNotificationConfig lowBatteryNotificationConfig;
  bool showAssetIdTakenNotification;
  String contentAssetDisable;
  String assetIdTakenContent;

  AndroidNotificationConfig({
    this.serviceId =
        10010, // Default value, as random generation is not possible here
    this.channelId = 'NextBillion.AI',
    this.channelName = 'NextBillion.AI',
    this.title = 'Default Title', // Replace with actual default title
    this.content =
        'Asset tracking start content', // Replace with actual default content
    this.smallIcon = "ic_notification_small", // Replace with an appropriate icon identifier
    this.largeIcon = "",
    this.showLowBatteryNotification = true,
    this.lowBatteryNotificationConfig =
        LowBatteryNotificationConfig.defaultConfig,
    this.showAssetIdTakenNotification = true,
    this.contentAssetDisable =
        'Asset tracking stop content', // Replace with actual default content
    this.assetIdTakenContent =
        'Asset ID taken content', // Replace with actual default content
  });

  factory AndroidNotificationConfig.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return AndroidNotificationConfig(
      serviceId: json['serviceId'] as int? ?? 10010,
      channelId: json['channelId'] as String? ?? 'NextBillion.AI',
      channelName: json['channelName'] as String? ?? 'NextBillion.AI',
      title: json['title'] as String? ?? 'Default Title',
      content: json['content'] as String? ?? 'Asset tracking start content',
      smallIcon: json['smallIcon'] as String? ?? "",
      largeIcon: json['largeIcon'] as String? ?? "",
      showLowBatteryNotification:
          json['showLowBatteryNotification'] as bool? ?? true,
      lowBatteryNotificationConfig: LowBatteryNotificationConfig.fromJson(
          jsonEncode(json['lowBatteryNotification'])),
      showAssetIdTakenNotification:
          json['showAssetIdTakenNotification'] as bool? ?? true,
      contentAssetDisable: json['contentAssetDisable'] as String? ??
          'Asset tracking stop content',
      assetIdTakenContent:
          json['assetIdTakenContent'] as String? ?? 'Asset ID taken content',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'channelId': channelId,
      'channelName': channelName,
      'title': title,
      'content': content,
      'smallIcon': smallIcon,
      'largeIcon': largeIcon,
      'showLowBatteryNotification': showLowBatteryNotification,
      'lowBatteryNotification': lowBatteryNotificationConfig.toJson(),
      'showAssetIdTakenNotification': showAssetIdTakenNotification,
      'contentAssetDisable': contentAssetDisable,
      'assetIdTakenContent': assetIdTakenContent,
    };
  }
}
