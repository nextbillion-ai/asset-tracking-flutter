import 'dart:convert';
import 'dart:io';

import 'package:nb_asset_tracking_flutter/src/nb_encode.dart';

class AssetDetailInfo with NBEncode {
  AssetDetailInfo(
      {this.id,
      this.deviceId,
      this.name,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.attributes});

  factory AssetDetailInfo.fromJson(String jsonString) {
    final bool isAndroid = Platform.isAndroid;
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return AssetDetailInfo(
      id: json['id'],
      deviceId: isAndroid ? json['device_id'] : json['deviceId'],
      description: isAndroid ? json['description'] : json['assetDescription'],
      name: json['name'],
      createdAt: isAndroid ? json['created_at'] : json['createdAt'],
      updatedAt: isAndroid ? json['updated_at'] : json['updatedAt'],
      attributes: json['attributes'],
    );
  }

  String? id;
  String? deviceId;
  String? name;
  String? description;
  num? createdAt;
  num? updatedAt;
  Map<String, dynamic>? attributes;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'device_id': deviceId,
        'description': description,
        'name': name,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'attributes': attributes,
      };
}
