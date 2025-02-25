import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_summary.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_stop.dart';
import 'package:nb_asset_tracking_flutter/src/trips/track_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_asset.dart';

void main() {
  group('TripSummary', () {
    test('constructor creates instance with required values', () {
      final startedAt = DateTime.now();
      final asset = TripAsset(
        id: 'asset123',
        deviceId: 'device123',
        state: 'active',
        name: 'Test Asset',
        description: 'Test Description',
        createdAt: 1635731234,
      );

      final summary = TripSummary(
        id: 'trip123',
        assetId: 'asset123',
        state: 'active',
        name: 'Test Trip',
        startedAt: startedAt,
        asset: asset,
      );

      expect(summary.id, equals('trip123'));
      expect(summary.assetId, equals('asset123'));
      expect(summary.state, equals('active'));
      expect(summary.name, equals('Test Trip'));
      expect(summary.startedAt, equals(startedAt));
      expect(summary.asset, equals(asset));
      expect(summary.description, isNull);
      expect(summary.metaData, isNull);
      expect(summary.attributes, isNull);
      expect(summary.endedAt, isNull);
      expect(summary.createdAt, isNull);
      expect(summary.updatedAt, isNull);
      expect(summary.stops, isNull);
      expect(summary.route, isNull);
      expect(summary.geometry, isNull);
      expect(summary.distance, isNull);
      expect(summary.duration, isNull);
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
          'asset': {
            'id': 'asset123',
            'device_id': 'device123',
            'state': 'active',
            'name': 'Test Asset',
            'description': 'Test Description',
            'created_at': 1635731234,
          },
          'geometry': ['coord1', 'coord2'],
          'distance': 1000.5,
          'duration': 3600.0,
        };

        final summary = TripSummary.fromJson(json);

        expect(summary.id, equals('trip123'));
        expect(summary.assetId, equals('asset123'));
        expect(summary.state, equals('active'));
        expect(summary.name, equals('Test Trip'));
        expect(summary.description, equals('Test Description'));
        expect(summary.metaData, equals({'key': 'value'}));
        expect(summary.attributes, equals({'attr1': 'value1'}));
        expect(summary.startedAt,
            equals(DateTime.fromMillisecondsSinceEpoch(1635731234 * 1000)));
        expect(summary.endedAt,
            equals(DateTime.fromMillisecondsSinceEpoch(1635731235 * 1000)));
        expect(summary.createdAt,
            equals(DateTime.fromMillisecondsSinceEpoch(1635731236 * 1000)));
        expect(summary.updatedAt,
            equals(DateTime.fromMillisecondsSinceEpoch(1635731237 * 1000)));
        expect(summary.stops?.length, equals(1));
        expect(summary.route?.length, equals(1));
        expect(summary.asset.id, equals('asset123'));
        expect(summary.geometry, equals(['coord1', 'coord2']));
        expect(summary.distance, equals(1000.5));
        expect(summary.duration, equals(3600.0));
      });
    });

    test('toJson converts instance to correct JSON format', () {
      final startedAt = DateTime.fromMillisecondsSinceEpoch(1635731234 * 1000);
      final asset = TripAsset(
        id: 'asset123',
        deviceId: 'device123',
        state: 'active',
        name: 'Test Asset',
        description: 'Test Description',
        createdAt: 1635731234,
      );

      final summary = TripSummary(
        id: 'trip123',
        assetId: 'asset123',
        state: 'active',
        name: 'Test Trip',
        description: 'Test Description',
        metaData: {'key': 'value'},
        attributes: {'attr1': 'value1'},
        startedAt: startedAt,
        asset: asset,
        geometry: ['coord1', 'coord2'],
        distance: 1000.5,
        duration: 3600.0,
      );

      final json = summary.toJson();

      expect(json['id'], equals('trip123'));
      expect(json['asset_id'], equals('asset123'));
      expect(json['state'], equals('active'));
      expect(json['name'], equals('Test Trip'));
      expect(json['description'], equals('Test Description'));
      expect(json['meta_data'], equals({'key': 'value'}));
      expect(json['attributes'], equals({'attr1': 'value1'}));
      expect(json['started_at'], equals(startedAt));
      expect(json['asset'], isNotNull);
      expect(json['geometry'], equals(['coord1', 'coord2']));
      expect(json['distance'], equals(1000.5));
      expect(json['duration'], equals(3600.0));
    });
  });
}
