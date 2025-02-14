import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_asset.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_last_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_location.dart';

void main() {
  group('TripAsset', () {
    test('constructor creates instance with required values', () {
      final asset = TripAsset(
        id: 'asset123',
        deviceId: 'device123',
        state: 'active',
        name: 'Test Asset',
        description: 'Test Description',
        createdAt: 1635731234,
      );

      expect(asset.id, equals('asset123'));
      expect(asset.deviceId, equals('device123'));
      expect(asset.state, equals('active'));
      expect(asset.name, equals('Test Asset'));
      expect(asset.description, equals('Test Description'));
      expect(asset.createdAt, equals(1635731234));
      expect(asset.tags, isNull);
      expect(asset.metaData, isNull);
      expect(asset.updatedAt, isNull);
      expect(asset.attributes, isNull);
      expect(asset.latestLocation, isNull);
    });

    test('constructor creates instance with all values', () {
      final latestLocation = LatestLocation(
        location: TripLocation(lat: 1.0, lon: 2.0),
        timestamp: 1635731234,
      );

      final asset = TripAsset(
        id: 'asset123',
        deviceId: 'device123',
        state: 'active',
        name: 'Test Asset',
        description: 'Test Description',
        tags: ['tag1', 'tag2'],
        metaData: {'key': 'value'},
        createdAt: 1635731234,
        updatedAt: 1635731235,
        attributes: {'attr1': 'value1'},
        latestLocation: latestLocation,
      );

      expect(asset.id, equals('asset123'));
      expect(asset.deviceId, equals('device123'));
      expect(asset.state, equals('active'));
      expect(asset.name, equals('Test Asset'));
      expect(asset.description, equals('Test Description'));
      expect(asset.tags, equals(['tag1', 'tag2']));
      expect(asset.metaData, equals({'key': 'value'}));
      expect(asset.createdAt, equals(1635731234));
      expect(asset.updatedAt, equals(1635731235));
      expect(asset.attributes, equals({'attr1': 'value1'}));
      expect(asset.latestLocation, equals(latestLocation));
    });

    group('fromJson', () {
      test('creates instance from complete JSON', () {
        final json = {
          'id': 'asset123',
          'device_id': 'device123',
          'state': 'active',
          'name': 'Test Asset',
          'description': 'Test Description',
          'tags': ['tag1', 'tag2'],
          'meta_data': {'key': 'value'},
          'created_at': 1635731234,
          'updated_at': 1635731235,
          'attributes': {'attr1': 'value1'},
          'latest_location': {
            'location': {
              'lat': 1.0,
              'lon': 2.0,
            },
            'timestamp': 1635731234,
          },
        };

        final asset = TripAsset.fromJson(json);

        expect(asset.id, equals('asset123'));
        expect(asset.deviceId, equals('device123'));
        expect(asset.state, equals('active'));
        expect(asset.name, equals('Test Asset'));
        expect(asset.description, equals('Test Description'));
        expect(asset.tags, equals(['tag1', 'tag2']));
        expect(asset.metaData, equals({'key': 'value'}));
        expect(asset.createdAt, equals(1635731234));
        expect(asset.updatedAt, equals(1635731235));
        expect(asset.attributes, equals({'attr1': 'value1'}));
        expect(asset.latestLocation?.location?.lat, equals(1.0));
        expect(asset.latestLocation?.location?.lon, equals(2.0));
        expect(asset.latestLocation?.timestamp, equals(1635731234));
      });

      test('creates instance from minimal JSON', () {
        final json = {
          'id': 'asset123',
          'device_id': 'device123',
          'state': 'active',
          'name': 'Test Asset',
          'description': 'Test Description',
          'created_at': 1635731234,
        };

        final asset = TripAsset.fromJson(json);

        expect(asset.id, equals('asset123'));
        expect(asset.deviceId, equals('device123'));
        expect(asset.state, equals('active'));
        expect(asset.name, equals('Test Asset'));
        expect(asset.description, equals('Test Description'));
        expect(asset.createdAt, equals(1635731234));
        expect(asset.tags, isNull);
        expect(asset.metaData, isNull);
        expect(asset.updatedAt, isNull);
        expect(asset.attributes, isNull);
        expect(asset.latestLocation, isNull);
      });
    });

    test('toJson converts instance to correct JSON format', () {
      final latestLocation = LatestLocation(
        location: TripLocation(lat: 1.0, lon: 2.0),
        timestamp: 1635731234,
      );

      final asset = TripAsset(
        id: 'asset123',
        deviceId: 'device123',
        state: 'active',
        name: 'Test Asset',
        description: 'Test Description',
        tags: ['tag1', 'tag2'],
        metaData: {'key': 'value'},
        createdAt: 1635731234,
        updatedAt: 1635731235,
        attributes: {'attr1': 'value1'},
        latestLocation: latestLocation,
      );

      final json = asset.toJson();

      expect(
          json,
          equals({
            'id': 'asset123',
            'device_id': 'device123',
            'state': 'active',
            'name': 'Test Asset',
            'description': 'Test Description',
            'tags': ['tag1', 'tag2'],
            'meta_data': {'key': 'value'},
            'created_at': 1635731234,
            'updated_at': 1635731235,
            'attributes': {'attr1': 'value1'},
            'latest_location': latestLocation.toJson(),
          }));
    });
  });
}
