import 'package:nb_asset_tracking_flutter/src/constants.dart';
import 'package:nb_asset_tracking_flutter/src/data_tracking_config.dart';
import 'package:test/test.dart';

void main() {
  group('DataTrackingConfig', () {
    test('creates instance with default values', () {
      final DataTrackingConfig config = DataTrackingConfig();

      expect(config.baseUrl, equals(Constants.defaultBaseUrl));
      expect(config.dataStorageSize, equals(Constants.defaultDataStorageSize));
      expect(config.dataUploadingBatchSize,
          equals(Constants.defaultDataBatchSize));
      expect(config.dataUploadingBatchWindow,
          equals(Constants.defaultBatchWindow));
      expect(config.shouldClearLocalDataWhenCollision,
          equals(Constants.shouldClearLocalDataWhenCollision));
    });

    test('creates instance with custom values', () {
      final DataTrackingConfig config = DataTrackingConfig(
        baseUrl: 'https://custom.api.com',
        dataStorageSize: 1000,
        dataUploadingBatchSize: 50,
        dataUploadingBatchWindow: 30,
        shouldClearLocalDataWhenCollision: false,
      );

      expect(config.baseUrl, equals('https://custom.api.com'));
      expect(config.dataStorageSize, equals(1000));
      expect(config.dataUploadingBatchSize, equals(50));
      expect(config.dataUploadingBatchWindow, equals(30));
      expect(config.shouldClearLocalDataWhenCollision, isFalse);
    });

    group('fromJson', () {
      test('creates instance from valid JSON string', () {
        const jsonString = '''
        {
          "baseUrl": "https://custom.api.com",
          "dataStorageSize": 1000,
          "dataUploadingBatchSize": 50,
          "dataUploadingBatchWindow": 30,
          "shouldClearLocalDataWhenCollision": false
        }
        ''';

        final DataTrackingConfig config = DataTrackingConfig.fromJson(jsonString);

        expect(config.baseUrl, equals('https://custom.api.com'));
        expect(config.dataStorageSize, equals(1000));
        expect(config.dataUploadingBatchSize, equals(50));
        expect(config.dataUploadingBatchWindow, equals(30));
        expect(config.shouldClearLocalDataWhenCollision, isFalse);
      });

      test('throws FormatException for invalid JSON', () {
        expect(
          () => DataTrackingConfig.fromJson('{invalid json}'),
          throwsFormatException,
        );
      });

      test('throws TypeError when required fields are missing', () {
        const String jsonString = '{}';

        expect(
          () => DataTrackingConfig.fromJson(jsonString),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('toJson', () {
      test('converts to JSON correctly', () {
        final config = DataTrackingConfig(
          baseUrl: 'https://custom.api.com',
          dataStorageSize: 1000,
          dataUploadingBatchSize: 50,
          dataUploadingBatchWindow: 30,
          shouldClearLocalDataWhenCollision: false,
        );

        final json = config.toJson();

        expect(json['baseUrl'], equals('https://custom.api.com'));
        expect(json['dataStorageSize'], equals(1000));
        expect(json['dataUploadingBatchSize'], equals(50));
        expect(json['dataUploadingBatchWindow'], equals(30));
        expect(json['shouldClearLocalDataWhenCollision'], isFalse);
      });

      test('encodes via NBEncode mixin correctly', () {
        final config = DataTrackingConfig(
          baseUrl: 'https://custom.api.com',
          dataStorageSize: 1000,
          dataUploadingBatchSize: 50,
          dataUploadingBatchWindow: 30,
          shouldClearLocalDataWhenCollision: false,
        );

        final encoded = config.encode();
        expect(
          encoded,
          '{"baseUrl":"https://custom.api.com",'
          '"dataStorageSize":1000,'
          '"dataUploadingBatchSize":50,'
          '"dataUploadingBatchWindow":30,'
          '"shouldClearLocalDataWhenCollision":false}',
        );
      });
    });
  });
}
