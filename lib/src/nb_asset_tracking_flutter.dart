import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'native_result_callback.dart';
import 'nb_asset_tracking_flutter_platform_interface.dart';

/// A singleton class that manages asset tracking functionality.
///
/// This class provides methods for initializing the tracking system, managing assets,
/// handling trips, and configuring various tracking settings. It implements the observer pattern
/// for tracking data callbacks.
class AssetTracking {
  /// Factory constructor that returns the singleton instance of [AssetTracking].
  factory AssetTracking() => _instance;

  AssetTracking._internal() {
    _platform = NbAssetTrackingFlutterPlatform.instance;
    _initNativeCallbacks();
    _platform.setupResultCallBack(_nativeCallbacks);
  }
  final List<OnTrackingDataCallBack> _listeners = <OnTrackingDataCallBack>[];

  late NativeResultCallback _nativeCallbacks;

  late NbAssetTrackingFlutterPlatform _platform;

  static final AssetTracking _instance = AssetTracking._internal();

  /// Initializes the asset tracking system with the provided API key.
  ///
  /// Returns a [Future<bool>] indicating whether the initialization was successful.
  ///
  /// Parameters:
  ///   - [apiKey]: The API key required for authentication.
  Future<bool> initialize({required String apiKey}) async {
    final String jsonString =
        await NbAssetTrackingFlutterPlatform.instance.initialize(key: apiKey);
    return AssetResult<String>.fromJson(jsonString).success;
  }

  /// Sets the key for the header field in API requests.
  /// This method is used when setting a dynamic token.
  /// After calling this method to set the key, the API key will be set as a value in the request header.
  /// Normally, you don't need to call this method unless there is a need to set a dynamic API key.
  ///
  /// Returns a [Future<bool>] indicating whether the operation was successful.
  ///
  /// Parameters:
  ///   - [key]: The key to be set in the header field.
  ///
  Future<bool> setKeyOfHeaderField({required String key}) async {
    final String jsonString = await NbAssetTrackingFlutterPlatform.instance
        .setKeyOfHeaderField(key: key);
    return AssetResult<String>.fromJson(jsonString).success;
  }

  /// Adds a listener for tracking data callbacks.
  ///
  /// Parameters:
  ///   - [callback]: The callback implementation to be added.
  void addDataListener(OnTrackingDataCallBack callback) {
    _listeners.add(callback);
  }

  /// Removes a specific tracking data callback listener.
  ///
  /// Parameters:
  ///   - [callback]: The callback implementation to be removed.
  void removeDataListener(OnTrackingDataCallBack callback) {
    _listeners.remove(callback);
  }

  /// Removes all tracking data callback listeners.
  void removeAllDataListener() {
    _listeners.clear();
  }

  /// Starts the asset tracking process.
  Future<void> startTracking() async {
    await NbAssetTrackingFlutterPlatform.instance.startTracking();
  }

  /// Stops the asset tracking process.
  Future<void> stopTracking() async {
    await _platform.stopTracking();
  }

  /// Retrieves the current asset ID.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the asset ID.
  Future<AssetResult<String>> getAssetId() async {
    final String jsonString = await _platform.getAssetId();
    return AssetResult<String>.fromJson(jsonString);
  }

  /// Updates the asset profile with new information.
  ///
  /// Parameters:
  ///   - [assetProfile]: The updated asset profile information.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the result of the update operation.
  Future<AssetResult<String>> updateAsset(
      {required AssetProfile assetProfile}) async {
    final String jsonString =
        await _platform.updateAsset(assetProfile: assetProfile);
    return AssetResult<String>.fromJson(jsonString);
  }

  /// Retrieves detailed information about the current asset.
  ///
  /// This method is only available on Android platform.
  /// On iOS, this method will throw an [UnimplementedError].
  /// Returns a [Future<AssetResult<AssetDetailInfo>>] containing the asset details.
  Future<AssetResult<AssetDetailInfo>> getAssetDetail() async {
    final String jsonString = await _platform.getAssetDetail();
    return AssetResult<AssetDetailInfo>.fromJson(jsonString);
  }

  /// Sets the default configuration for the tracking system.
  ///
  /// **Note:** This method is only available on Android platform.
  /// On iOS, this method will throw an [UnimplementedError].
  ///
  /// Parameters:
  ///   - [config]: The default configuration to be applied.
  /// This method is only available on Android platform.
  /// On iOS, this method will throw an [UnimplementedError].
  Future<void> setDefaultConfig({required DefaultConfig config}) async {
    await NbAssetTrackingFlutterPlatform.instance
        .setDefaultConfig(config: config);
  }

  /// Retrieves the current default configuration.
  ///
  /// **Note:** This method is only available on Android platform.
  /// On iOS, this method will throw an [UnimplementedError].
  ///
  /// Returns a [Future<AssetResult<DefaultConfig>>] containing the default configuration.
  Future<AssetResult<DefaultConfig>> getDefaultConfig() async {
    final String jsonString = await _platform.getDefaultConfig();
    return AssetResult<DefaultConfig>.fromJson(jsonString);
  }

  /// Sets the Android notification configuration.
  ///
  /// Parameters:
  ///   - [config]: The Android notification configuration to be applied.
  Future<void> setAndroidNotificationConfig(
      {required AndroidNotificationConfig config}) async {
    await _platform.setAndroidNotificationConfig(config: config);
  }

  /// Retrieves the current Android notification configuration.
  ///
  /// Returns a [Future<AssetResult<AndroidNotificationConfig>>] containing the configuration.
  Future<AssetResult<AndroidNotificationConfig>>
      getAndroidNotificationConfig() async {
    final String json = await _platform.getAndroidNotificationConfig();
    return AssetResult<AndroidNotificationConfig>.fromJson(json);
  }

  /// Sets the iOS notification configuration.
  ///
  /// Parameters:
  ///   - [config]: The iOS notification configuration to be applied.
  Future<void> setIOSNotificationConfig(
      {required IOSNotificationConfig config}) async {
    await _platform.setIOSNotificationConfig(config: config);
  }

  /// Retrieves the current iOS notification configuration.
  ///
  /// Returns a [Future<AssetResult<IOSNotificationConfig>>] containing the configuration.
  Future<AssetResult<IOSNotificationConfig>> getIOSNotificationConfig() async {
    final String json = await _platform.getIOSNotificationConfig();
    return AssetResult<IOSNotificationConfig>.fromJson(json);
  }

  /// Updates the location tracking configuration.
  ///
  /// Parameters:
  ///   - [config]: The location configuration to be updated.
  Future<void> updateLocationConfig({required LocationConfig config}) async {
    await _platform.updateLocationConfig(config: config);
  }

  /// Sets the location tracking configuration.
  ///
  /// Parameters:
  ///   - [config]: The location configuration to be applied.
  Future<void> setLocationConfig({required LocationConfig config}) async {
    await _platform.setLocationConfig(config: config);
  }

  /// Retrieves the current location configuration.
  ///
  /// Returns a [Future<AssetResult<LocationConfig>>] containing the configuration.
  Future<AssetResult<LocationConfig>> getLocationConfig() async {
    final String json = await _platform.getLocationConfig();
    return AssetResult<LocationConfig>.fromJson(json);
  }

  /// Sets the data tracking configuration.
  ///
  /// Parameters:
  ///   - [config]: The data tracking configuration to be applied.
  Future<void> setDataTrackingConfig(
      {required DataTrackingConfig config}) async {
    await _platform.setDataTrackingConfig(config: config);
  }

  /// Retrieves the current fake GPS configuration status.
  ///
  /// Returns a [Future<AssetResult<bool>>] indicating if fake GPS is allowed.
  Future<AssetResult<bool>> getFakeGpsConfig() async {
    final String jsonString = await _platform.getFakeGpsConfig();
    return AssetResult<bool>.fromJson(jsonString);
  }

  /// Sets whether fake GPS is allowed.
  ///
  /// Parameters:
  ///   - [allow]: Boolean indicating if fake GPS should be allowed.
  Future<void> setFakeGpsConfig({required bool allow}) async {
    await _platform.setFakeGpsConfig(allow: allow);
  }

  /// Retrieves the current data tracking configuration.
  ///
  /// Returns a [Future<AssetResult<DataTrackingConfig>>] containing the configuration.
  Future<AssetResult<DataTrackingConfig>> getDataTrackingConfig() async {
    final String jsonString = await _platform.getDataTrackingConfig();
    return AssetResult<DataTrackingConfig>.fromJson(jsonString);
  }

  /// Checks if tracking is currently active.
  ///
  /// Returns a [Future<AssetResult<bool>>] indicating the tracking status.
  Future<AssetResult<bool>> isTracking() async {
    final String jsonString = await _platform.isTracking();
    return AssetResult<bool>.fromJson(jsonString);
  }

  /// Creates a new asset with the provided profile.
  ///
  /// Parameters:
  ///   - [profile]: The asset profile for the new asset.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the result of the creation.
  Future<AssetResult<String>> createAsset(
      {required AssetProfile profile}) async {
    final String jsonString = await _platform.createAsset(profile: profile);
    return AssetResult<String>.fromJson(jsonString);
  }

  /// Binds an asset using a custom ID.
  ///
  /// Parameters:
  ///   - [customId]: The custom ID to bind the asset to.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the result of the binding.
  Future<AssetResult<String>> bindAsset({required String customId}) async {
    final String jsonString = await _platform.bindAsset(customId: customId);
    return AssetResult<String>.fromJson(jsonString);
  }

  /// Forces the binding of an asset using a custom ID.
  ///
  /// Parameters:
  ///   - [customId]: The custom ID to force bind the asset to.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the result of the force binding.
  Future<AssetResult<String>> forceBindAsset({required String customId}) async {
    final String jsonString =
        await _platform.forceBindAsset(customId: customId);
    return AssetResult<String>.fromJson(jsonString);
  }

  /// Starts a new trip with the provided profile.
  ///
  /// Parameters:
  ///   - [profile]: The trip profile for the new trip.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the result of starting the trip.
  Future<AssetResult<String>> startTrip({required TripProfile profile}) async {
    final String jsonString = await _platform.startTrip(profile: profile);
    return AssetResult<String>.fromJson(jsonString);
  }

  /// Ends the current trip.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the result of ending the trip.
  Future<AssetResult<String>> endTrip() async {
    final String jsonString = await _platform.endTrip();
    return AssetResult<String>.fromJson(jsonString);
  }

  /// Retrieves information about a specific trip.
  ///
  /// Parameters:
  ///   - [tripId]: The ID of the trip to retrieve information for.
  ///
  /// Returns a [Future<AssetResult<TripInfo>>] containing the trip information.
  Future<AssetResult<TripInfo>> getTrip({required String tripId}) async {
    final String jsonString = await _platform.getTrip(tripId: tripId);
    return AssetResult<TripInfo>.fromJson(jsonString);
  }

  /// Updates an existing trip with new information.
  ///
  /// Parameters:
  ///   - [profile]: The updated trip profile information.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the result of the update.
  Future<AssetResult<String>> updateTrip(
      {required TripUpdateProfile profile}) async {
    final String jsonString = await _platform.updateTrip(profile: profile);
    return AssetResult<String>.fromJson(jsonString);
  }

  /// Retrieves the summary of a specific trip.
  ///
  /// Parameters:
  ///   - [tripId]: The ID of the trip to retrieve the summary for.
  ///
  /// Returns a [Future<AssetResult<TripSummary>>] containing the trip summary.
  Future<AssetResult<TripSummary>> getSummary({required String tripId}) async {
    final String jsonString = await _platform.getSummary(tripId: tripId);
    return AssetResult<TripSummary>.fromJson(jsonString);
  }

  /// Deletes a specific trip.
  ///
  /// Parameters:
  ///   - [tripId]: The ID of the trip to delete.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the result of the deletion.
  Future<AssetResult<String>> deleteTrip({required String tripId}) async {
    final String jsonString = await _platform.deleteTrip(tripId: tripId);
    return AssetResult<String>.fromJson(jsonString);
  }

  /// Retrieves the ID of the currently active trip.
  ///
  /// Returns a [Future<AssetResult<String?>>] containing the active trip ID, if any.
  Future<AssetResult<String?>> getActiveTripId() async {
    final String jsonString = await _platform.getActiveTripId();
    return AssetResult<String?>.fromJson(jsonString);
  }

  /// Checks if there is a trip currently in progress.
  ///
  /// Returns a [Future<AssetResult<bool>>] indicating if a trip is in progress.
  Future<AssetResult<bool>> isTripInProgress() async {
    final String jsonString = await _platform.isTripInProgress();
    return AssetResult<bool>.fromJson(jsonString);
  }

  /// Sets up the user ID for tracking.
  ///
  /// Parameters:
  ///   - [userId]: The user ID to be set up.
  ///
  /// Returns a [Future<AssetResult<String>>] containing the result of the setup.
  Future<AssetResult<String>> setupUserId({required String userId}) async {
    final String jsonString = await _platform.setupUserId(userId: userId);
    return AssetResult<String>.fromJson(jsonString);
  }

  Future<AssetResult<String>> getUserId() async {
    final String jsonString = await _platform.getUserId();
    return AssetResult<String>.fromJson(jsonString);
  }


  /// Initializes the native callbacks for tracking events.
  ///
  /// This method sets up the callback handlers for location updates,
  /// tracking status changes, and trip status changes.
  void _initNativeCallbacks() {
    _nativeCallbacks = NativeResultCallback(
      onLocationSuccess: (NBLocation location) {
        for (final OnTrackingDataCallBack listener in _listeners) {
          listener.onLocationSuccess.call(location);
        }
      },
      onLocationFailure: (String message) {
        for (final OnTrackingDataCallBack listener in _listeners) {
          listener.onLocationFailure.call(message);
        }
      },
      onTrackingStart: (String assetId) {
        for (final OnTrackingDataCallBack listener in _listeners) {
          listener.onTrackingStart.call(assetId);
        }
      },
      onTrackingStop: (String assetId) {
        for (final OnTrackingDataCallBack listener in _listeners) {
          listener.onTrackingStop.call(assetId);
        }
      },
      onTripStatusChanged: (String tripId, TripState state) {
        for (final OnTrackingDataCallBack listener in _listeners) {
          listener.onTripStatusChanged.call(tripId, state);
        }
      },
    );
  }
}
