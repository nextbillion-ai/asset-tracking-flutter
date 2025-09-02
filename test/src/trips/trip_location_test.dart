import 'package:nb_asset_tracking_flutter/src/trips/trip_location.dart';
import 'package:test/test.dart';

void main() {
  group('TripLocation', () {
    test('creates instance with default values', () {
      final TripLocation location = TripLocation();
      expect(location.lat, equals(0.0));
      expect(location.lon, equals(0.0));
    });

    test('creates instance with provided values', () {
      final TripLocation location = TripLocation(lat: 45.0, lon: -122.0);
      expect(location.lat, equals(45.0));
      expect(location.lon, equals(-122.0));
    });

    group('fromJson', () {
      test('creates instance from valid JSON', () {
        final Map<String, dynamic> json = <String, double>{'lat': 45.0, 'lon': -122.0};
        final TripLocation location = TripLocation.fromJson(json);
        expect(location.lat, equals(45.0));
        expect(location.lon, equals(-122.0));
      });

      test('handles integer values in JSON', () {
        final Map<String, dynamic> json = <String, int>{'lat': 45, 'lon': -122};
        final TripLocation location = TripLocation.fromJson(json);
        expect(location.lat, equals(45.0));
        expect(location.lon, equals(-122.0));
      });

      test('handles null values in JSON', () {
        final Map<String, dynamic> json = <String, dynamic>{};
        final TripLocation location = TripLocation.fromJson(json);
        expect(location.lat, equals(0.0));
        expect(location.lon, equals(0.0));
      });
    });

    test('converts to JSON correctly', () {
      final TripLocation location = TripLocation(lat: 45.0, lon: -122.0);
      final Map<String, dynamic> json = location.toJson();
      expect(json, equals(<String, double>{'lat': 45.0, 'lon': -122.0}));
    });

    group('equality', () {
      test('identical objects are equal', () {
        final TripLocation location1 = TripLocation(lat: 45.0, lon: -122.0);
        final TripLocation location2 = TripLocation(lat: 45.0, lon: -122.0);
        expect(location1, equals(location2));
        expect(location1.hashCode, equals(location2.hashCode));
      });

      test('different objects are not equal', () {
        final TripLocation location1 = TripLocation(lat: 45.0, lon: -122.0);
        final TripLocation location2 = TripLocation(lat: 45.1, lon: -122.0);
        final TripLocation location3 = TripLocation(lat: 45.0, lon: -122.1);

        expect(location1, isNot(equals(location2)));
        expect(location1, isNot(equals(location3)));
      });
    });
  });
}
