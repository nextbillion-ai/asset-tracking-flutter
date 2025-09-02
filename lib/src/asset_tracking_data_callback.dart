import '../nb_asset_tracking_flutter.dart';

/// Abstract callback interface for receiving real-time asset tracking events
///
/// This interface defines callback methods that will be invoked by the asset
/// tracking system to notify implementers about various tracking events including:
/// - Location updates (successful acquisitions and failures)
/// - Tracking lifecycle events (start/stop)
/// - Trip status changes (start/end/update/delete)
///
/// To receive tracking callbacks, implement this interface and register your
/// instance using `AssetTracking.addDataListener()`.
///
/// ## Usage Example:
/// ```dart
/// class MyTrackingListener implements OnTrackingDataCallBack {
///   @override
///   void onLocationSuccess(NBLocation location) {
///     print('New location: ${location.latitude}, ${location.longitude}');
///   }
///
///   @override
///   void onLocationFailure(String message) {
///     print('Location error: $message');
///   }
///
///   // ... implement other methods
/// }
///
/// final listener = MyTrackingListener();
/// AssetTracking().addDataListener(listener);
/// ```
///
/// Remember to call `AssetTracking.removeDataListener()` when you no longer
/// need to receive callbacks to prevent memory leaks.
abstract class OnTrackingDataCallBack {
  /// Called when a new location is successfully obtained
  ///
  /// This method is invoked whenever the asset tracking system successfully
  /// acquires a new location update from the device's location services.
  /// The callback provides detailed location information including coordinates,
  /// accuracy, speed, and other relevant data.
  ///
  /// This callback is only triggered when asset tracking is active.
  ///
  /// **Parameters:**
  /// - [location]: The location data containing:
  ///   - `latitude` and `longitude`: GPS coordinates
  ///   - `accuracy`: Location accuracy in meters
  ///   - `speed`: Current speed in meters per second
  ///   - `heading`: Direction of movement in degrees
  ///   - `altitude`: Elevation above sea level
  ///   - `timestamp`: When the location was recorded
  ///   - `provider`: Location source (GPS, Network, etc.)
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onLocationSuccess(NBLocation location) {
  ///   print('Location: ${location.latitude}, ${location.longitude}');
  ///   print('Accuracy: ${location.accuracy}m, Speed: ${location.speed}m/s');
  /// }
  /// ```
  void onLocationSuccess(NBLocation location);

  /// Called when location acquisition fails
  ///
  /// This method is invoked when the asset tracking system encounters an error
  /// while attempting to obtain location data. Common failure scenarios include:
  /// - GPS signal unavailable or weak
  /// - Location permissions denied or revoked
  /// - Location services disabled on the device
  /// - Hardware malfunction or timeout
  /// - Network connectivity issues (for network-based location)
  ///
  /// **Parameters:**
  /// - [message]: A descriptive error message explaining the failure reason
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onLocationFailure(String message) {
  ///   print('Location failed: $message');
  ///   // Handle the error, perhaps show a notification to user
  /// }
  /// ```
  void onLocationFailure(String message);

  /// Called when asset tracking starts successfully
  ///
  /// This method is invoked when the asset tracking system begins active
  /// location monitoring. It indicates that the system is now collecting
  /// and transmitting location data according to the configured tracking
  /// parameters.
  ///
  /// After this callback, you can expect to receive `onLocationSuccess`
  /// or `onLocationFailure` callbacks as location updates are processed.
  ///
  /// **Parameters:**
  /// - [message]: A status message providing additional context about the
  ///   tracking start event
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onTrackingStart(String message) {
  ///   print('Tracking started: $message');
  ///   // Update UI to show tracking is active
  /// }
  /// ```
  void onTrackingStart(String message);

  /// Called when asset tracking stops
  ///
  /// This method is invoked when the asset tracking system stops location
  /// monitoring. This can occur due to:
  /// - Manual stop request via `AssetTracking.stopTracking()`
  /// - System-initiated stop due to errors or constraints
  /// - Device Binding Conflict – If the current asset ID is bound to another device, tracking on this device will stop.
  ///
  /// After this callback, no further location updates will be received
  /// until tracking is started again.
  ///
  /// **Parameters:**
  /// - [message]: A status message providing additional context about the
  ///   tracking stop event
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onTrackingStop(String message) {
  ///   print('Tracking stopped: $message');
  ///   // Update UI to show tracking is inactive
  /// }
  /// ```
  void onTrackingStop(String message);

  /// Called when trip status changes
  ///
  /// This method is invoked whenever there are changes to trip status within
  /// the asset tracking system. Trips represent structured journeys with
  /// defined start and end points, and this callback notifies about all
  /// trip lifecycle events.
  ///
  /// **Trip States:**
  /// - `TripState.started`: A new trip has begun
  /// - `TripState.ended`: An active trip has completed
  /// - `TripState.updated`: Trip details have been modified
  /// - `TripState.deleted`: A trip has been removed/cancelled
  ///
  /// **Parameters:**
  /// - [assetId]: The unique identifier of the asset/trip that changed status
  /// - [state]: The new state of the trip (see TripState enum)
  ///
  /// **Example:**
  /// ```dart
  /// @override
  /// void onTripStatusChanged(String assetId, TripState state) {
  ///   switch (state) {
  ///     case TripState.started:
  ///       print('Trip $assetId started');
  ///       break;
  ///     case TripState.ended:
  ///       print('Trip $assetId completed');
  ///       break;
  ///     case TripState.updated:
  ///       print('Trip $assetId updated');
  ///       break;
  ///     case TripState.deleted:
  ///       print('Trip $assetId deleted');
  ///       break;
  ///   }
  /// }
  /// ```
  void onTripStatusChanged(String assetId, TripState state);
}
