import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nb_asset_tracking_flutter/src/android_notification_config.dart';
import 'package:nb_asset_tracking_flutter/src/data_tracking_config.dart';
import 'package:nb_asset_tracking_flutter/src/default_config.dart';
import 'package:nb_asset_tracking_flutter/src/ios_notification_config.dart';
import 'package:nb_asset_tracking_flutter/src/location_config.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_profile.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_state.dart';
import 'package:nb_asset_tracking_flutter/src/trips/trip_update_profile.dart';

import 'asset_profile.dart';
import 'asset_result.dart';
import 'native_result_callback.dart';
import 'nb_asset_tracking_flutter_platform_interface.dart';
import 'nb_location.dart';

/// An implementation of [NbAssetTrackingFlutterPlatform] that uses method channels.
class MethodChannelNbAssetTrackingFlutter
    extends NbAssetTrackingFlutterPlatform {
  MethodChannelNbAssetTrackingFlutter() {
    methodChannel.setMethodCallHandler((MethodCall call) async {
      handleMethodCall(call);
    });
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final MethodChannel methodChannel =
      const MethodChannel('nb_asset_tracking_flutter');

  NativeResultCallback? _resultCallback;

  void handleMethodCall(MethodCall call) {
    if (call.method == 'onLocationSuccess') {
      final String jsonString = call.arguments;
      final AssetResult<String> result =
          AssetResult<String>.fromJson(jsonString);
      final NBLocation location = NBLocation.fromJson(result.data);
      _resultCallback?.onLocationSuccess?.call(location);
    } else if (call.method == 'onLocationFailure') {
      final String jsonString = call.arguments;
      final AssetResult<String> result =
          AssetResult<String>.fromJson(jsonString);
      _resultCallback?.onLocationFailure?.call(result.data);
    } else if (call.method == 'onTrackingStart') {
      final String jsonString = call.arguments;
      final AssetResult<String> result =
          AssetResult<String>.fromJson(jsonString);
      _resultCallback?.onTrackingStart?.call(result.data);
    } else if (call.method == 'onTrackingStop') {
      final String jsonString = call.arguments;
      final AssetResult<String> result =
          AssetResult<String>.fromJson(jsonString);
      _resultCallback?.onTrackingStop?.call(result.data);
    } else if (call.method == 'onTripStatusChanged') {
      final String jsonString = call.arguments;
      final AssetResult<Map<String, dynamic>> result =
          AssetResult<Map<String, dynamic>>.fromJson(jsonString);
      final String tripId = result.data['tripId'] as String;
      final String status = result.data['status'] as String;
      final TripState state = TripStateExtension.fromString(status);
      _resultCallback?.onTripStatusChanged?.call(tripId, state);
    }
  }

  @override
  Future<String> initialize({required String key}) async =>
      await methodChannel.invokeMethod('initialize', key);

  @override
  Future<String> setKeyOfHeaderField({required String key}) async =>
      await methodChannel.invokeMethod('setKeyOfHeaderField', key);

  @override
  void setupResultCallBack(NativeResultCallback callback) =>
      _resultCallback = callback;

  @override
  Future<String> getAssetId() async =>
      await methodChannel.invokeMethod('getAssetId');

  @override
  Future<String> updateAsset({required AssetProfile assetProfile}) async =>
      await methodChannel.invokeMethod('updateAsset', assetProfile.encode());

  @override
  Future<String> getAssetDetail() async =>
      await methodChannel.invokeMethod('getAssetDetail');

  @override
  Future<void> setDefaultConfig({required DefaultConfig config}) async {
    await methodChannel.invokeMethod('setDefaultConfig', config.encode());
  }

  @override
  Future<String> getDefaultConfig() async =>
      await methodChannel.invokeMethod('getDefaultConfig');

  @override
  Future<void> setAndroidNotificationConfig(
      {required AndroidNotificationConfig config}) async {
    final String encode = config.encode();
    await methodChannel.invokeMethod('setAndroidNotificationConfig', encode);
  }

  @override
  Future<String> getAndroidNotificationConfig() async =>
      await methodChannel.invokeMethod('getAndroidNotificationConfig');

  @override
  Future<void> setIOSNotificationConfig(
          {required IOSNotificationConfig config}) async =>
      methodChannel.invokeMethod('setIOSNotificationConfig', config.encode());

  @override
  Future<String> getIOSNotificationConfig() async =>
      await methodChannel.invokeMethod('getIOSNotificationConfig');

  @override
  Future<void> updateLocationConfig({required LocationConfig config}) async =>
      methodChannel.invokeMethod('updateLocationConfig', config.encode());

  @override
  Future<void> setLocationConfig({required LocationConfig config}) async =>
      methodChannel.invokeMethod('setLocationConfig', config.encode());

  @override
  Future<void> setDataTrackingConfig(
          {required DataTrackingConfig config}) async =>
      methodChannel.invokeMethod('setDataTrackingConfig', config.encode());

  @override
  Future<String> getDataTrackingConfig() async =>
      await methodChannel.invokeMethod('getDataTrackingConfig');

  @override
  Future<String> getLocationConfig() async =>
      await methodChannel.invokeMethod('getLocationConfig');

  @override
  Future<void> setFakeGpsConfig({required bool allow}) async =>
      methodChannel.invokeMethod('setFakeGpsConfig', allow);

  @override
  Future<String> getFakeGpsConfig() async =>
      await methodChannel.invokeMethod('getFakeGpsConfig');

  @override
  Future<String> isTracking() async =>
      await methodChannel.invokeMethod('isTracking');

  @override
  Future<String> createAsset({required AssetProfile profile}) async =>
      await methodChannel.invokeMethod('createAsset', profile.encode());

  @override
  Future<String> bindAsset({String? customId}) async =>
      await methodChannel.invokeMethod('bindAsset', customId);

  @override
  Future<String> forceBindAsset({String? customId}) async =>
      await methodChannel.invokeMethod('forceBindAsset', customId);

  @override
  Future<void> startTracking() async =>
      methodChannel.invokeMethod('startTracking');

  @override
  Future<void> stopTracking() async =>
      methodChannel.invokeMethod('stopTracking');

  @override
  Future<String> startTrip({required TripProfile profile}) async =>
      await methodChannel.invokeMethod('startTrip', profile.encode());

  @override
  Future<String> endTrip() async => await methodChannel.invokeMethod('endTrip');

  @override
  Future<String> getTrip({required String tripId}) async =>
      await methodChannel.invokeMethod('getTrip', tripId);

  @override
  Future<String> updateTrip({required TripUpdateProfile profile}) async =>
      await methodChannel.invokeMethod('updateTrip', profile.encode());

  @override
  Future<String> getSummary({required String tripId}) async =>
      await methodChannel.invokeMethod('getSummary', tripId);

  @override
  Future<String> deleteTrip({required String tripId}) async =>
      await methodChannel.invokeMethod('deleteTrip', tripId);

  @override
  Future<String> getActiveTripId() async =>
      await methodChannel.invokeMethod('getActiveTripId');

  @override
  Future<String> isTripInProgress() async =>
      await methodChannel.invokeMethod('isTripInProgress');

  @override
  Future<String> setupUserId({required String userId}) async =>
      await methodChannel.invokeMethod('setupUserId', userId);

  @override
  Future<String> getUserId() async =>
      await methodChannel.invokeMethod('getUserId');
}
