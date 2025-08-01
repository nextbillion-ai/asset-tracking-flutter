import 'package:flutter/cupertino.dart';

@immutable
class TripLocation {
  const TripLocation({
    this.lat = 0.0,
    this.lon = 0.0,
  });

  // Factory constructor to create an instance from JSON
  factory TripLocation.fromJson(Map<String, dynamic> json) => TripLocation(
        lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
        lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
      );
  final double lat;
  final double lon;

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'lat': lat,
        'lon': lon,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripLocation &&
          runtimeType == other.runtimeType &&
          lat == other.lat &&
          lon == other.lon;

  @override
  int get hashCode => lat.hashCode ^ lon.hashCode;
}
