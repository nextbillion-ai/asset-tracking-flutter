import 'trip_location.dart';

class TrackLocation {
  TrackLocation({
    required this.timestamp,
    required this.batteryLevel,
    required this.trackingMode,
    this.accuracy,
    this.altitude,
    this.bearing,
    this.location,
    this.metaData,
    this.speed,
  });

  // Factory constructor to create an instance from JSON
  factory TrackLocation.fromJson(Map<String, dynamic> json) {
    final int? timestamp = json['timestamp'];
    final Map<String, dynamic>? locationJson =
        json['location'] as Map<String, dynamic>?;

    return TrackLocation(
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      altitude: (json['altitude'] as num?)?.toDouble(),
      bearing: (json['bearing'] as num?)?.toDouble(),
      location:
          locationJson != null ? TripLocation.fromJson(locationJson) : null,
      metaData: json['meta_data'] as Map<String, dynamic>?,
      speed: (json['speed'] as num?)?.toDouble(),
      timestamp: timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
          : null,
      batteryLevel: json['battery_level'] ?? 0,
      trackingMode: json['tracking_mode'],
    );
  }
  final double? accuracy;
  final double? altitude;
  final double? bearing;
  final TripLocation? location;
  final Map<String, dynamic>? metaData;
  final double? speed;
  final DateTime? timestamp;
  final int batteryLevel;
  final String? trackingMode;

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'accuracy': accuracy,
        'altitude': altitude,
        'bearing': bearing,
        'location': location?.toJson(),
        'meta_data': metaData,
        'speed': speed,
        'timestamp': timestamp,
        'battery_level': batteryLevel,
        'tracking_mode': trackingMode,
      };
}
