import 'dart:convert';

import 'package:nb_asset_tracking_flutter/src/nb_encode.dart';

class AssetProfile with NBEncode {
  AssetProfile({
    required this.customId,
    required this.name,
    required this.description,
    required this.attributes,
  });

  factory AssetProfile.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return AssetProfile(
      customId: json['customId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      attributes: json['attributes'] as Map<String, dynamic>,
    );
  }

  final String customId;
  final String name;
  final String description;
  final Map<String, dynamic> attributes;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'customId': customId,
        'description': description,
        'name': name,
        'attributes': attributes,
      };
}
