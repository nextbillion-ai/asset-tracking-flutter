import 'dart:convert';

import 'package:nb_asset_tracking_flutter/src/nb_encode.dart';

class AssetProfile with NBEncode {
  final String customId;
  final String name;
  final String description;
  final Map<String, dynamic> attributes;

  AssetProfile({
    required this.customId,
    required this.name,
    required this.description,
    required this.attributes,
  });

  factory AssetProfile.fromJson(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    return AssetProfile(
      customId: json['customId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      attributes: json['attributes'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customId': customId,
      'description': description,
      'name': name,
      'attributes': attributes,
    };
  }
}
