import 'dart:convert';
import 'low_battery_notification_config.dart';
import 'nb_encode.dart';

class AndroidNotificationConfig with NBEncode {
  AndroidNotificationConfig({
    this.serviceId = defaultServiceId, // Default value, as random generation is not possible here
    this.channelId = defaultChannelId,
    this.channelName = defaultChannelName,
    this.title = '', // Replace with actual default title
    this.content =
        '', // Replace with actual default content
    this.smallIcon =
        'ic_notification_small', // Replace with an appropriate icon identifier
    this.largeIcon = '',
    this.showLowBatteryNotification = true,
    this.lowBatteryNotificationConfig =
        LowBatteryNotificationConfig.defaultConfig,
    this.showAssetIdTakenNotification = true,
    this.contentAssetDisable =
        'Asset tracking stop content', // Replace with actual default content
    this.assetIdTakenContent =
        'Asset ID taken content', // Replace with actual default content
  });

  factory AndroidNotificationConfig.fromJson(Map<String,dynamic> json) => AndroidNotificationConfig(
      serviceId: json['serviceId'] as int? ?? defaultServiceId,
      channelId: json['channelId'] as String? ?? defaultChannelId,
      channelName: json['channelName'] as String? ?? defaultChannelName,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
      smallIcon: json['smallIcon'] as String? ?? '',
      largeIcon: json['largeIcon'] as String? ?? '',
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

  static const String defaultChannelId = 'NextBillion.AI';
  static const String defaultChannelName = 'NextBillion.AI';
  static const int defaultServiceId = 10010;

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

  Map<String, dynamic> toJson() => <String, dynamic>{
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
