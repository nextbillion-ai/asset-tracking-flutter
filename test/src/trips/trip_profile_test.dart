import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_profile.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_stop.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_location.dart';

void main() {
  group('TripProfile', () {
    test('constructor creates instance with required values', () {
      final profile = TripProfile(
        customId: 'custom123',
        name: 'Test Profile',
      );

      expect(profile.customId, equals('custom123'));
      expect(profile.name, equals('Test Profile'));
      expect(profile.description, isNull);
      expect(profile.attributes, isNull);
      expect(profile.metaData, isNull);
      expect(profile.stops, isNull);
    });

    test('constructor throws error when name is empty', () {
      expect(
        () => TripProfile(customId: 'custom123', name: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('constructor creates instance with all values', () {
      final stops = [
        TripStop(
          name: 'Stop 1',
          geofenceId: 'geo123',
          metaData: {'key': 'value'},
        )
      ];

      final profile = TripProfile(
        customId: 'custom123',
        name: 'Test Profile',
        description: 'Test Description',
        attributes: {'attr1': 'value1'},
        metaData: {'key': 'value'},
        stops: stops,
      );

      expect(profile.customId, equals('custom123'));
      expect(profile.name, equals('Test Profile'));
      expect(profile.description, equals('Test Description'));
      expect(profile.attributes, equals({'attr1': 'value1'}));
      expect(profile.metaData, equals({'key': 'value'}));
      expect(profile.stops, equals(stops));
    });

    group('fromJson', () {
      test('creates instance from complete JSON', () {
        final json = {
          'customId': 'custom123',
          'name': 'Test Profile',
          'description': 'Test Description',
          'attributes': {'attr1': 'value1'},
          'metaData': {'key': 'value'},
          'stops': [
            {
              'name': 'Stop 1',
              'geofenceId': 'geo123',
              'metaData': {'key': 'value'},
            }
          ],
        };

        final profile = TripProfile.fromJson(json);

        expect(profile.customId, equals('custom123'));
        expect(profile.name, equals('Test Profile'));
        expect(profile.description, equals('Test Description'));
        expect(profile.attributes, equals({'attr1': 'value1'}));
        expect(profile.metaData, equals({'key': 'value'}));
        expect(profile.stops?.length, equals(1));
        expect(profile.stops?.first.name, equals('Stop 1'));
        expect(profile.stops?.first.geofenceId, equals('geo123'));
        expect(profile.stops?.first.metaData, equals({'key': 'value'}));
      });

      test('creates instance with minimal JSON', () {
        final json = {
          'customId': 'custom123',
          'name': 'Test Profile',
        };

        final profile = TripProfile.fromJson(json);

        expect(profile.customId, equals('custom123'));
        expect(profile.name, equals('Test Profile'));
        expect(profile.description, isNull);
        expect(profile.attributes, isNull);
        expect(profile.metaData, isNull);
        expect(profile.stops, isNull);
      });
    });

    test('toJson converts instance to correct JSON format', () {
      final stops = [
        TripStop(
          name: 'Stop 1',
          geofenceId: 'geo123',
          metaData: {'key': 'value'},
        )
      ];

      final profile = TripProfile(
        customId: 'custom123',
        name: 'Test Profile',
        description: 'Test Description',
        attributes: {'attr1': 'value1'},
        metaData: {'key': 'value'},
        stops: stops,
      );

      final json = profile.toJson();

      expect(json['customId'], equals('custom123'));
      expect(json['name'], equals('Test Profile'));
      expect(json['description'], equals('Test Description'));
      expect(json['attributes'], equals({'attr1': 'value1'}));
      expect(json['metaData'], equals({'key': 'value'}));
      expect(json['stops'], isList);
      expect(json['stops']?.first['name'], equals('Stop 1'));
      expect(json['stops']?.first['geofenceId'], equals('geo123'));
      expect(json['stops']?.first['metaData'], equals({'key': 'value'}));
    });
  });
}
