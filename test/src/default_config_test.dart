import 'package:nb_asset_tracking_flutter/src/default_config.dart';
import 'package:test/test.dart';

void main() {
  group('DefaultConfig', () {
    test('creates instance with provided values', () {
      final DefaultConfig config = DefaultConfig(
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
        final Map<String,dynamic > map = {
          'enhanceService': true,
          'repeatInterval': 300,
          'workerEnabled': true,
          'crashRestartEnabled': true,
          'workOnMainThread': false
        };

        final DefaultConfig config = DefaultConfig.fromJson(map);

        expect(config.enhanceService, isTrue);
        expect(config.repeatInterval, equals(300));
        expect(config.workerEnabled, isTrue);
        expect(config.crashRestartEnabled, isTrue);
        expect(config.workOnMainThread, isFalse);
      });
    });

    group('toJson', () {
      test('converts to JSON correctly', () {
        final DefaultConfig config = DefaultConfig(
          enhanceService: true,
          repeatInterval: 300,
          workerEnabled: true,
          crashRestartEnabled: true,
          workOnMainThread: false,
        );

        final Map<String, dynamic> json = config.toJson();

        expect(json['enhanceService'], isTrue);
        expect(json['repeatInterval'], equals(300));
        expect(json['workerEnabled'], isTrue);
        expect(json['crashRestartEnabled'], isTrue);
        expect(json['workOnMainThread'], isFalse);
      });

      test('encodes via NBEncode mixin correctly', () {
        final DefaultConfig config = DefaultConfig(
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
