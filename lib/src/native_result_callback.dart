import 'package:nb_asset_tracking_flutter/src/trips/trip_state.dart';

import 'nb_location.dart';

class NativeResultCallback {
  NativeResultCallback({
    this.onLocationSuccess,
    this.onLocationFailure,
    this.onTrackingStart,
    this.onTrackingStop,
    this.onTripStatusChanged,
  });
  void Function(NBLocation)? onLocationSuccess;
  void Function(String)? onLocationFailure;
  void Function(String)? onTrackingStart;
  void Function(String)? onTrackingStop;
  void Function(String, TripState)? onTripStatusChanged;
}
