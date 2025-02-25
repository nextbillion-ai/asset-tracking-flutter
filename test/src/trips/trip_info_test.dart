import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_info.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_stop.dart';
import 'package:nb_asset_tracking_flutter/src/trips/track_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_location.dart';

void main() {
  group('TripInfo', () {
    test('constructor creates instance with required values', () {
      final startedAt = DateTime.fromMillisecondsSinceEpoch(1635731234 * 1000);
      final createdAt = DateTime.fromMillisecondsSinceEpoch(1635731235 * 1000);

      final tripInfo = TripInfo(
        id: 'trip123',
        assetId: 'asset123',
        state: 'active',
        name: 'Test Trip',
        startedAt: startedAt,
        createdAt: createdAt,
      );

      expect(tripInfo.id, equals('trip123'));
      expect(tripInfo.assetId, equals('asset123'));
      expect(tripInfo.state, equals('active'));
      expect(tripInfo.name, equals('Test Trip'));
      expect(tripInfo.startedAt, equals(startedAt));
      expect(tripInfo.createdAt, equals(createdAt));
      expect(tripInfo.description, isNull);
      expect(tripInfo.metaData, isNull);
      expect(tripInfo.attributes, isNull);
      expect(tripInfo.endedAt, isNull);
      expect(tripInfo.updatedAt, isNull);
      expect(tripInfo.stops, isNull);
      expect(tripInfo.route, isNull);
    });

    group('fromJson', () {
      test('creates instance from complete JSON', () {
        final json = {
          'id': 'trip123',
          'asset_id': 'asset123',
          'state': 'active',
          'name': 'Test Trip',
          'description': 'Test Description',
          'meta_data': {'key': 'value'},
          'attributes': {'attr1': 'value1'},
          'started_at': 1635731234,
          'ended_at': 1635731235,
          'created_at': 1635731236,
          'updated_at': 1635731237,
          'stops': [
            {
              'name': 'Stop 1',
              'geofenceId': 'geo123',
              'metaData': {'key': 'value'},
            }
          ],
          'route': [
            {
              'accuracy': 10.0,
              'altitude': 100.0,
              'bearing': 45.0,
              'location': {'lat': 1.0, 'lon': 2.0},
              'meta_data': {'key': 'value'},
              'speed': 60.0,
              'timestamp': 1635731234,
              'battery_level': 80,
              'tracking_mode': 'active',
            }
          ],
        };

        final tripInfo = TripInfo.fromJson(json);

        expect(tripInfo.id, equals('trip123'));
        expect(tripInfo.assetId, equals('asset123'));
        expect(tripInfo.state, equals('active'));
        expect(tripInfo.name, equals('Test Trip'));
        expect(tripInfo.description, equals('Test Description'));
        expect(tripInfo.metaData, equals({'key': 'value'}));
        expect(tripInfo.attributes, equals({'attr1': 'value1'}));
        expect(tripInfo.startedAt,
            equals(DateTime.fromMillisecondsSinceEpoch(1635731234 * 1000)));
        expect(tripInfo.endedAt,
            equals(DateTime.fromMillisecondsSinceEpoch(1635731235 * 1000)));
        expect(tripInfo.createdAt,
            equals(DateTime.fromMillisecondsSinceEpoch(1635731236 * 1000)));
        expect(tripInfo.updatedAt,
            equals(DateTime.fromMillisecondsSinceEpoch(1635731237 * 1000)));
        expect(tripInfo.stops?.length, equals(1));
        expect(tripInfo.stops?.first.name, equals('Stop 1'));
        expect(tripInfo.stops?.first.geofenceId, equals('geo123'));
        expect(tripInfo.stops?.first.metaData, equals({'key': 'value'}));
        expect(tripInfo.route?.length, equals(1));
        expect(tripInfo.route?.first.location?.lat, equals(1.0));
      });

      test('handles empty or null values correctly', () {
        final json = {
          'id': '',
          'asset_id': '',
          'state': '',
          'name': '',
          'started_at': 1635731234,
          'created_at': 1635731235,
        };

        final tripInfo = TripInfo.fromJson(json);

        expect(tripInfo.id, equals(''));
        expect(tripInfo.assetId, equals(''));
        expect(tripInfo.state, equals(''));
        expect(tripInfo.name, equals(''));
        expect(tripInfo.description, isNull);
        expect(tripInfo.metaData, isNull);
        expect(tripInfo.attributes, isNull);
        expect(tripInfo.endedAt, isNull);
        expect(tripInfo.updatedAt, isNull);
        expect(tripInfo.stops, isNull);
        expect(tripInfo.route, isNull);
      });
    });

    test('toJson converts instance to correct JSON format', () {
      final startedAt = DateTime.fromMillisecondsSinceEpoch(1635731234 * 1000);
      final endedAt = DateTime.fromMillisecondsSinceEpoch(1635731235 * 1000);
      final createdAt = DateTime.fromMillisecondsSinceEpoch(1635731236 * 1000);
      final updatedAt = DateTime.fromMillisecondsSinceEpoch(1635731237 * 1000);

      final tripInfo = TripInfo(
        id: 'trip123',
        assetId: 'asset123',
        state: 'active',
        name: 'Test Trip',
        description: 'Test Description',
        metaData: {'key': 'value'},
        attributes: {'attr1': 'value1'},
        startedAt: startedAt,
        endedAt: endedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
        stops: [
          TripStop(
            name: 'Stop 1',
            geofenceId: 'geo123',
            metaData: {'key': 'value'},
          )
        ],
        route: [
          TrackLocation(
            accuracy: 10.0,
            altitude: 100.0,
            bearing: 45.0,
            location: TripLocation(lat: 1.0, lon: 2.0),
            metaData: {'key': 'value'},
            speed: 60.0,
            timestamp: startedAt,
            batteryLevel: 80,
            trackingMode: 'active',
          )
        ],
      );

      final json = tripInfo.toJson();

      expect(json['id'], equals('trip123'));
      expect(json['asset_id'], equals('asset123'));
      expect(json['state'], equals('active'));
      expect(json['name'], equals('Test Trip'));
      expect(json['description'], equals('Test Description'));
      expect(json['meta_data'], equals({'key': 'value'}));
      expect(json['attributes'], equals({'attr1': 'value1'}));
      expect(json['started_at'], equals(startedAt));
      expect(json['ended_at'], equals(endedAt));
      expect(json['created_at'], equals(createdAt));
      expect(json['updated_at'], equals(updatedAt));
      expect(json['stops'], isList);
      expect(json['route'], isList);
    });
  });
}
