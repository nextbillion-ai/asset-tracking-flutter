import 'dart:convert';

class NBLocation {
  NBLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.speed,
    required this.speedAccuracy,
    required this.heading,
    required this.provider,
    required this.timestamp,
  });

  factory NBLocation.fromJson(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) {
      throw ArgumentError('JSON string cannot be null or empty');
    }
    final Map<String, dynamic> map = jsonDecode(jsonString);
    return NBLocation(
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      accuracy: (map['accuracy'] ?? 0.0).toDouble(),
      altitude: (map['altitude'] ?? 0.0).toDouble(),
      speed: (map['speed'] ?? 0.0).toDouble(),
      speedAccuracy: (map['speedAccuracy'] ?? 0.0).toDouble(),
      heading: (map['heading'] ?? 0.0).toDouble(),
      provider: map['provider'] ?? '',
      timestamp: (map['timestamp'] ?? 0) as int,
    );
  }

  final num latitude;
  final num longitude;
  final num accuracy;
  final num altitude;
  final num speed;
  final num speedAccuracy;
  final num heading;
  final String provider;
  final num timestamp;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'altitude': altitude,
        'speed': speed,
        'speedAccuracy': speedAccuracy,
        'heading': heading,
        'provider': provider,
        'timestamp': timestamp,
      };

  String toJson() => jsonEncode(toMap());
}
