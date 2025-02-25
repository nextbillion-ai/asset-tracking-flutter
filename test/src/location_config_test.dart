import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/location_config.dart';

void main() {
  group('DesiredAccuracy', () {
    test('fromString returns correct values', () {
      expect(DesiredAccuracy.fromString('high'), equals(DesiredAccuracy.high));
      expect(
          DesiredAccuracy.fromString('medium'), equals(DesiredAccuracy.medium));
      expect(DesiredAccuracy.fromString('low'), equals(DesiredAccuracy.low));
      expect(
          DesiredAccuracy.fromString('invalid'), equals(DesiredAccuracy.high));
    });
  });

  group('TrackingMode', () {
    test('fromString returns correct values', () {
      expect(TrackingMode.fromString('active'), equals(TrackingMode.active));
      expect(
          TrackingMode.fromString('balanced'), equals(TrackingMode.balanced));
      expect(TrackingMode.fromString('passive'), equals(TrackingMode.passive));
      expect(TrackingMode.fromString('custom'), equals(TrackingMode.custom));
      expect(TrackingMode.fromString('invalid'), equals(TrackingMode.active));
    });
  });

  group('LocationConfig', () {
    test('creates instance with default values', () {
      final config = LocationConfig();

      expect(config.trackingMode, equals(TrackingMode.active));
      expect(config.intervalForAndroid, isNull);
      expect(config.smallestDisplacement, isNull);
      expect(config.desiredAccuracy, isNull);
      expect(config.maxWaitTimeForAndroid, isNull);
      expect(config.fastestIntervalForAndroid, isNull);
      expect(config.enableStationaryCheck, isNull);
    });

    test('creates instance with custom values', () {
      final config = LocationConfig(
        trackingMode: TrackingMode.custom,
        intervalForAndroid: 1000,
        smallestDisplacement: 10.0,
        desiredAccuracy: DesiredAccuracy.high,
        maxWaitTimeForAndroid: 2000,
        fastestIntervalForAndroid: 500,
        enableStationaryCheck: true,
      );

      expect(config.trackingMode, equals(TrackingMode.custom));
      expect(config.intervalForAndroid, equals(1000));
      expect(config.smallestDisplacement, equals(10.0));
      expect(config.desiredAccuracy, equals(DesiredAccuracy.high));
      expect(config.maxWaitTimeForAndroid, equals(2000));
      expect(config.fastestIntervalForAndroid, equals(500));
      expect(config.enableStationaryCheck, isTrue);
    });

    group('factory constructors', () {
      test('activeConfig creates correct instance', () {
        final config = LocationConfig.activeConfig();
        expect(config.trackingMode, equals(TrackingMode.active));
      });

      test('balancedConfig creates correct instance', () {
        final config = LocationConfig.balancedConfig();
        expect(config.trackingMode, equals(TrackingMode.balanced));
      });

      test('passiveConfig creates correct instance', () {
        final config = LocationConfig.passiveConfig();
        expect(config.trackingMode, equals(TrackingMode.passive));
      });

      test('customConfig creates correct instance', () {
        final config = LocationConfig.customConfig(
          intervalForAndroid: 1000,
          smallestDisplacement: 10.0,
          desiredAccuracy: DesiredAccuracy.high,
          maxWaitTimeForAndroid: 2000,
          fastestIntervalForAndroid: 500,
          enableStationaryCheck: true,
        );

        expect(config.trackingMode, equals(TrackingMode.custom));
        expect(config.intervalForAndroid, equals(1000));
        expect(config.smallestDisplacement, equals(10.0));
        expect(config.desiredAccuracy, equals(DesiredAccuracy.high));
        expect(config.maxWaitTimeForAndroid, equals(2000));
        expect(config.fastestIntervalForAndroid, equals(500));
        expect(config.enableStationaryCheck, isTrue);
      });

      test('config factory creates correct instances for each mode', () {
        expect(LocationConfig.config(TrackingMode.active).trackingMode,
            equals(TrackingMode.active));
        expect(LocationConfig.config(TrackingMode.balanced).trackingMode,
            equals(TrackingMode.balanced));
        expect(LocationConfig.config(TrackingMode.passive).trackingMode,
            equals(TrackingMode.passive));

        final customConfig = LocationConfig.config(TrackingMode.custom);
        expect(customConfig.trackingMode, equals(TrackingMode.custom));
        expect(customConfig.desiredAccuracy, equals(DesiredAccuracy.high));
        expect(customConfig.enableStationaryCheck, isTrue);
      });
    });

    group('fromJson', () {
      test('creates instance from valid JSON string', () {
        const jsonString = '''
        {
          "trackingMode": "custom",
          "interval": 1000,
          "smallestDisplacement": 10.0,
          "desiredAccuracy": "high",
          "maxWaitTime": 2000,
          "fastestInterval": 500,
          "enableStationaryCheck": true
        }
        ''';

        final config = LocationConfig.fromJson(jsonString);

        expect(config.trackingMode, equals(TrackingMode.custom));
        expect(config.intervalForAndroid, equals(1000));
        expect(config.smallestDisplacement, equals(10.0));
        expect(config.desiredAccuracy, equals(DesiredAccuracy.high));
        expect(config.maxWaitTimeForAndroid, equals(2000));
        expect(config.fastestIntervalForAndroid, equals(500));
        expect(config.enableStationaryCheck, isTrue);
      });

      test('handles missing values with defaults', () {
        const jsonString = '{}';
        final config = LocationConfig.fromJson(jsonString);

        expect(config.intervalForAndroid, equals(0));
        expect(config.smallestDisplacement, equals(0));
        expect(config.desiredAccuracy, equals(DesiredAccuracy.high));
        expect(config.maxWaitTimeForAndroid, equals(0));
        expect(config.fastestIntervalForAndroid, equals(0));
        expect(config.enableStationaryCheck, isFalse);
      });

      test('throws FormatException for invalid JSON', () {
        expect(
          () => LocationConfig.fromJson('{invalid json}'),
          throwsFormatException,
        );
      });
    });

    group('toJson', () {
      test('converts to JSON correctly', () {
        final config = LocationConfig(
          trackingMode: TrackingMode.custom,
          intervalForAndroid: 1000,
          smallestDisplacement: 10.0,
          desiredAccuracy: DesiredAccuracy.high,
          maxWaitTimeForAndroid: 2000,
          fastestIntervalForAndroid: 500,
          enableStationaryCheck: true,
        );

        final json = config.toJson();

        expect(json['trackingMode'], equals('custom'));
        expect(json['interval'], equals(1000));
        expect(json['smallestDisplacement'], equals(10.0));
        expect(json['desiredAccuracy'], equals('high'));
        expect(json['maxWaitTime'], equals(2000));
        expect(json['fastestInterval'], equals(500));
        expect(json['enableStationaryCheck'], isTrue);
      });

      test('handles null values with defaults', () {
        final config = LocationConfig();
        final json = config.toJson();

        expect(json['trackingMode'], equals('active'));
        expect(json['interval'], equals(0));
        expect(json['smallestDisplacement'], equals(0.0));
        expect(json['desiredAccuracy'], equals('high'));
        expect(json['maxWaitTime'], equals(0));
        expect(json['fastestInterval'], equals(0));
        expect(json['enableStationaryCheck'], isTrue);
      });
    });
  });
}
