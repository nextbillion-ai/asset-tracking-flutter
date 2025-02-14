import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/low_battery_notification_config.dart';

void main() {
  group('LowBatteryNotificationConfig', () {
    test('creates instance with default values', () {
      final config = LowBatteryNotificationConfig();

      expect(config.threshold, equals(10.0));
      expect(config.channelId, equals('LowBatteryChannelId'));
      expect(config.channelName, equals('LowBatteryChannelName'));
      expect(config.title, equals('Default Notification Title'));
      expect(
          config.content,
          equals(
              'Your device\'s battery level is low. Please recharge to continue tracking assets'));
      expect(config.smallIcon, equals(0));
    });

    test('creates instance with custom values', () {
      final config = LowBatteryNotificationConfig(
        threshold: 15.0,
        channelId: 'CustomChannelId',
        channelName: 'CustomChannelName',
        title: 'Custom Title',
        content: 'Custom Content',
        smallIcon: 123,
      );

      expect(config.threshold, equals(15.0));
      expect(config.channelId, equals('CustomChannelId'));
      expect(config.channelName, equals('CustomChannelName'));
      expect(config.title, equals('Custom Title'));
      expect(config.content, equals('Custom Content'));
      expect(config.smallIcon, equals(123));
    });

    test('defaultConfig constant has correct values', () {
      expect(
          LowBatteryNotificationConfig.defaultConfig.threshold, equals(10.0));
      expect(LowBatteryNotificationConfig.defaultConfig.channelId,
          equals('LowBatteryChannelId'));
      expect(LowBatteryNotificationConfig.defaultConfig.channelName,
          equals('LowBatteryChannelName'));
      expect(LowBatteryNotificationConfig.defaultConfig.title,
          equals('Default Notification Title'));
      expect(
          LowBatteryNotificationConfig.defaultConfig.content,
          equals(
              'Your device\'s battery level is low. Please recharge to continue tracking assets'));
      expect(LowBatteryNotificationConfig.defaultConfig.smallIcon, equals(0));
    });

    group('fromJson', () {
      test('creates instance from valid JSON string', () {
        final jsonString = '''
        {
          "threshold": 15.0,
          "channelId": "CustomChannelId",
          "channelName": "CustomChannelName",
          "title": "Custom Title",
          "content": "Custom Content",
          "smallIcon": 123
        }
        ''';

        final config = LowBatteryNotificationConfig.fromJson(jsonString);

        expect(config.threshold, equals(15.0));
        expect(config.channelId, equals('CustomChannelId'));
        expect(config.channelName, equals('CustomChannelName'));
        expect(config.title, equals('Custom Title'));
        expect(config.content, equals('Custom Content'));
        expect(config.smallIcon, equals(123));
      });

      test('throws FormatException for invalid JSON', () {
        expect(
          () => LowBatteryNotificationConfig.fromJson('{invalid json}'),
          throwsFormatException,
        );
      });

      test('handles integer threshold in JSON', () {
        final jsonString = '''
        {
          "threshold": 15,
          "channelId": "CustomChannelId",
          "channelName": "CustomChannelName",
          "title": "Custom Title",
          "content": "Custom Content",
          "smallIcon": 123
        }
        ''';

        final config = LowBatteryNotificationConfig.fromJson(jsonString);
        expect(config.threshold, equals(15.0));
      });
    });

    group('toJson', () {
      test('converts to JSON correctly', () {
        final config = LowBatteryNotificationConfig(
          threshold: 15.0,
          channelId: 'CustomChannelId',
          channelName: 'CustomChannelName',
          title: 'Custom Title',
          content: 'Custom Content',
          smallIcon: 123,
        );

        final json = config.toJson();

        expect(json['threshold'], equals(15.0));
        expect(json['channelId'], equals('CustomChannelId'));
        expect(json['channelName'], equals('CustomChannelName'));
        expect(json['title'], equals('Custom Title'));
        expect(json['content'], equals('Custom Content'));
        expect(json['smallIcon'], equals(123));
      });

      test('encodes via NBEncode mixin correctly', () {
        final config = LowBatteryNotificationConfig(
          threshold: 15.0,
          channelId: 'CustomChannelId',
          channelName: 'CustomChannelName',
          title: 'Custom Title',
          content: 'Custom Content',
          smallIcon: 123,
        );

        final encoded = config.encode();
        expect(
          encoded,
          '{"threshold":15.0,'
          '"channelId":"CustomChannelId",'
          '"channelName":"CustomChannelName",'
          '"title":"Custom Title",'
          '"content":"Custom Content",'
          '"smallIcon":123}',
        );
      });
    });
  });
}
