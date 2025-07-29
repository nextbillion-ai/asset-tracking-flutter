import 'package:nb_asset_tracking_flutter/src/trips/trip_stop.dart';

import '../nb_encode.dart';

class TripUpdateProfile with NBEncode {
  TripUpdateProfile({
    required this.name,
    this.description,
    this.attributes,
    this.metaData,
    this.stops,
  }) {
    if (name.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
  }

  // Factory constructor to create a TripUpdateProfile from a JSON map
  factory TripUpdateProfile.fromJson(Map<String, dynamic> json) =>
      TripUpdateProfile(
        name: json['name'] as String,
        description: json['description'] as String?,
        attributes: json['attributes'] != null
            ? Map<String, dynamic>.from(json['attributes'])
            : null,
        metaData: json['metaData'] != null
            ? Map<String, dynamic>.from(json['metaData'])
            : null,
        stops: json['stops'] != null
            ? (json['stops'] as List<Map<String, dynamic>>)
                .map(TripStop.fromJson)
                .toList()
            : null,
      );
  final String name;
  final String? description;
  final Map<String, dynamic>? attributes;
  final Map<String, dynamic>? metaData;
  final List<TripStop>? stops;

  // Method to convert a TripUpdateProfile to a JSON map
  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'description': description,
        'attributes': attributes,
        'metaData': metaData,
        'stops': stops?.map((TripStop stop) => stop.toJson()).toList(),
      };
}
