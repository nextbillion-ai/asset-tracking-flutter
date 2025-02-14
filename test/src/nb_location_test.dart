import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/nb_location.dart';

void main() {
  group('NBLocation', () {
    test('creates instance with provided values', () {
      final location = NBLocation(
        latitude: 45.0,
        longitude: -122.0,
        accuracy: 10.0,
        altitude: 100.0,
        speed: 5.0,
        speedAccuracy: 1.0,
        heading: 90.0,
        provider: "gps",
        timestamp: 1234567890,
      );

      expect(location.latitude, equals(45.0));
      expect(location.longitude, equals(-122.0));
      expect(location.accuracy, equals(10.0));
      expect(location.altitude, equals(100.0));
      expect(location.speed, equals(5.0));
      expect(location.speedAccuracy, equals(1.0));
      expect(location.heading, equals(90.0));
      expect(location.provider, equals("gps"));
      expect(location.timestamp, equals(1234567890));
    });

    group('fromJson', () {
      test('creates instance from valid JSON string', () {
        final jsonString = '''
        {
          "latitude": 45.0,
          "longitude": -122.0,
          "accuracy": 10.0,
          "altitude": 100.0,
          "speed": 5.0,
          "speedAccuracy": 1.0,
          "heading": 90.0,
          "provider": "gps",
          "timestamp": 1234567890
        }
        ''';

        final location = NBLocation.fromJson(jsonString);

        expect(location.latitude, equals(45.0));
        expect(location.longitude, equals(-122.0));
        expect(location.accuracy, equals(10.0));
        expect(location.altitude, equals(100.0));
        expect(location.speed, equals(5.0));
        expect(location.speedAccuracy, equals(1.0));
        expect(location.heading, equals(90.0));
        expect(location.provider, equals("gps"));
        expect(location.timestamp, equals(1234567890));
      });

      test('handles missing values in JSON with defaults', () {
        final jsonString = '{}';
        final location = NBLocation.fromJson(jsonString);

        expect(location.latitude, equals(0.0));
        expect(location.longitude, equals(0.0));
        expect(location.accuracy, equals(0.0));
        expect(location.altitude, equals(0.0));
        expect(location.speed, equals(0.0));
        expect(location.speedAccuracy, equals(0.0));
        expect(location.heading, equals(0.0));
        expect(location.provider, equals(""));
        expect(location.timestamp, equals(0));
      });

      test('handles integer values in JSON', () {
        final jsonString = '''
        {
          "latitude": 45,
          "longitude": -122,
          "accuracy": 10,
          "altitude": 100,
          "speed": 5,
          "speedAccuracy": 1,
          "heading": 90,
          "provider": "gps",
          "timestamp": 1234567890
        }
        ''';

        final location = NBLocation.fromJson(jsonString);
        expect(location.latitude, equals(45));
        expect(location.longitude, equals(-122));
      });

      test('throws FormatException for invalid JSON', () {
        final invalidJson = '{invalid json}';
        expect(
          () => NBLocation.fromJson(invalidJson),
          throwsFormatException,
        );
      });
    });
  });
}
