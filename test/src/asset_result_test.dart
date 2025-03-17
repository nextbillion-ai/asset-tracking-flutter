import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/asset_detail_info.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';

void main() {
  group('AssetResult', () {
    test('creates instance with all properties', () {
      final result = AssetResult<String>(
        success: true,
        data: 'test data',
        msg: 'Success message',
      );

      expect(result.success, isTrue);
      expect(result.data, equals('test data'));
      expect(result.msg, equals('Success message'));
    });

    group('fromJson', () {
      test('parses AssetProfile type correctly', () {
        const String jsonString = '''
        {
          "success": true,
          "data": "{\\"customId\\":\\"custom123\\",\\"name\\":\\"Asset Name\\",\\"description\\":\\"Asset Description\\",\\"attributes\\":{\\"key\\":\\"value\\"}}",
          "msg": "Success"
        }
        ''';

        final result = AssetResult<AssetProfile>.fromJson(jsonString);

        expect(result.success, isTrue);
        expect(result.msg, equals('Success'));
        expect(result.data, isA<AssetProfile>());
        expect(result.data.customId, equals('custom123'));
        expect(result.data.name, equals('Asset Name'));
      });

      test('parses AssetDetailInfo type correctly', () {
        const String jsonString = '''
        {
          "success": true,
          "data": "{\\"id\\":\\"123\\",\\"device_id\\":\\"device123\\",\\"name\\":\\"Asset Name\\",\\"description\\":\\"Description\\",\\"created_at\\":1234567890,\\"updated_at\\":1234567891,\\"attributes\\":{\\"key\\":\\"value\\"}}",
          "msg": "Success"
        }
        ''';

        final result = AssetResult<AssetDetailInfo>.fromJson(jsonString);

        expect(result.success, isTrue);
        expect(result.msg, equals('Success'));
        expect(result.data, isA<AssetDetailInfo>());
        expect(result.data.id, equals('123'));
        expect(result.data.name, equals('Asset Name'));
      });

      test('parses DataTrackingConfig type correctly', () {
        const String jsonString = '''
        {
          "success": true,
          "data": "{\\"baseUrl\\":\\"https://custom.api.com\\",\\"dataStorageSize\\":5000,\\"dataUploadingBatchSize\\":30,\\"dataUploadingBatchWindow\\":20,\\"shouldClearLocalDataWhenCollision\\":true}",
          "msg": "Success"
        }
        ''';

        final result = AssetResult<DataTrackingConfig>.fromJson(jsonString);

        expect(result.success, isTrue);
        expect(result.msg, equals('Success'));
        expect(result.data, isA<DataTrackingConfig>());
        expect(result.data.baseUrl, equals('https://custom.api.com'));
        expect(result.data.dataStorageSize, equals(5000));
        expect(result.data.dataUploadingBatchSize, equals(30));
        expect(result.data.dataUploadingBatchWindow, equals(20));
        expect(result.data.shouldClearLocalDataWhenCollision, isTrue);
      });

      test('parses LocationConfig type correctly', () {
        const String jsonString = '''
        {
          "success": true,
          "data": "{\\"trackingMode\\":\\"balanced\\",\\"interval\\":60,\\"smallestDisplacement\\":10.0,\\"desiredAccuracy\\":\\"high\\",\\"maxWaitTime\\":2000,\\"fastestInterval\\":500,\\"enableStationaryCheck\\":true}",
          "msg": "Success"
        }
        ''';

        final result = AssetResult<LocationConfig>.fromJson(jsonString);

        expect(result.success, isTrue);
        expect(result.msg, equals('Success'));
        expect(result.data, isA<LocationConfig>());
        expect(result.data.trackingMode, equals(TrackingMode.balanced));
        expect(result.data.intervalForAndroid, equals(60));
        expect(result.data.smallestDisplacement, equals(10.0));
        expect(result.data.desiredAccuracy, equals(DesiredAccuracy.high));
      });

      test('handles simple types correctly', () {
        const String jsonString = '''
        {
          "success": true,
          "data": "simple string data",
          "msg": "Success"
        }
        ''';

        final result = AssetResult<String>.fromJson(jsonString);

        expect(result.success, isTrue);
        expect(result.msg, equals('Success'));
        expect(result.data, equals('simple string data'));
      });

      test('throws FormatException for invalid JSON', () {
        const invalidJson = '{invalid json}';

        expect(
          () => AssetResult<String>.fromJson(invalidJson),
          throwsFormatException,
        );
      });

      test('throws TypeError for mismatched types', () {
        const jsonString = '''
        {
          "success": true,
          "data": 123,
          "msg": "Success"
        }
        ''';

        expect(
          () => AssetResult<String>.fromJson(jsonString),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}
