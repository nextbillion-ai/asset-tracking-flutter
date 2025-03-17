import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/default_config.dart';

void main() {
  group('DefaultConfig', () {
    test('creates instance with provided values', () {
      final config = DefaultConfig(
        enhanceService: true,
        repeatInterval: 300,
        workerEnabled: true,
        crashRestartEnabled: true,
        workOnMainThread: false,
      );

      expect(config.enhanceService, isTrue);
      expect(config.repeatInterval, equals(300));
      expect(config.workerEnabled, isTrue);
      expect(config.crashRestartEnabled, isTrue);
      expect(config.workOnMainThread, isFalse);
    });

    group('fromJson', () {
      test('creates instance from valid JSON string', () {
        const jsonString = '''
        {
          "enhanceService": true,
          "repeatInterval": 300,
          "workerEnabled": true,
          "crashRestartEnabled": true,
          "workOnMainThread": false
        }
        ''';

        final config = DefaultConfig.fromJson(jsonString);

        expect(config.enhanceService, isTrue);
        expect(config.repeatInterval, equals(300));
        expect(config.workerEnabled, isTrue);
        expect(config.crashRestartEnabled, isTrue);
        expect(config.workOnMainThread, isFalse);
      });

      test('throws FormatException for invalid JSON', () {
        expect(
          () => DefaultConfig.fromJson('{invalid json}'),
          throwsFormatException,
        );
      });

      test('throws TypeError when required fields are missing', () {
        const jsonString = '{}';

        expect(
          () => DefaultConfig.fromJson(jsonString),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('toJson', () {
      test('converts to JSON correctly', () {
        final config = DefaultConfig(
          enhanceService: true,
          repeatInterval: 300,
          workerEnabled: true,
          crashRestartEnabled: true,
          workOnMainThread: false,
        );

        final json = config.toJson();

        expect(json['enhanceService'], isTrue);
        expect(json['repeatInterval'], equals(300));
        expect(json['workerEnabled'], isTrue);
        expect(json['crashRestartEnabled'], isTrue);
        expect(json['workOnMainThread'], isFalse);
      });

      test('encodes via NBEncode mixin correctly', () {
        final config = DefaultConfig(
          enhanceService: true,
          repeatInterval: 300,
          workerEnabled: true,
          crashRestartEnabled: true,
          workOnMainThread: false,
        );

        final encoded = config.encode();
        expect(
          encoded,
          '{"enhanceService":true,'
          '"repeatInterval":300,'
          '"workerEnabled":true,'
          '"crashRestartEnabled":true,'
          '"workOnMainThread":false}',
        );
      });
    });
  });
}
