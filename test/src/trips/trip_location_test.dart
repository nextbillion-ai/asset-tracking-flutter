import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_location.dart';

void main() {
  group('TripLocation', () {
    test('creates instance with default values', () {
      final location = TripLocation();
      expect(location.lat, equals(0.0));
      expect(location.lon, equals(0.0));
    });

    test('creates instance with provided values', () {
      final location = TripLocation(lat: 45.0, lon: -122.0);
      expect(location.lat, equals(45.0));
      expect(location.lon, equals(-122.0));
    });

    group('fromJson', () {
      test('creates instance from valid JSON', () {
        final json = {'lat': 45.0, 'lon': -122.0};
        final location = TripLocation.fromJson(json);
        expect(location.lat, equals(45.0));
        expect(location.lon, equals(-122.0));
      });

      test('handles integer values in JSON', () {
        final json = {'lat': 45, 'lon': -122};
        final location = TripLocation.fromJson(json);
        expect(location.lat, equals(45.0));
        expect(location.lon, equals(-122.0));
      });

      test('handles null values in JSON', () {
        final json = <String, dynamic>{};
        final location = TripLocation.fromJson(json);
        expect(location.lat, equals(0.0));
        expect(location.lon, equals(0.0));
      });
    });

    test('converts to JSON correctly', () {
      final location = TripLocation(lat: 45.0, lon: -122.0);
      final json = location.toJson();
      expect(json, equals({'lat': 45.0, 'lon': -122.0}));
    });

    group('equality', () {
      test('identical objects are equal', () {
        final location1 = TripLocation(lat: 45.0, lon: -122.0);
        final location2 = TripLocation(lat: 45.0, lon: -122.0);
        expect(location1, equals(location2));
        expect(location1.hashCode, equals(location2.hashCode));
      });

      test('different objects are not equal', () {
        final location1 = TripLocation(lat: 45.0, lon: -122.0);
        final location2 = TripLocation(lat: 45.1, lon: -122.0);
        final location3 = TripLocation(lat: 45.0, lon: -122.1);

        expect(location1, isNot(equals(location2)));
        expect(location1, isNot(equals(location3)));
      });
    });
  });
}
