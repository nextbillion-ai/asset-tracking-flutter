import 'package:flutter/foundation.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_stop.dart';

import '../nb_encode.dart';

@immutable
class TripProfile with NBEncode {
  TripProfile({
    required this.customId,
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

  TripProfile.fromJson(Map<String, dynamic> json)
      : customId = json['customId'],
        name = json['name'],
        description = json['description'],
        attributes = json['attributes'] != null
            ? Map<String, dynamic>.from(json['attributes'])
            : null,
        metaData = json['metaData'] != null
            ? Map<String, dynamic>.from(json['metaData'])
            : null,
        stops = json['stops'] != null ? List<TripStop>.from(
            // ignore: always_specify_types
            json['stops'].map((stop) => TripStop.fromJson(stop))) : null;
  final String name;
  final String? customId;
  final String? description;
  final Map<String, dynamic>? attributes;
  final Map<String, dynamic>? metaData;
  final List<TripStop>? stops;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'customId': customId,
        'name': name,
        'description': description,
        'attributes': attributes,
        'metaData': metaData,
        'stops': stops?.map((TripStop stop) => stop.toJson()).toList(),
      };
}
