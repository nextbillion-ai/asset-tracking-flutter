import 'package:nb_asset_tracking_flutter/src/trips/trip_asset.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_summary.dart';
import 'package:test/test.dart';

void main() {
  group('TripSummary', () {
    test('constructor creates instance with required values', () {
      final DateTime startedAt = DateTime.now();
      final TripAsset asset = TripAsset(
        id: 'asset123',
        deviceId: 'device123',
        state: 'active',
        name: 'Test Asset',
        description: 'Test Description',
        createdAt: 1635731234,
      );

      final TripSummary summary = TripSummary(
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
        final Map<String, dynamic> json = <String, dynamic>{
          'id': 'trip123',
          'asset_id': 'asset123',
          'state': 'active',
          'name': 'Test Trip',
          'description': 'Test Description',
          'meta_data': <String, String>{'key': 'value'},
          'attributes': <String, String>{'attr1': 'value1'},
          'started_at': 1635731234,
          'ended_at': 1635731235,
          'created_at': 1635731236,
          'updated_at': 1635731237,
          'stops': <Map<String, dynamic>>[
            <String, dynamic>{
              'name': 'Stop 1',
              'geofenceId': 'geo123',
              'metaData': <String, String>{'key': 'value'},
            }
          ],
          'route': <Map<String, dynamic>>[
            <String, dynamic>{
              'accuracy': 10.0,
              'altitude': 100.0,
              'bearing': 45.0,
              'location': <String, double>{'lat': 1.0, 'lon': 2.0},
              'meta_data': <String, String>{'key': 'value'},
              'speed': 60.0,
              'timestamp': 1635731234,
              'battery_level': 80,
              'tracking_mode': 'active',
            }
          ],
          'asset': <String, dynamic>{
            'id': 'asset123',
            'device_id': 'device123',
            'state': 'active',
            'name': 'Test Asset',
            'description': 'Test Description',
            'created_at': 1635731234,
          },
          'geometry': <String>['coord1', 'coord2'],
          'distance': 1000.5,
          'duration': 3600.0,
        };

        final TripSummary summary = TripSummary.fromJson(json);

        expect(summary.id, equals('trip123'));
        expect(summary.assetId, equals('asset123'));
        expect(summary.state, equals('active'));
        expect(summary.name, equals('Test Trip'));
        expect(summary.description, equals('Test Description'));
        expect(summary.metaData, equals(<String, String>{'key': 'value'}));
        expect(summary.attributes, equals(<String, String>{'attr1': 'value1'}));
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
        expect(summary.geometry, equals(<String>['coord1', 'coord2']));
        expect(summary.distance, equals(1000.5));
        expect(summary.duration, equals(3600.0));
      });
    });

    test('toJson converts instance to correct JSON format', () {
      final DateTime startedAt = DateTime.fromMillisecondsSinceEpoch(1635731234 * 1000);
      final TripAsset asset = TripAsset(
        id: 'asset123',
        deviceId: 'device123',
        state: 'active',
        name: 'Test Asset',
        description: 'Test Description',
        createdAt: 1635731234,
      );

      final TripSummary summary = TripSummary(
        id: 'trip123',
        assetId: 'asset123',
        state: 'active',
        name: 'Test Trip',
        description: 'Test Description',
        metaData: <String, String>{'key': 'value'},
        attributes: <String, String>{'attr1': 'value1'},
        startedAt: startedAt,
        asset: asset,
        geometry: <String>['coord1', 'coord2'],
        distance: 1000.5,
        duration: 3600.0,
      );

      final Map<String, dynamic> json = summary.toJson();

      expect(json['id'], equals('trip123'));
      expect(json['asset_id'], equals('asset123'));
      expect(json['state'], equals('active'));
      expect(json['name'], equals('Test Trip'));
      expect(json['description'], equals('Test Description'));
      expect(json['meta_data'], equals(<String, String>{'key': 'value'}));
      expect(json['attributes'], equals(<String, String>{'attr1': 'value1'}));
      expect(json['started_at'], equals(startedAt));
      expect(json['asset'], isNotNull);
      expect(json['geometry'], equals(<String>['coord1', 'coord2']));
      expect(json['distance'], equals(1000.5));
      expect(json['duration'], equals(3600.0));
    });
  });
}
