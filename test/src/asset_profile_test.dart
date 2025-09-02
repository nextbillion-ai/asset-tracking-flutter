import 'package:nb_asset_tracking_flutter/src/asset_profile.dart';
import 'package:test/test.dart';

void main() {
  group('AssetProfile', () {
    test('creates instance with all properties', () {
      final AssetProfile profile = AssetProfile(
        customId: 'custom123',
        name: 'Asset Name',
        description: 'Asset Description',
        attributes: <String, String>{'key': 'value'},
      );

      expect(profile.customId, equals('custom123'));
      expect(profile.name, equals('Asset Name'));
      expect(profile.description, equals('Asset Description'));
      expect(profile.attributes, equals({'key': 'value'}));
    });

    group('toJson', () {
      test('converts to JSON correctly', () {
        final AssetProfile profile = AssetProfile(
          customId: 'custom123',
          name: 'Asset Name',
          description: 'Asset Description',
          attributes: <String, String>{'key': 'value'},
        );

        final Map<String, dynamic> json = profile.toJson();

        expect(json['customId'], equals('custom123'));
        expect(json['name'], equals('Asset Name'));
        expect(json['description'], equals('Asset Description'));
        expect(json['attributes'], equals({'key': 'value'}));
      });

      test('encodes via NBEncode mixin correctly', () {
        final AssetProfile profile = AssetProfile(
          customId: 'custom123',
          name: 'Asset Name',
          description: 'Asset Description',
          attributes: <String, String>{'key': 'value'},
        );

        final String encoded = profile.encode();
        expect(
          encoded,
          '{"customId":"custom123","description":"Asset Description",'
          '"name":"Asset Name","attributes":{"key":"value"}}',
        );
      });
    });

    group('fromJson', () {
      test('creates instance from valid JSON string', () {
        const jsonString = '''
        {
          "customId": "custom123",
          "name": "Asset Name",
          "description": "Asset Description",
          "attributes": {"key": "value"}
        }
        ''';

        final AssetProfile profile = AssetProfile.fromJson(jsonString);

        expect(profile.customId, equals('custom123'));
        expect(profile.name, equals('Asset Name'));
        expect(profile.description, equals('Asset Description'));
        expect(profile.attributes, equals({'key': 'value'}));
      });

      test('throws FormatException for invalid JSON', () {
        expect(
          () => AssetProfile.fromJson('{invalid json}'),
          throwsFormatException,
        );
      });

      test('throws TypeError when required fields are missing', () {
        const jsonString = '{}';

        expect(
          () => AssetProfile.fromJson(jsonString),
          throwsA(isA<TypeError>()),
        );
      });

      test('throws TypeError when required string fields have wrong type', () {
        const jsonString = '''
        {
          "customId": 123,
          "name": "Asset Name",
          "description": "Asset Description",
          "attributes": {"key": "value"}
        }
        ''';

        expect(
          () => AssetProfile.fromJson(jsonString),
          throwsA(isA<TypeError>()),
        );
      });

      test('accepts attributes with non-string values', () {
        const jsonString = '''
        {
          "customId": "custom123",
          "name": "Asset Name",
          "description": "Asset Description",
          "attributes": {
            "stringKey": "value",
            "numKey": 123,
            "boolKey": true,
            "nullKey": null
          }
        }
        ''';

        final AssetProfile profile = AssetProfile.fromJson(jsonString);

        expect(profile.attributes['stringKey'], equals('value'));
        expect(profile.attributes['numKey'], equals(123));
        expect(profile.attributes['boolKey'], equals(true));
        expect(profile.attributes['nullKey'], isNull);
      });
    });
  });
}
