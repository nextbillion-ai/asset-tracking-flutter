import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/ios_notification_config.dart';

void main() {
  group('IOSNotificationConfig', () {
    test('creates instance with default values', () {
      final config = IOSNotificationConfig();

      expect(config.showAssetEnableNotification, isTrue);
      expect(config.showAssetDisableNotification, isTrue);
      expect(config.showLowBatteryNotification, isFalse);
      expect(config.assetEnableNotificationConfig.identifier,
          equals('startTrackingIdentifier'));
      expect(config.assetDisableNotificationConfig.identifier,
          equals('stopTrackingIdentifier'));
      expect(config.lowBatteryNotificationConfig.identifier,
          equals('lowBatteryIdentifier'));
    });

    group('fromJson', () {
      test('creates instance from valid JSON string', () {
        const jsonString = '''
        {
          "assetEnableNotificationConfig": {
            "identifier": "customStartId",
            "title": "Custom Start Title",
            "content": "Custom Start Content"
          },
          "assetDisableNotificationConfig": {
            "identifier": "customStopId",
            "title": "Custom Stop Title",
            "content": "Custom Stop Content",
            "assetIDTrackedContent": "Custom Asset [assetId] Content"
          },
          "lowBatteryNotificationConfig": {
            "identifier": "customBatteryId",
            "title": "Custom Battery Title",
            "content": "Custom Battery Content",
            "minBatteryLevel": 15
          },
          "showAssetEnableNotification": false,
          "showAssetDisableNotification": false,
          "showLowBatteryNotification": true
        }
        ''';

        final config = IOSNotificationConfig.fromJson(jsonString);

        expect(config.showAssetEnableNotification, isFalse);
        expect(config.showAssetDisableNotification, isFalse);
        expect(config.showLowBatteryNotification, isTrue);

        // Check AssetEnableNotificationConfig
        expect(config.assetEnableNotificationConfig.identifier,
            equals('customStartId'));
        expect(config.assetEnableNotificationConfig.title,
            equals('Custom Start Title'));
        expect(config.assetEnableNotificationConfig.content,
            equals('Custom Start Content'));

        // Check AssetDisableNotificationConfig
        expect(config.assetDisableNotificationConfig.identifier,
            equals('customStopId'));
        expect(config.assetDisableNotificationConfig.title,
            equals('Custom Stop Title'));
        expect(config.assetDisableNotificationConfig.content,
            equals('Custom Stop Content'));
        expect(config.assetDisableNotificationConfig.assetIDTrackedContent,
            equals('Custom Asset [assetId] Content'));

        // Check LowBatteryStatusNotificationConfig
        expect(config.lowBatteryNotificationConfig.identifier,
            equals('customBatteryId'));
        expect(config.lowBatteryNotificationConfig.title,
            equals('Custom Battery Title'));
        expect(config.lowBatteryNotificationConfig.content,
            equals('Custom Battery Content'));
        expect(config.lowBatteryNotificationConfig.minBatteryLevel, equals(15));
      });

      test('throws FormatException for invalid JSON', () {
        expect(
          () => IOSNotificationConfig.fromJson('{invalid json}'),
          throwsFormatException,
        );
      });
    });

    group('toJson', () {
      test('converts to JSON correctly', () {
        final config = IOSNotificationConfig();
        config.showAssetEnableNotification = false;
        config.showLowBatteryNotification = true;

        final json = config.toJson();

        expect(json['showAssetEnableNotification'], isFalse);
        expect(json['showAssetDisableNotification'], isTrue);
        expect(json['showLowBatteryNotification'], isTrue);
        expect(json['assetEnableNotificationConfig'], isMap);
        expect(json['assetDisableNotificationConfig'], isMap);
        expect(json['lowBatteryNotificationConfig'], isMap);
      });

      test('encodes via NBEncode mixin correctly', () {
        final config = IOSNotificationConfig();
        final encoded = config.encode();
        expect(encoded, contains('"showAssetEnableNotification":true'));
        expect(encoded, contains('"showAssetDisableNotification":true'));
        expect(encoded, contains('"showLowBatteryNotification":false'));
      });
    });
  });

  group('AssetEnableNotificationConfig', () {
    test('creates instance with default values', () {
      final config = AssetEnableNotificationConfig(identifier: 'testId');

      expect(config.identifier, equals('testId'));
      expect(config.title, isEmpty);
      expect(
          config.content,
          equals(
              "Asset tracking is now enabled and your device's location will be tracked"));
    });

    test('fromJson creates instance correctly', () {
      final json = {
        'identifier': 'testId',
        'title': 'Test Title',
        'content': 'Test Content'
      };

      final config = AssetEnableNotificationConfig.fromJson(json);

      expect(config.identifier, equals('testId'));
      expect(config.title, equals('Test Title'));
      expect(config.content, equals('Test Content'));
    });
  });

  group('AssetDisableNotificationConfig', () {
    test('creates instance with default values', () {
      final config = AssetDisableNotificationConfig(identifier: 'testId');

      expect(config.identifier, equals('testId'));
      expect(config.title, isEmpty);
      expect(
          config.content,
          equals(
              "Asset tracking is now disabled and your device's location will no longer be tracked"));
      expect(
          config.assetIDTrackedContent,
          equals(
              "Asset [assetId] is being tracked on another device. Tracking has been stopped on this device"));
    });
  });

  group('LowBatteryStatusNotificationConfig', () {
    test('creates instance with default values', () {
      final config = LowBatteryStatusNotificationConfig(identifier: 'testId');

      expect(config.identifier, equals('testId'));
      expect(config.title, isEmpty);
      expect(config.minBatteryLevel, equals(10));
      const double level = 10;
      expect(
          config.content,
          equals(
              "Your device's battery level is lower than $level. Please recharge to continue tracking assets"));
    });

    test('creates instance with custom battery level', () {
      final config = LowBatteryStatusNotificationConfig(
          identifier: 'testId', minBatteryLevel: 15);

      expect(config.minBatteryLevel, equals(15));
      const double level = 15;
      expect(
          config.content,
          equals(
              "Your device's battery level is lower than $level. Please recharge to continue tracking assets"));
    });
  });
}
