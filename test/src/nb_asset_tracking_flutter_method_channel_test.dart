import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nb_asset_tracking_flutter/src/nb_asset_tracking_flutter_method_channel.dart';
import 'package:nb_asset_tracking_flutter/src/native_result_callback.dart';
import 'package:nb_asset_tracking_flutter/src/nb_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_state.dart';
import 'package:nb_asset_tracking_flutter/src/default_config.dart';
import 'package:nb_asset_tracking_flutter/src/location_config.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_profile.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_update_profile.dart';
import 'package:nb_asset_tracking_flutter/src/data_tracking_config.dart';
import 'package:nb_asset_tracking_flutter/src/android_notification_config.dart';
import 'package:nb_asset_tracking_flutter/src/ios_notification_config.dart';

@GenerateNiceMocks([MockSpec<MethodChannel>()])
import 'nb_asset_tracking_flutter_method_channel_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MethodChannelNbAssetTrackingFlutter platform;
  late MockMethodChannel mockMethodChannel;

  setUp(() {
    mockMethodChannel = MockMethodChannel();
    platform = MethodChannelNbAssetTrackingFlutter();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('nb_asset_tracking_flutter'),
      (MethodCall methodCall) async {
        return mockMethodChannel.invokeMethod(
            methodCall.method, methodCall.arguments);
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('nb_asset_tracking_flutter'), null);
  });

  test('initialize returns expected value', () async {
    const key = 'test_key';
    when(mockMethodChannel.invokeMethod('initialize', key))
        .thenAnswer((_) async => 'success');

    final result = await platform.initialize(key: key);
    expect(result, 'success');
    verify(mockMethodChannel.invokeMethod('initialize', key)).called(1);
  });

  group('callback handling', () {
    late NativeResultCallback mockCallback;

    setUp(() {
      mockCallback = NativeResultCallback();
      platform.setupResultCallBack(mockCallback);
    });

    test('handles onLocationSuccess callback', () async {
      bool callbackCalled = false;
      final location = NBLocation(
        latitude: 1.0,
        longitude: 2.0,
        accuracy: 3.0,
        altitude: 4.0,
        speed: 5.0,
        speedAccuracy: 1.0,
        heading: 90.0,
        provider: 'gps',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      mockCallback.onLocationSuccess = (NBLocation loc) {
        callbackCalled = true;
        expect(loc.latitude, location.latitude);
        expect(loc.longitude, location.longitude);
      };

      final jsonString = jsonEncode({
        'success': true,
        'data': location.toJson(),
        'msg': 'Success',
      });

      platform.handleMethodCall(MethodCall(
        'onLocationSuccess',
        jsonString,
      ));

      expect(callbackCalled, true);
    });

    test('handles onTripStatusChanged callback', () async {
      bool callbackCalled = false;
      const tripId = 'test_trip';
      const tripState = TripState.started;

      mockCallback.onTripStatusChanged = (String id, TripState state) {
        callbackCalled = true;
        expect(id, tripId);
        expect(state, tripState);
      };

      final jsonString = jsonEncode({
        'success': true,
        'data': {
          'tripId': tripId,
          'status': 'STARTED',
        },
        'msg': 'Success',
      });

      platform.handleMethodCall(MethodCall(
        'onTripStatusChanged',
        jsonString,
      ));

      expect(callbackCalled, true);
    });
  });

  group('asset operations', () {
    test('getAssetId returns expected value', () async {
      when(mockMethodChannel.invokeMethod('getAssetId'))
          .thenAnswer((_) async => 'asset123');

      final result = await platform.getAssetId();
      expect(result, 'asset123');
      verify(mockMethodChannel.invokeMethod('getAssetId')).called(1);
    });

    test('getAssetDetail returns expected value', () async {
      when(mockMethodChannel.invokeMethod('getAssetDetail'))
          .thenAnswer((_) async => '{"id": "asset123"}');

      final result = await platform.getAssetDetail();
      expect(result, '{"id": "asset123"}');
      verify(mockMethodChannel.invokeMethod('getAssetDetail')).called(1);
    });
  });

  group('tracking operations', () {
    test('isTracking returns expected value', () async {
      when(mockMethodChannel.invokeMethod('isTracking'))
          .thenAnswer((_) async => 'true');

      final result = await platform.isTracking();
      expect(result, 'true');
      verify(mockMethodChannel.invokeMethod('isTracking')).called(1);
    });

    test('startTracking calls method channel', () async {
      when(mockMethodChannel.invokeMethod('startTracking'))
          .thenAnswer((_) async => null);

      await platform.startTracking();
      verify(mockMethodChannel.invokeMethod('startTracking')).called(1);
    });

    test('stopTracking calls method channel', () async {
      when(mockMethodChannel.invokeMethod('stopTracking'))
          .thenAnswer((_) async => null);

      await platform.stopTracking();
      verify(mockMethodChannel.invokeMethod('stopTracking')).called(1);
    });
  });

  group('configuration operations', () {
    //unimplemented
    test('setDefaultConfig calls method channel', () async {
      final config = DefaultConfig(
        enhanceService: true,
        repeatInterval: 1000,
        workerEnabled: true,
        crashRestartEnabled: true,
        workOnMainThread: false,
      );

      when(mockMethodChannel.invokeMethod('setDefaultConfig', config.toJson()))
          .thenAnswer((_) async => null);

      await platform.setDefaultConfig(config: config);
      verify(mockMethodChannel.invokeMethod(
              'setDefaultConfig', config.toJson()))
          .called(1);
    }, skip: true);

    test('getDefaultConfig returns expected value', () async {
      final mockResponse = jsonEncode({
        'success': true,
        'data': {
          'enhanceService': true,
          'repeatInterval': 1000,
          'workerEnabled': true,
          'crashRestartEnabled': true,
          'workOnMainThread': false,
        },
        'msg': 'Success'
      });

      when(mockMethodChannel.invokeMethod('getDefaultConfig'))
          .thenAnswer((_) async => mockResponse);

      final result = await platform.getDefaultConfig();
      expect(result, mockResponse);
      verify(mockMethodChannel.invokeMethod('getDefaultConfig')).called(1);
    });

    test('setAndroidNotificationConfig calls method channel', () async {
      final config = AndroidNotificationConfig(
        channelId: 'test_channel',
        channelName: 'Test Channel',
        title: 'Test Title',
        content: 'Test Content',
      );

      when(mockMethodChannel.invokeMethod(
              'setAndroidNotificationConfig', config.encode()))
          .thenAnswer((_) async => null);

      await platform.setAndroidNotificationConfig(config: config);
      verify(mockMethodChannel.invokeMethod(
              'setAndroidNotificationConfig', config.encode()))
          .called(1);
    });

    test('setIOSNotificationConfig calls method channel', () async {
      final config = IOSNotificationConfig()
        ..assetEnableNotificationConfig = AssetEnableNotificationConfig(
          identifier: "startTrackingIdentifier",
        )
        ..assetDisableNotificationConfig = AssetDisableNotificationConfig(
          identifier: "stopTrackingIdentifier",
        )
        ..lowBatteryNotificationConfig = LowBatteryStatusNotificationConfig(
          identifier: "lowBatteryIdentifier",
          minBatteryLevel: 10,
        )
        ..showAssetEnableNotification = true
        ..showAssetDisableNotification = true
        ..showLowBatteryNotification = false;

      when(mockMethodChannel.invokeMethod(
              'setIOSNotificationConfig', config.encode()))
          .thenAnswer((_) async => null);

      await platform.setIOSNotificationConfig(config: config);
      verify(mockMethodChannel.invokeMethod(
              'setIOSNotificationConfig', config.encode()))
          .called(1);
    });

    test('getIOSNotificationConfig returns expected value', () async {
      final mockResponse = jsonEncode({
        'success': true,
        'data': {
          'assetEnableNotificationConfig': {
            'identifier': 'startTrackingIdentifier',
            'title': '',
            'content':
                "Asset tracking is now enabled and your device's location will be tracked",
          },
          'assetDisableNotificationConfig': {
            'identifier': 'stopTrackingIdentifier',
            'title': '',
            'content':
                "Asset tracking is now disabled and your device's location will no longer be tracked",
            'assetIDTrackedContent':
                "Asset [assetId] is being tracked on another device. Tracking has been stopped on this device",
          },
          'lowBatteryNotificationConfig': {
            'identifier': 'lowBatteryIdentifier',
            'title': '',
            'content':
                "Your device's battery level is lower than 10. Please recharge to continue tracking assets",
            'minBatteryLevel': 10,
          },
          'showAssetEnableNotification': true,
          'showAssetDisableNotification': true,
          'showLowBatteryNotification': false,
        },
        'msg': 'Success'
      });

      when(mockMethodChannel.invokeMethod('getIOSNotificationConfig'))
          .thenAnswer((_) async => mockResponse);

      final result = await platform.getIOSNotificationConfig();
      expect(result, mockResponse);
      verify(mockMethodChannel.invokeMethod('getIOSNotificationConfig'))
          .called(1);
    });
  });

  group('location configuration', () {
    test('setLocationConfig calls method channel', () async {
      final config = LocationConfig.customConfig(
        intervalForAndroid: 1000,
        smallestDisplacement: 10.0,
        desiredAccuracy: DesiredAccuracy.high,
        maxWaitTimeForAndroid: 2000,
        fastestIntervalForAndroid: 500,
        enableStationaryCheck: true,
      );

      when(mockMethodChannel.invokeMethod('setLocationConfig', config.encode()))
          .thenAnswer((_) async => null);

      await platform.setLocationConfig(config: config);
      verify(mockMethodChannel.invokeMethod(
              'setLocationConfig', config.encode()))
          .called(1);
    });

    test('updateLocationConfig calls method channel', () async {
      final config = LocationConfig(
        trackingMode: TrackingMode.active,
        intervalForAndroid: 1000,
        smallestDisplacement: 10.0,
        desiredAccuracy: DesiredAccuracy.high,
        maxWaitTimeForAndroid: 2000,
        fastestIntervalForAndroid: 500,
        enableStationaryCheck: true,
      );

      when(mockMethodChannel.invokeMethod(
              'updateLocationConfig', config.encode()))
          .thenAnswer((_) async => null);

      await platform.updateLocationConfig(config: config);
      verify(mockMethodChannel.invokeMethod(
              'updateLocationConfig', config.encode()))
          .called(1);
    });

    test('getLocationConfig returns expected value', () async {
      final mockResponse = jsonEncode({
        'success': true,
        'data': {
          'trackingMode': 'active',
          'interval': 1000,
          'smallestDisplacement': 10.0,
          'desiredAccuracy': 'high',
          'maxWaitTime': 2000,
          'fastestInterval': 500,
          'enableStationaryCheck': true,
        },
        'msg': 'Success'
      });

      when(mockMethodChannel.invokeMethod('getLocationConfig'))
          .thenAnswer((_) async => mockResponse);

      final result = await platform.getLocationConfig();
      expect(result, mockResponse);
      verify(mockMethodChannel.invokeMethod('getLocationConfig')).called(1);
    });
  });

  group('trip operations', () {
    test('startTrip calls method channel', () async {
      final profile = TripProfile(
        customId: 'test_trip',
        name: 'Test Trip',
        description: 'Trip description',
        attributes: const {'key': 'value'},
        metaData: const {'meta': 'data'},
        stops: const [],
      );

      when(mockMethodChannel.invokeMethod('startTrip', profile.encode()))
          .thenAnswer((_) async => 'success');

      final result = await platform.startTrip(profile: profile);
      expect(result, 'success');
      verify(mockMethodChannel.invokeMethod('startTrip', profile.encode()))
          .called(1);
    });

    test('updateTrip calls method channel', () async {
      final profile = TripUpdateProfile(
        name: 'Updated Trip',
        description: 'Trip description',
        attributes: {'key': 'value'},
        metaData: {'meta': 'data'},
        stops: [],
      );

      when(mockMethodChannel.invokeMethod('updateTrip', profile.encode()))
          .thenAnswer((_) async => 'success');

      final result = await platform.updateTrip(profile: profile);
      expect(result, 'success');
      verify(mockMethodChannel.invokeMethod('updateTrip', profile.encode()))
          .called(1);
    });

    test('getTrip returns expected value', () async {
      const tripId = 'test_trip';
      when(mockMethodChannel.invokeMethod('getTrip', tripId))
          .thenAnswer((_) async => '{"tripId": "test_trip"}');

      final result = await platform.getTrip(tripId: tripId);
      expect(result, '{"tripId": "test_trip"}');
      verify(mockMethodChannel.invokeMethod('getTrip', tripId)).called(1);
    });

    test('endTrip calls method channel', () async {
      when(mockMethodChannel.invokeMethod('endTrip'))
          .thenAnswer((_) async => 'success');

      final result = await platform.endTrip();
      expect(result, 'success');
      verify(mockMethodChannel.invokeMethod('endTrip')).called(1);
    });
  });

  group('data tracking operations', () {
    test('setDataTrackingConfig calls method channel', () async {
      final config = DataTrackingConfig(
        baseUrl: 'https://test.com',
        dataStorageSize: 1000,
        dataUploadingBatchSize: 100,
        dataUploadingBatchWindow: 60,
        shouldClearLocalDataWhenCollision: true,
      );

      when(mockMethodChannel.invokeMethod(
              'setDataTrackingConfig', config.encode()))
          .thenAnswer((_) async => null);

      await platform.setDataTrackingConfig(config: config);
      verify(mockMethodChannel.invokeMethod(
              'setDataTrackingConfig', config.encode()))
          .called(1);
    });

    test('getDataTrackingConfig returns expected value', () async {
      final mockResponse = jsonEncode({
        'success': true,
        'data': {
          'baseUrl': 'https://test.com',
          'dataStorageSize': 1000,
          'dataUploadingBatchSize': 100,
          'dataUploadingBatchWindow': 60,
          'shouldClearLocalDataWhenCollision': true,
        },
        'msg': 'Success'
      });

      when(mockMethodChannel.invokeMethod('getDataTrackingConfig'))
          .thenAnswer((_) async => mockResponse);

      final result = await platform.getDataTrackingConfig();
      expect(result, mockResponse);
      verify(mockMethodChannel.invokeMethod('getDataTrackingConfig')).called(1);
    });
  });

  group('fake GPS operations', () {
    test('setFakeGpsConfig calls method channel', () async {
      const allow = true;
      when(mockMethodChannel.invokeMethod('setFakeGpsConfig', allow))
          .thenAnswer((_) async => null);

      await platform.setFakeGpsConfig(allow: allow);
      verify(mockMethodChannel.invokeMethod('setFakeGpsConfig', allow))
          .called(1);
    });

    test('getFakeGpsConfig returns expected value', () async {
      when(mockMethodChannel.invokeMethod('getFakeGpsConfig'))
          .thenAnswer((_) async => 'true');

      final result = await platform.getFakeGpsConfig();
      expect(result, 'true');
      verify(mockMethodChannel.invokeMethod('getFakeGpsConfig')).called(1);
    });
  });

  group('user operations', () {
    test('setupUserId calls method channel', () async {
      const userId = 'test_user';
      when(mockMethodChannel.invokeMethod('setupUserId', userId))
          .thenAnswer((_) async => 'success');

      final result = await platform.setupUserId(userId: userId);
      expect(result, 'success');
      verify(mockMethodChannel.invokeMethod('setupUserId', userId)).called(1);
    });
  });
}
