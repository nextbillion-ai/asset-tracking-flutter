import 'package:nb_asset_tracking_flutter/src/trips/trip_stop.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_update_profile.dart';
import 'package:test/test.dart';

void main() {
  group('TripUpdateProfile', () {
    test('constructor creates instance with required values', () {
      final TripUpdateProfile profile = TripUpdateProfile(
        name: 'Test Profile',
      );

      expect(profile.name, equals('Test Profile'));
      expect(profile.description, isNull);
      expect(profile.attributes, isNull);
      expect(profile.metaData, isNull);
      expect(profile.stops, isNull);
    });

    test('constructor throws error when name is empty', () {
      expect(
        () => TripUpdateProfile(name: ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('constructor creates instance with all values', () {
      final List<TripStop> stops = <TripStop>[
        TripStop(
          name: 'Stop 1',
          geofenceId: 'geo123',
          metaData: <String, String>{'key': 'value'},
        )
      ];

      final TripUpdateProfile profile = TripUpdateProfile(
        name: 'Test Profile',
        description: 'Test Description',
        attributes: <String, String>{'attr1': 'value1'},
        metaData: <String, String>{'key': 'value'},
        stops: stops,
      );

      expect(profile.name, equals('Test Profile'));
      expect(profile.description, equals('Test Description'));
      expect(profile.attributes, equals(<String, String>{'attr1': 'value1'}));
      expect(profile.metaData, equals(<String, String>{'key': 'value'}));
      expect(profile.stops, equals(stops));
    });

    group('fromJson', () {
      test('creates instance from complete JSON', () {
        final Map<String, dynamic> json = <String, dynamic>{
          'name': 'Test Profile',
          'description': 'Test Description',
          'attributes': <String, String>{'attr1': 'value1'},
          'metaData': <String, String>{'key': 'value'},
          'stops': <Map<String, dynamic>>[
            <String, dynamic>{
              'name': 'Stop 1',
              'geofenceId': 'geo123',
              'metaData': <String, String>{'key': 'value'},
            }
          ],
        };

        final TripUpdateProfile profile = TripUpdateProfile.fromJson(json);

        expect(profile.name, equals('Test Profile'));
        expect(profile.description, equals('Test Description'));
        expect(profile.attributes, equals(<String, String>{'attr1': 'value1'}));
        expect(profile.metaData, equals(<String, String>{'key': 'value'}));
        expect(profile.stops?.length, equals(1));
        expect(profile.stops?.first.name, equals('Stop 1'));
      });

      test('creates instance with minimal JSON', () {
        final Map<String, dynamic> json = <String, dynamic>{
          'name': 'Test Profile',
        };

        final TripUpdateProfile profile = TripUpdateProfile.fromJson(json);

        expect(profile.name, equals('Test Profile'));
        expect(profile.description, isNull);
        expect(profile.attributes, isNull);
        expect(profile.metaData, isNull);
        expect(profile.stops, isNull);
      });
    });

    test('toJson converts instance to correct JSON format', () {
      final List<TripStop> stops = <TripStop>[
        TripStop(
          name: 'Stop 1',
          geofenceId: 'geo123',
          metaData: <String, String>{'key': 'value'},
        )
      ];

      final TripUpdateProfile profile = TripUpdateProfile(
        name: 'Test Profile',
        description: 'Test Description',
        attributes: <String, String>{'attr1': 'value1'},
        metaData: <String, String>{'key': 'value'},
        stops: stops,
      );

      final Map<String, dynamic> json = profile.toJson();

      expect(json['name'], equals('Test Profile'));
      expect(json['description'], equals('Test Description'));
      expect(json['attributes'], equals(<String, String>{'attr1': 'value1'}));
      expect(json['metaData'], equals(<String, String>{'key': 'value'}));
      expect(json['stops'], isList);
      expect(json['stops']?.first['name'], equals('Stop 1'));
    });
  });
}
