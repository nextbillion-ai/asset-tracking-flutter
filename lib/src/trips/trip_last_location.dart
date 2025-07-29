import 'trip_location.dart';

class LatestLocation {
  LatestLocation({
    required this.location,
    required this.timestamp,
    this.accuracy,
    this.speed,
    this.bearing,
    this.altitude,
  });

  // Factory constructor to create an instance from JSON
  factory LatestLocation.fromJson(Map<String, dynamic> json) => LatestLocation(
        location: TripLocation.fromJson(json['location']),
        timestamp: json['timestamp'],
        accuracy: json['accuracy']?.toDouble(),
        speed: json['speed']?.toDouble(),
        bearing: json['bearing']?.toDouble(),
        altitude: json['altitude']?.toDouble(),
      );
  final TripLocation location;
  final int timestamp;
  final double? accuracy;
  final double? speed;
  final double? bearing;
  final double? altitude;

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'location': location.toJson(),
        'timestamp': timestamp,
        'accuracy': accuracy,
        'speed': speed,
        'bearing': bearing,
        'altitude': altitude,
      };
}
