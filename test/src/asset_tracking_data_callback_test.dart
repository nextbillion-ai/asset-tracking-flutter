import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';

class MockTrackingCallback extends Mock implements OnTrackingDataCallBack {}

// Add this class for the fallback value
class FakeNBLocation extends Fake implements NBLocation {}

void main() {
  setUpAll(() {
    // Register fallback values
    registerFallbackValue(FakeNBLocation());
    registerFallbackValue(TripState.started);
  });

  group('OnTrackingDataCallBack', () {
    late MockTrackingCallback callback;

    setUp(() {
      callback = MockTrackingCallback();
    });

    test('onLocationSuccess is called with location data', () {
      final location = NBLocation(
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

      callback.onLocationSuccess(location);
      verify(() => callback.onLocationSuccess(location)).called(1);
    });

    test('onLocationFailure is called with error message', () {
      const errorMessage = 'Location permission denied';

      callback.onLocationFailure(errorMessage);
      verify(() => callback.onLocationFailure(errorMessage)).called(1);
    });

    test('onTrackingStart is called with start message', () {
      const startMessage = 'Tracking started';

      callback.onTrackingStart(startMessage);
      verify(() => callback.onTrackingStart(startMessage)).called(1);
    });

    test('onTrackingStop is called with stop message', () {
      const stopMessage = 'Tracking stopped';

      callback.onTrackingStop(stopMessage);
      verify(() => callback.onTrackingStop(stopMessage)).called(1);
    });

    test('onTripStatusChanged is called with asset id and state', () {
      const assetId = 'asset123';
      const state = TripState.started;

      callback.onTripStatusChanged(assetId, state);
      verify(() => callback.onTripStatusChanged(assetId, state)).called(1);
    });

    test('methods are called in correct order', () {
      const assetId = 'asset123';
      const state = TripState.started;
      const startMessage = 'Tracking started';
      final location = NBLocation(
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

      callback.onTrackingStart(startMessage);
      callback.onTripStatusChanged(assetId, state);
      callback.onLocationSuccess(location);

      verifyInOrder([
        () => callback.onTrackingStart(startMessage),
        () => callback.onTripStatusChanged(assetId, state),
        () => callback.onLocationSuccess(location),
      ]);
    });

    test('no callbacks are triggered initially', () {
      verifyNever(() => callback.onLocationSuccess(any()));
      verifyNever(() => callback.onLocationFailure(any()));
      verifyNever(() => callback.onTrackingStart(any()));
      verifyNever(() => callback.onTrackingStop(any()));
      verifyNever(() => callback.onTripStatusChanged(any(), any()));
    });
  });
}
