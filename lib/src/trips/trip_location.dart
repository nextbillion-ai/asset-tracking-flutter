class TripLocation {
  final double lat;
  final double lon;

  TripLocation({
    this.lat = 0.0,
    this.lon = 0.0,
  });

  // Factory constructor to create an instance from JSON
  factory TripLocation.fromJson(Map<String, dynamic> json) {
    return TripLocation(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lon: (json['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
    };
  }

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
