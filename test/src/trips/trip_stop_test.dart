import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_stop.dart';

void main() {
  group('TripStop', () {
    test('constructor creates instance with required values', () {
      final stop = TripStop(
        name: 'Test Stop',
        geofenceId: 'geo123',
      );

      expect(stop.name, equals('Test Stop'));
      expect(stop.geofenceId, equals('geo123'));
      expect(stop.metaData, isNull);
    });

    test('constructor creates instance with all values', () {
      final stop = TripStop(
        name: 'Test Stop',
        geofenceId: 'geo123',
        metaData: {'key': 'value'},
      );

      expect(stop.name, equals('Test Stop'));
      expect(stop.geofenceId, equals('geo123'));
      expect(stop.metaData, equals({'key': 'value'}));
    });

    group('fromJson', () {
      test('creates instance from complete JSON', () {
        final json = {
          'name': 'Test Stop',
          'geofenceId': 'geo123',
          'metaData': {'key': 'value'},
        };

        final stop = TripStop.fromJson(json);

        expect(stop.name, equals('Test Stop'));
        expect(stop.geofenceId, equals('geo123'));
        expect(stop.metaData, equals({'key': 'value'}));
      });

      test('creates instance with minimal JSON', () {
        final json = {
          'name': 'Test Stop',
          'geofenceId': 'geo123',
        };

        final stop = TripStop.fromJson(json);

        expect(stop.name, equals('Test Stop'));
        expect(stop.geofenceId, equals('geo123'));
        expect(stop.metaData, isNull);
      });
    });

    test('toJson converts instance to correct JSON format', () {
      final stop = TripStop(
        name: 'Test Stop',
        geofenceId: 'geo123',
        metaData: {'key': 'value'},
      );

      final json = stop.toJson();

      expect(json['name'], equals('Test Stop'));
      expect(json['geofenceId'], equals('geo123'));
      expect(json['metaData'], equals({'key': 'value'}));
    });
  });
}
