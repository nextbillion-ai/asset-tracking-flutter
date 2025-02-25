import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_last_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_location.dart';

void main() {
  group('LatestLocation', () {
    test('constructor creates instance with required values', () {
      final location = TripLocation(lat: 1.0, lon: 2.0);
      final latestLocation = LatestLocation(
        location: location,
        timestamp: 1635731234,
      );

      expect(latestLocation.location, equals(location));
      expect(latestLocation.timestamp, equals(1635731234));
      expect(latestLocation.accuracy, isNull);
      expect(latestLocation.speed, isNull);
      expect(latestLocation.bearing, isNull);
      expect(latestLocation.altitude, isNull);
    });

    test('constructor creates instance with all values', () {
      final location = TripLocation(lat: 1.0, lon: 2.0);
      final latestLocation = LatestLocation(
        location: location,
        timestamp: 1635731234,
        accuracy: 10.0,
        speed: 60.0,
        bearing: 45.0,
        altitude: 100.0,
      );

      expect(latestLocation.location, equals(location));
      expect(latestLocation.timestamp, equals(1635731234));
      expect(latestLocation.accuracy, equals(10.0));
      expect(latestLocation.speed, equals(60.0));
      expect(latestLocation.bearing, equals(45.0));
      expect(latestLocation.altitude, equals(100.0));
    });

    group('fromJson', () {
      test('creates instance from complete JSON', () {
        final json = {
          'location': {
            'lat': 1.0,
            'lon': 2.0,
          },
          'timestamp': 1635731234,
          'accuracy': 10.0,
          'speed': 60.0,
          'bearing': 45.0,
          'altitude': 100.0,
        };

        final latestLocation = LatestLocation.fromJson(json);

        expect(latestLocation.location.lat, equals(1.0));
        expect(latestLocation.location.lon, equals(2.0));
        expect(latestLocation.timestamp, equals(1635731234));
        expect(latestLocation.accuracy, equals(10.0));
        expect(latestLocation.speed, equals(60.0));
        expect(latestLocation.bearing, equals(45.0));
        expect(latestLocation.altitude, equals(100.0));
      });

      test('creates instance with only required fields', () {
        final json = {
          'location': {
            'lat': 1.0,
            'lon': 2.0,
          },
          'timestamp': 1635731234,
        };

        final latestLocation = LatestLocation.fromJson(json);

        expect(latestLocation.location.lat, equals(1.0));
        expect(latestLocation.location.lon, equals(2.0));
        expect(latestLocation.timestamp, equals(1635731234));
        expect(latestLocation.accuracy, isNull);
        expect(latestLocation.speed, isNull);
        expect(latestLocation.bearing, isNull);
        expect(latestLocation.altitude, isNull);
      });
    });

    test('toJson converts instance to correct JSON format', () {
      final location = TripLocation(lat: 1.0, lon: 2.0);
      final latestLocation = LatestLocation(
        location: location,
        timestamp: 1635731234,
        accuracy: 10.0,
        speed: 60.0,
        bearing: 45.0,
        altitude: 100.0,
      );

      final json = latestLocation.toJson();

      expect(json['location'], equals(location.toJson()));
      expect(json['timestamp'], equals(1635731234));
      expect(json['accuracy'], equals(10.0));
      expect(json['speed'], equals(60.0));
      expect(json['bearing'], equals(45.0));
      expect(json['altitude'], equals(100.0));
    });
  });
}
