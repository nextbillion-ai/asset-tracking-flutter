import 'package:nb_asset_tracking_flutter/src/trips/track_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_asset.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_stop.dart';

class TripSummary {
  TripSummary({
    required this.id,
    required this.assetId,
    required this.state,
    required this.name,
    required this.startedAt,
    required this.asset,
    this.description,
    this.metaData,
    this.attributes,
    this.endedAt,
    this.createdAt,
    this.updatedAt,
    this.stops,
    this.route,
    this.geometry,
    this.distance,
    this.duration,
  });

  // Factory constructor to create an instance from JSON
  factory TripSummary.fromJson(Map<String, dynamic> json) {
    final int createdTime = json['created_at'];
    final int? endedTime = json['ended_at'];
    final int? updatedTime = json['updated_at'];
    final int startedTime = json['started_at'];

    return TripSummary(
      id: json['id'],
      assetId: json['asset_id'],
      state: json['state'],
      name: json['name'],
      description: json['description'],
      metaData: json['meta_data'] as Map<String, dynamic>?,
      attributes: json['attributes'] as Map<String, dynamic>?,
      startedAt: DateTime.fromMillisecondsSinceEpoch(startedTime * 1000),
      endedAt: endedTime == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(endedTime * 1000),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdTime * 1000),
      updatedAt: updatedTime == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(updatedTime * 1000),
      stops: (json['stops'] as List<dynamic>?)
          ?.map((e) => TripStop.fromJson(e as Map<String, dynamic>))
          .toList(),
      route: (json['route'] as List<dynamic>?)
          ?.map((e) => TrackLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      asset: TripAsset.fromJson(json['asset']),
      geometry: (json['geometry'] as List<String>?)
          ?.map((String item) => item)
          .toList(),
      distance: (json['distance'] as num?)?.toDouble(),
      duration: (json['duration'] as num?)?.toDouble(),
    );
  }
  final String id;
  final String assetId;
  final String state;
  final String name;
  final String? description;
  final Map<String, dynamic>? metaData;
  final Map<String, dynamic>? attributes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<TripStop>? stops;
  final List<TrackLocation>? route;
  final TripAsset asset;
  final List<String>? geometry;
  final double? distance;
  final double? duration;

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'asset_id': assetId,
        'state': state,
        'name': name,
        'description': description,
        'meta_data': metaData,
        'attributes': attributes,
        'started_at': startedAt,
        'ended_at': endedAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'stops': stops?.map((TripStop stop) => stop.toJson()).toList(),
        'route':
            route?.map((TrackLocation location) => location.toJson()).toList(),
        'asset': asset.toJson(),
        'geometry': geometry,
        'distance': distance,
        'duration': duration,
      };
}
