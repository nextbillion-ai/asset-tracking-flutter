import 'package:nb_asset_tracking_flutter/src/trips/trip_last_location.dart';

class TripAsset {
  TripAsset({
    required this.id,
    required this.deviceId,
    required this.state,
    required this.name,
    required this.description,
    required this.createdAt,
    this.tags,
    this.metaData,
    this.updatedAt,
    this.attributes,
    this.latestLocation,
  });

  // Factory constructor to create an instance from JSON
  factory TripAsset.fromJson(Map<String, dynamic> json) => TripAsset(
        id: json['id'],
        deviceId: json['device_id'],
        state: json['state'],
        name: json['name'],
        description: json['description'],
        // ignore: always_specify_types
        tags: (json['tags'] as List<dynamic>?)
            // ignore: always_specify_types
            ?.map((tag) => tag as String)
            .toList(),
        metaData: json['meta_data'] as Map<String, dynamic>?,
        createdAt: (json['created_at'] as num).toDouble(),
        updatedAt: (json['updated_at'] as num?)?.toDouble(),
        attributes: (json['attributes'] as Map<String, dynamic>?)
            // ignore: always_specify_types
            ?.map((String key, value) => MapEntry(key, value)),
        latestLocation: json['latest_location'] != null
            ? LatestLocation.fromJson(json['latest_location'])
            : null,
      );
  final String id;
  final String deviceId;
  final String state;
  final String name;
  final String description;
  final List<String>? tags;
  final Map<String, dynamic>? metaData;
  final double createdAt;
  final double? updatedAt;
  final Map<String, String>? attributes;
  final LatestLocation? latestLocation;
  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'device_id': deviceId,
        'state': state,
        'name': name,
        'description': description,
        'tags': tags,
        'meta_data': metaData,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'attributes': attributes,
        'latest_location': latestLocation?.toJson(),
      };
}
