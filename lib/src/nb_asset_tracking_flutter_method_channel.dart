import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nb_asset_tracking_flutter/src/data_tracking_config.dart';
import 'package:nb_asset_tracking_flutter/src/default_config.dart';
import 'package:nb_asset_tracking_flutter/src/ios_notification_config.dart';
import 'package:nb_asset_tracking_flutter/src/location_config.dart';
import 'package:nb_asset_tracking_flutter/src/android_notification_config.dart';
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
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('nb_asset_tracking_flutter');

  NativeResultCallback? _resultCallback;

  MethodChannelNbAssetTrackingFlutter() {
    methodChannel.setMethodCallHandler((call) async {
      handleMethodCall(call);
    });
  }

  void handleMethodCall(MethodCall call) {
    if (call.method == 'onLocationSuccess') {
      String jsonString = call.arguments;
      AssetResult<String> result = AssetResult.fromJson(jsonString);
      NBLocation location = NBLocation.fromJson(result.data);
      _resultCallback?.onLocationSuccess?.call(location);

    }else  if (call.method == 'onLocationFailure') {
      String jsonString = call.arguments;
      AssetResult<String> result = AssetResult.fromJson(jsonString);
      _resultCallback?.onLocationFailure?.call(result.data);

    }else  if (call.method == 'onTrackingStart') {
      String jsonString = call.arguments;
      AssetResult<String> result = AssetResult.fromJson(jsonString);
      _resultCallback?.onTrackingStart?.call(result.data);
    }else  if (call.method == 'onTrackingStop') {
      String jsonString = call.arguments;
      AssetResult<String> result = AssetResult.fromJson(jsonString);
      _resultCallback?.onTrackingStop?.call(result.data);

    }else if (call.method == 'onTripStatusChanged') {
      String jsonString = call.arguments;
      AssetResult<Map> result = AssetResult.fromJson(jsonString);
      var tripId = result.data['tripId'];
      TripState state = TripStateExtension.fromString(result.data['status']);
      _resultCallback?.onTripStatusChanged?.call(tripId, state);
    }

  }

  @override
  Future<String> initialize({required String key}) async {
    return await methodChannel.invokeMethod("initialize", key);
  }

  @override
  Future<String> setKeyOfHeaderField({required String key}) async {
    return await methodChannel.invokeMethod("setKeyOfHeaderField", key);
  }

  @override
  void setupResultCallBack(NativeResultCallback callback) {
    _resultCallback = callback;
  }

  @override
  Future<String> getAssetId() async {
    return await methodChannel.invokeMethod("getAssetId");
  }

  @override
  Future<String> updateAsset({required AssetProfile assetProfile}) async {
    return await methodChannel.invokeMethod("updateAsset", assetProfile.encode());
  }

  @override
  Future<String> getAssetDetail() async {
    return await methodChannel.invokeMethod("getAssetDetail");
  }

  @override
  Future<void> setDefaultConfig({required DefaultConfig config}) async {

  }

  @override
  Future<String> getDefaultConfig() async {
   return await methodChannel.invokeMethod("getDefaultConfig");
  }

  @override
  Future<void> setAndroidNotificationConfig(
      {required AndroidNotificationConfig config}) async {
    String encode = config.encode();
    await methodChannel.invokeMethod("setAndroidNotificationConfig", encode);
  }

  @override
  Future<String> getAndroidNotificationConfig() async {
    return  await methodChannel.invokeMethod("getAndroidNotificationConfig");
  }

  @override
  Future<void> setIOSNotificationConfig(
      {required IOSNotificationConfig config}) async {
    await methodChannel.invokeMethod("setIOSNotificationConfig",config.encode());
  }

  @override
  Future<String> getIOSNotificationConfig() async {
    return  await methodChannel.invokeMethod("getIOSNotificationConfig");
  }

  @override
  Future<void> updateLocationConfig(
      {required LocationConfig config}) async {
    await methodChannel.invokeMethod("updateLocationConfig",config.encode());
  }

  @override
  Future<void> setLocationConfig({required LocationConfig config}) async {
    await methodChannel.invokeMethod("setLocationConfig",config.encode());
  }

  @override
  Future<void> setDataTrackingConfig(
      {required DataTrackingConfig config}) async {
    await methodChannel.invokeMethod("setDataTrackingConfig",config.encode());
  }

  @override
  Future<String> getDataTrackingConfig() async {
    return await methodChannel.invokeMethod("getDataTrackingConfig");
  }

  @override
  Future<String> getLocationConfig() async {
    return await methodChannel.invokeMethod("getLocationConfig");
  }

  @override
  Future<void> setFakeGpsConfig({required bool allow}) async {
    return await methodChannel.invokeMethod("setFakeGpsConfig",allow);
  }

  @override
  Future<String> getFakeGpsConfig() async {
    return await methodChannel.invokeMethod("getFakeGpsConfig");
  }

  @override
  Future<String> isTracking() async {
    return await methodChannel.invokeMethod("isTracking");
  }

  @override
  Future<String> createAsset({required AssetProfile profile}) async {
    return await methodChannel.invokeMethod("createAsset", profile.encode());
  }

  @override
  Future<String> bindAsset({String? customId}) async {
    return await methodChannel.invokeMethod("bindAsset",customId);
  }

  @override
  Future<String> forceBindAsset({String? customId}) async {
    return await methodChannel.invokeMethod("forceBindAsset",customId);
  }

  @override
  Future<void> startTracking() async {
    return await methodChannel.invokeMethod("startTracking");
  }

  @override
  Future<void> stopTracking() async {
    return await methodChannel.invokeMethod("stopTracking");
  }

  @override
  Future<String> startTrip({required TripProfile profile}) async {
    return await methodChannel.invokeMethod("startTrip", profile.encode());
  }

  @override
  Future<String> endTrip() async {
    return await methodChannel.invokeMethod("endTrip");
  }

  @override
  Future<String> getTrip({required String tripId}) async {
    return await methodChannel.invokeMethod("getTrip", tripId);
  }

  @override
  Future<String> updateTrip({required TripUpdateProfile profile}) async {
    return await methodChannel.invokeMethod("updateTrip", profile.encode());
  }

  @override
  Future<String> getSummary({required String tripId}) async {
    return await methodChannel.invokeMethod("getSummary", tripId);
  }

  @override
  Future<String> deleteTrip({required String tripId}) async {
    return await methodChannel.invokeMethod("deleteTrip", tripId);
  }

  @override
  Future<String> getActiveTripId() async {
    return await methodChannel.invokeMethod("getActiveTripId");
  }

  @override
  Future<String> isTripInProgress() async {
    return await methodChannel.invokeMethod("isTripInProgress");
  }

  @override
  Future<String> setupUserId({required String userId}) async {
    return await methodChannel.invokeMethod("setupUserId", userId);
  }

}
