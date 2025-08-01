import 'dart:convert';

import 'nb_encode.dart';

enum DesiredAccuracy {
  high,
  medium,
  low;

  static DesiredAccuracy fromString(String s) => switch (s) {
        'high' => high,
        'medium' => medium,
        'low' => low,
        _ => high
      };
}

enum TrackingMode {
  active,
  balanced,
  passive,
  custom;

  static TrackingMode fromString(String s) => switch (s) {
        'active' => active,
        'balanced' => balanced,
        'passive' => passive,
        'custom' => custom,
        _ => active
      };
}

class LocationConfig with NBEncode {
  LocationConfig({
    this.trackingMode = TrackingMode.active,
    this.intervalForAndroid,
    this.smallestDisplacement,
    this.desiredAccuracy,
    this.maxWaitTimeForAndroid,
    this.fastestIntervalForAndroid,
    this.enableStationaryCheck,
  });

  LocationConfig.customConfig({
    required this.intervalForAndroid,
    required this.smallestDisplacement,
    required this.desiredAccuracy,
    required this.maxWaitTimeForAndroid,
    required this.fastestIntervalForAndroid,
    required this.enableStationaryCheck,
  }) : trackingMode = TrackingMode.custom;

  factory LocationConfig.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return LocationConfig(
        trackingMode: json['trackingMode'] == null
            ? TrackingMode.active
            : TrackingMode.fromString(json['trackingMode']),
        intervalForAndroid: json['interval'] ?? 0,
        smallestDisplacement: json['smallestDisplacement'] ?? 0,
        desiredAccuracy: json['desiredAccuracy'] == null
            ? DesiredAccuracy.high
            : DesiredAccuracy.fromString(json['desiredAccuracy']),
        maxWaitTimeForAndroid: json['maxWaitTime'] ?? 0,
        fastestIntervalForAndroid: json['fastestInterval'] ?? 0,
        enableStationaryCheck: json['enableStationaryCheck'] as bool? ?? false);
  }

  factory LocationConfig.config(TrackingMode mode) {
    switch (mode) {
      case TrackingMode.active:
        return LocationConfig.activeConfig();
      case TrackingMode.balanced:
        return LocationConfig.balancedConfig();
      case TrackingMode.passive:
        return LocationConfig.passiveConfig();
      case TrackingMode.custom:
        return LocationConfig.customConfig(
            intervalForAndroid: 0,
            smallestDisplacement: 0.0,
            desiredAccuracy: DesiredAccuracy.high,
            maxWaitTimeForAndroid: 0,
            fastestIntervalForAndroid: 0,
            enableStationaryCheck: true);
    }
  }

  factory LocationConfig.activeConfig() =>
      LocationConfig(trackingMode: TrackingMode.active);

  factory LocationConfig.balancedConfig() =>
      LocationConfig(trackingMode: TrackingMode.balanced);

  factory LocationConfig.passiveConfig() =>
      LocationConfig(trackingMode: TrackingMode.passive);
  final TrackingMode? trackingMode;

  /// Only available on Android
  final int? intervalForAndroid;
  final num? smallestDisplacement;
  final DesiredAccuracy? desiredAccuracy;

  /// Only available on Android
  final int? maxWaitTimeForAndroid;

  /// Only available on Android
  final int? fastestIntervalForAndroid;

  final bool? enableStationaryCheck;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'trackingMode': trackingMode?.toString().split('.').last,
        'interval': intervalForAndroid ?? 0,
        'smallestDisplacement': smallestDisplacement ?? 0.0,
        'desiredAccuracy':
            desiredAccuracy?.toString().split('.').last ?? 'high',
        'maxWaitTime': maxWaitTimeForAndroid ?? 0,
        'fastestInterval': fastestIntervalForAndroid ?? 0,
        'enableStationaryCheck': enableStationaryCheck ?? true,
      };
}
