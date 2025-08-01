import 'dart:convert';

import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter/src/low_battery_notification_config.dart';

class AssetResult<T> {
  AssetResult({required this.success, required this.data, this.msg});

  factory AssetResult.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    final dynamic data = json['data'];
    late T entity;
    if (T == AssetProfile) {
      entity = AssetProfile.fromJson(data) as T;
    } else if (T == DataTrackingConfig) {
      entity = DataTrackingConfig.fromJson(data) as T;
    } else if (T == DefaultConfig) {
      entity = DefaultConfig.fromJson(data) as T;
    } else if (T == LocationConfig) {
      entity = LocationConfig.fromJson(data) as T;
    } else if (T == LowBatteryNotificationConfig) {
      entity = LowBatteryNotificationConfig.fromJson(data) as T;
    } else if (T == AndroidNotificationConfig) {
      entity = AndroidNotificationConfig.fromJson(data) as T;
    } else if (T == IOSNotificationConfig) {
      entity = IOSNotificationConfig.fromJson(data) as T;
    } else if (T == AssetDetailInfo) {
      entity = AssetDetailInfo.fromJson(data) as T;
    } else if (T == TripSummary) {
      entity = TripSummary.fromJson(data) as T;
    } else if (T == TripInfo) {
      entity = TripInfo.fromJson(data) as T;
    } else if (data == null && T is String) {
      entity = '' as T;
    } else if ((T == Map<String, dynamic> )|| (T == Map)) {
      // Handle case where data is a string representation of a map
      if (data is String) {
        // Parse the string representation of the map
        // Format: "tripId=value, status=value"
        final Map<String, dynamic> dataMap = _parseKeyValueString(data);
        entity = dataMap as T;
      } else {
        entity = data as T;
      }
    } else {
      entity = data as T;
    }
    return AssetResult<T>(
      success: json['success'] as bool,
      data: entity,
      msg: json['msg'] as String?,
    );
  }

  bool success;
  T data;
  String? msg;

}

Map<String, dynamic> _parseKeyValueString(String input) {
  final String trimmed = input.trim().replaceAll(RegExp(r'^\{|\}$'), ''); // Remove braces
  final List<String> pairs = trimmed.split(', ');
  final Map<String, dynamic> map = <String, dynamic>{};

  for (final String pair in pairs) {
    final List<String> split = pair.split('=');
    if (split.length == 2) {
      map[split[0]] = split[1];
    }
  }
  return map;
}
