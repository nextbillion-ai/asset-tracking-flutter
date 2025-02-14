import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/trips/track_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_location.dart';

void main() {
  group('TrackLocation', () {
    test('constructor creates instance with correct values', () {
      final timestamp = DateTime.now();
      final location = TripLocation(lat: 1.0, lon: 2.0);

      final trackLocation = TrackLocation(
        accuracy: 5.0,
        altitude: 100.0,
        bearing: 45.0,
        location: location,
        metaData: {'key': 'value'},
        speed: 60.0,
        timestamp: timestamp,
        batteryLevel: 80,
        trackingMode: 'active',
      );

      expect(trackLocation.accuracy, equals(5.0));
      expect(trackLocation.altitude, equals(100.0));
      expect(trackLocation.bearing, equals(45.0));
      expect(trackLocation.location, equals(location));
      expect(trackLocation.metaData, equals({'key': 'value'}));
      expect(trackLocation.speed, equals(60.0));
      expect(trackLocation.timestamp, equals(timestamp));
      expect(trackLocation.batteryLevel, equals(80));
      expect(trackLocation.trackingMode, equals('active'));
    });

    group('fromJson', () {
      test('creates instance from valid JSON', () {
        final json = {
          'accuracy': 5.0,
          'altitude': 100.0,
          'bearing': 45.0,
          'location': {
            'lat': 1.0,
            'lon': 2.0,
          },
          'meta_data': {'key': 'value'},
          'speed': 60.0,
          'timestamp': 1635731234, // Unix timestamp in seconds
          'battery_level': 80,
          'tracking_mode': 'active',
        };

        final trackLocation = TrackLocation.fromJson(json);

        expect(trackLocation.accuracy, equals(5.0));
        expect(trackLocation.altitude, equals(100.0));
        expect(trackLocation.bearing, equals(45.0));
        expect(trackLocation.location?.lat, equals(1.0));
        expect(trackLocation.location?.lon, equals(2.0));
        expect(trackLocation.metaData, equals({'key': 'value'}));
        expect(trackLocation.speed, equals(60.0));
        expect(trackLocation.timestamp,
            equals(DateTime.fromMillisecondsSinceEpoch(1635731234 * 1000)));
        expect(trackLocation.batteryLevel, equals(80));
        expect(trackLocation.trackingMode, equals('active'));
      });

      test('handles null values in JSON', () {
        final json = {
          'accuracy': null,
          'altitude': null,
          'bearing': null,
          'location': null,
          'meta_data': null,
          'speed': null,
          'timestamp': null,
          'battery_level': 0,
          'tracking_mode': null,
        };

        final trackLocation = TrackLocation.fromJson(json);

        expect(trackLocation.accuracy, isNull);
        expect(trackLocation.altitude, isNull);
        expect(trackLocation.bearing, isNull);
        expect(trackLocation.location, isNull);
        expect(trackLocation.metaData, isNull);
        expect(trackLocation.speed, isNull);
        expect(trackLocation.timestamp, isNull);
        expect(trackLocation.batteryLevel, equals(0));
        expect(trackLocation.trackingMode, isNull);
      });

      test('handles null coordinates in location', () {
        final json = {
          'accuracy': null,
          'altitude': null,
          'bearing': null,
          'location': {
            'lat': null,
            'lon': null,
          },
          'meta_data': null,
          'speed': null,
          'timestamp': null,
          'battery_level': 0,
          'tracking_mode': null,
        };

        final trackLocation = TrackLocation.fromJson(json);
        expect(trackLocation.location?.lat, equals(0.0));
        expect(trackLocation.location?.lon, equals(0.0));
      });
    });

    test('toJson converts instance to correct JSON format', () {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(1635731234 * 1000);
      final location = TripLocation(lat: 1.0, lon: 2.0);

      final trackLocation = TrackLocation(
        accuracy: 5.0,
        altitude: 100.0,
        bearing: 45.0,
        location: location,
        metaData: {'key': 'value'},
        speed: 60.0,
        timestamp: timestamp,
        batteryLevel: 80,
        trackingMode: 'active',
      );

      final json = trackLocation.toJson();

      expect(
          json,
          equals({
            'accuracy': 5.0,
            'altitude': 100.0,
            'bearing': 45.0,
            'location': location.toJson(),
            'meta_data': {'key': 'value'},
            'speed': 60.0,
            'timestamp': timestamp,
            'battery_level': 80,
            'tracking_mode': 'active',
          }));
    });
  });
}
