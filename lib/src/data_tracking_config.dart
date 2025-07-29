import 'dart:convert';

import 'constants.dart';
import 'nb_encode.dart';

class DataTrackingConfig with NBEncode {
  DataTrackingConfig({
    String? baseUrl,
    this.dataStorageSize =
        Constants.defaultDataStorageSize, // Replace with actual default value
    this.dataUploadingBatchSize =
        Constants.defaultDataBatchSize, // Replace with actual default value
    this.dataUploadingBatchWindow =
        Constants.defaultBatchWindow, // Replace with actual default value
    this.shouldClearLocalDataWhenCollision =
        Constants.shouldClearLocalDataWhenCollision,
  }) : baseUrl = baseUrl ?? Constants.defaultBaseUrl;

  factory DataTrackingConfig.fromJson(String jsonString) {
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return DataTrackingConfig(
      baseUrl: json['baseUrl'] as String,
      dataStorageSize: json['dataStorageSize'] as int,
      dataUploadingBatchSize: json['dataUploadingBatchSize'] as int,
      dataUploadingBatchWindow: json['dataUploadingBatchWindow'] as int,
      shouldClearLocalDataWhenCollision:
          json['shouldClearLocalDataWhenCollision'] as bool,
    );
  }

  String baseUrl;
  int dataStorageSize;
  int dataUploadingBatchSize;
  int dataUploadingBatchWindow;
  bool shouldClearLocalDataWhenCollision;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'baseUrl': baseUrl,
        'dataStorageSize': dataStorageSize,
        'dataUploadingBatchSize': dataUploadingBatchSize,
        'dataUploadingBatchWindow': dataUploadingBatchWindow,
        'shouldClearLocalDataWhenCollision': shouldClearLocalDataWhenCollision,
      };
}
