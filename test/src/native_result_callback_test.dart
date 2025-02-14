import 'package:test/test.dart';
import 'package:nb_asset_tracking_flutter/src/native_result_callback.dart';
import 'package:nb_asset_tracking_flutter/src/nb_location.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_state.dart';

void main() {
  group('NativeResultCallback', () {
    late NBLocation testLocation;

    setUp(() {
      testLocation = NBLocation(
        latitude: 45.0,
        longitude: -122.0,
        accuracy: 10.0,
        altitude: 100.0,
        speed: 5.0,
        speedAccuracy: 1.0,
        heading: 90.0,
        provider: "gps",
        timestamp: 1234567890,
      );
    });

    test('creates instance with null callbacks', () {
      final callback = NativeResultCallback();

      expect(callback.onLocationSuccess, isNull);
      expect(callback.onLocationFailure, isNull);
      expect(callback.onTrackingStart, isNull);
      expect(callback.onTrackingStop, isNull);
      expect(callback.onTripStatusChanged, isNull);
    });

    test('creates instance with provided callbacks', () {
      var locationSuccessCalled = false;
      var locationFailureCalled = false;
      var trackingStartCalled = false;
      var trackingStopCalled = false;
      var tripStatusChangedCalled = false;

      final callback = NativeResultCallback(
        onLocationSuccess: (location) => locationSuccessCalled = true,
        onLocationFailure: (error) => locationFailureCalled = true,
        onTrackingStart: (message) => trackingStartCalled = true,
        onTrackingStop: (message) => trackingStopCalled = true,
        onTripStatusChanged: (assetId, state) => tripStatusChangedCalled = true,
      );

      expect(callback.onLocationSuccess, isNotNull);
      expect(callback.onLocationFailure, isNotNull);
      expect(callback.onTrackingStart, isNotNull);
      expect(callback.onTrackingStop, isNotNull);
      expect(callback.onTripStatusChanged, isNotNull);

      callback.onLocationSuccess?.call(testLocation);
      callback.onLocationFailure?.call('error');
      callback.onTrackingStart?.call('start');
      callback.onTrackingStop?.call('stop');
      callback.onTripStatusChanged?.call('asset123', TripState.started);

      expect(locationSuccessCalled, isTrue);
      expect(locationFailureCalled, isTrue);
      expect(trackingStartCalled, isTrue);
      expect(trackingStopCalled, isTrue);
      expect(tripStatusChangedCalled, isTrue);
    });

    test('callbacks receive correct parameters', () {
      NBLocation? receivedLocation;
      String? receivedError;
      String? receivedStartMessage;
      String? receivedStopMessage;
      String? receivedAssetId;
      TripState? receivedTripState;

      final callback = NativeResultCallback(
        onLocationSuccess: (location) => receivedLocation = location,
        onLocationFailure: (error) => receivedError = error,
        onTrackingStart: (message) => receivedStartMessage = message,
        onTrackingStop: (message) => receivedStopMessage = message,
        onTripStatusChanged: (assetId, state) {
          receivedAssetId = assetId;
          receivedTripState = state;
        },
      );

      callback.onLocationSuccess?.call(testLocation);
      callback.onLocationFailure?.call('Test Error');
      callback.onTrackingStart?.call('Started Tracking');
      callback.onTrackingStop?.call('Stopped Tracking');
      callback.onTripStatusChanged?.call('asset123', TripState.started);

      expect(receivedLocation, equals(testLocation));
      expect(receivedError, equals('Test Error'));
      expect(receivedStartMessage, equals('Started Tracking'));
      expect(receivedStopMessage, equals('Stopped Tracking'));
      expect(receivedAssetId, equals('asset123'));
      expect(receivedTripState, equals(TripState.started));
    });

    test('null callbacks do not throw when called', () {
      final callback = NativeResultCallback();

      expect(() => callback.onLocationSuccess?.call(testLocation),
          returnsNormally);
      expect(() => callback.onLocationFailure?.call('error'), returnsNormally);
      expect(() => callback.onTrackingStart?.call('start'), returnsNormally);
      expect(() => callback.onTrackingStop?.call('stop'), returnsNormally);
      expect(
        () => callback.onTripStatusChanged?.call('asset123', TripState.started),
        returnsNormally,
      );
    });
  });
}
