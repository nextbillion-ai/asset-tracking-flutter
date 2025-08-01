class TripStop {
  TripStop({
    required this.name,
    required this.geofenceId,
    this.metaData,
  });
  // Factory constructor to create a TripStop from a JSON map
  factory TripStop.fromJson(Map<String, dynamic> json) => TripStop(
        name: json['name'] as String,
        metaData: json['metaData'] != null
            ? Map<String, dynamic>.from(json['metaData'])
            : null,
        geofenceId: json['geofenceId'] as String,
      );
  final String name;
  final Map<String, dynamic>? metaData;
  final String geofenceId;

  // Method to convert a TripStop to a JSON map
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'metaData': metaData,
        'geofenceId': geofenceId,
      };
}
