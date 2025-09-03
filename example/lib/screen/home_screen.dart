import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nb_asset_tracking_flutter/nb_asset_tracking_flutter.dart';
import 'package:nb_asset_tracking_flutter_example/screen/trip_history_screen.dart';
import 'package:nb_asset_tracking_flutter_example/screen/trip_storege.dart';
import 'package:nb_asset_tracking_flutter_example/util/permiss_checker.dart';
import 'package:nb_asset_tracking_flutter_example/util/toast_mixin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../util/consts.dart';
import 'asset_detail_screen.dart';
import 'create_asset.dart';
import 'create_trip_screen.dart';
import 'current_trip_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyAppState();
}

/// Home screen state class that manages asset tracking functionality
///
/// This class implements [OnTrackingDataCallBack] to receive real-time updates
/// about tracking status, location data, and trip events from the asset tracking system.
class _MyAppState extends State<HomeScreen>
    with ToastMixin
    implements OnTrackingDataCallBack {
  // Tracking state
  bool _isRunning = false;
  bool _isTripRunning = false;
  String? _currentTripID;

  // Configuration state
  bool isAllowMockLocation = false;
  TrackingMode selectedOption = TrackingMode.active;
  CustomIntervalMode selectedIntervalMode = CustomIntervalMode.distanceBased;

  // Notification state
  bool enableTrackingStartedNotification = true;
  bool enableTrackingStopNotification = true;

  // Display state
  String trackingStatus = 'Tracking Status: ';
  String locationInfo = '';

  // Dependencies
  final AssetTracking assetTracking = AssetTracking();
  late SharedPreferences sharedPreferences;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initializes the application state and tracking system
  ///
  /// Sets up asset tracking, registers callback listeners, and loads
  /// saved preferences. Also attempts to bind existing asset if available.
  Future<void> _initializeApp() async {
    await initAssetTracking();
    _setupStatusListeners();
    _setupTripListeners();
    // Register this class as a callback listener for tracking events
    assetTracking.addDataListener(this);
    await initSharedPreferences();
    // Check if there have existing asset that can be bound
    await bindExistAssetId();
  }

  void _setupStatusListeners() {
    assetTracking.isTracking().asStream().listen((AssetResult<bool> result) {
      _isRunning = result.data ?? false;
      updateTrackingStatus(isRunning: _isRunning, isTripInProgress: _isTripRunning);
      if (kDebugMode) {
        print('_isRunning : ${result.data}');
      }
    });
  }

  void _setupTripListeners() {
    // Gets the current trip status. Unlike a typical stream, this only triggers once.
    assetTracking.isTripInProgress().asStream().listen((AssetResult<bool> result) {
      _isTripRunning = result.data ?? false;
      updateTrackingStatus(isRunning: _isRunning, isTripInProgress: _isTripRunning);
    });
    // Gets the current trip id. Unlike a typical stream, this only triggers once.
    assetTracking.getActiveTripId().then((AssetResult<String?> result) {
      _currentTripID = result.data;
    });
  }

  Future<void> initAssetTracking() async {
    // Initialize the asset tracking and setup the access key here
    await AssetTracking().initialize(apiKey: accessKey);
    await checkAndRequestPermission();
  }

  Future<void> checkAndRequestPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (status.isGranted) {
      final PermissionStatus always = await Permission.locationAlways.status;
      if (always.isGranted) {
        return;
      } else {
        await Permission.locationAlways.request();
      }
    } else if (status.isDenied) {
      status = await Permission.location.request();
      final PermissionStatus always = await Permission.locationAlways.status;
      if (always.isGranted) {
        return;
      } else {
        await Permission.locationAlways.request();
      }
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    await _initializeFakeGpsConfig();
    await _initializeTrackingMode();
  }

  Future<void> _initializeFakeGpsConfig() async {
    final AssetResult<bool> result = await assetTracking.getFakeGpsConfig();
    final bool allow = sharedPreferences.getBool(keyOfFakeGpsFlag) ?? result.data ?? false;

    await assetTracking.setFakeGpsConfig(allow: allow);
    setState(() => isAllowMockLocation = allow);
  }

  Future<void> _initializeTrackingMode() async {
    final String trackingMode = sharedPreferences.getString(keyOfTrackingMode)
        ?? TrackingMode.active.name;
    final TrackingMode mode = TrackingMode.fromString(trackingMode);

    await assetTracking.setLocationConfig(config: LocationConfig.config(mode));
    setState(() => selectedOption = mode);
  }

  Future<void> bindExistAssetId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? boundId = prefs.getString(keyOfBoundId);

    if (boundId == null) {
      return;
    }

    final AssetResult<String> result = await assetTracking.bindAsset(customId: boundId);
    if (!result.success) {
      showToast('bind asset failed: ${result.msg}');
      return;
    } else {
      showToast('Bind asset successfully with id: ${result.data}');
    }
  }

  /// Cleans up resources when the widget is disposed
  ///
  /// Removes this instance as a data listener from the asset tracking system
  /// to prevent memory leaks and callback invocations after widget disposal.
  @override
  void dispose() {
    assetTracking.removeDataListener(this);
    super.dispose();
  }

  /// Updates the tracking and trip status display
  ///
  /// This method is called by various tracking callbacks to update the UI
  /// with current tracking and trip status. It also clears location info
  /// when tracking stops.
  ///
  /// [isRunning] Whether asset tracking is currently active
  /// [isTripInProgress] Whether a trip is currently in progress
  void updateTrackingStatus({required bool isRunning, required bool isTripInProgress}) {
    setState(() {
      _isRunning = isRunning;
      final String status = isRunning ? 'ON' : 'OFF';
      final String tripStatus = isTripInProgress ? 'ON' : 'OFF';
      trackingStatus = 'Tracking Status: $status \n Trip Status: $tripStatus';
      if (!isRunning) {
        locationInfo = '';
      }
    });
  }

  Future<void> startTracking() async {
    // Check if location services are enabled
    if (!await _checkLocationServiceEnabled()) {
      return;
    }

    // Check permissions first
    if (!await _checkLocationPermissions()) {
      return;
    }

    // Check and bind asset
    if (!await _checkAndBindAsset()) {
      return;
    }

    // Configure and start tracking
    configNotificationConfig();
    if (locationConfigAvailable()) {
      await assetTracking.startTracking();
    }
  }

  /// Checks if location services are enabled on the device
  ///
  /// This method verifies that the device's location services are turned on
  /// before attempting to start tracking. If location services are disabled,
  /// it shows an appropriate message to guide the user.
  ///
  /// Returns `true` if location services are enabled, `false` otherwise.
  Future<bool> _checkLocationServiceEnabled() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return false;
      }

      return true;
    } on Exception catch (e) {
      showToast('Error checking location service status: $e');
      return false;
    }
  }

  /// Shows a dialog prompting user to enable location services
  ///
  /// Displays a user-friendly dialog explaining why location services
  /// are needed and provides guidance on how to enable them.
  void _showLocationServiceDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text(
          'Location services are currently disabled on your device. '
          'To start tracking, please enable location services in your device settings.\n\n'
          'Steps:\n'
          '1. Go to Settings\n'
          '2. Find Privacy & Security (iOS) or Location (Android)\n'
          '3. Turn on Location Services\n'
          '4. Return to this app and try again',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              // Try to open location settings
              await Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<bool> _checkLocationPermissions() async {
    if (Platform.isAndroid) {
      final bool granted = await checkAndRequestLocationPermission();
      if (!granted) {
        showToast('Please granted location access for this app');
        return false;
      }
    }
    return true;
  }

  Future<bool> _checkAndBindAsset() async {
    final String? boundId = sharedPreferences.getString(keyOfBoundId);

    if (boundId == null) {
      showToast('You must bind an asset Id first');
      return false;
    }

    final AssetResult<String> result = await assetTracking.bindAsset(customId: boundId);
    if (!result.success) {
      showToast('Bind asset failed: ${result.msg}');
      return false;
    }

    return true;
  }

  Future<void> startTrip() async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CreateTripScreen(
          onTripCreated: () {
            showToast('Trip started successfully');
          },
        ),
      ),
    );
  }

  Future<void> endTrip() async {
    await assetTracking.endTrip();
  }

  void configNotificationConfig() {
    if (Platform.isIOS) {
      final IOSNotificationConfig iosNotificationConfig = IOSNotificationConfig()
      ..showAssetEnableNotification =
          enableTrackingStartedNotification
      ..showAssetDisableNotification =
          enableTrackingStopNotification;
      assetTracking.setIOSNotificationConfig(config: iosNotificationConfig);
    }
    // else {
    //   var androidNotificationConfig = AndroidNotificationConfig();
    //   androidNotificationConfig.showAssetIdTakenNotification
    //   assetTracking.setAndroidNotificationConfig(config: config);
    // }
  }

  bool locationConfigAvailable() {
    if (selectedOption == TrackingMode.custom) {
      final num? customValue = num.tryParse(textEditingController.text);
      if (customValue == null) {
        showToast(
            "Please enter ${selectedIntervalMode == CustomIntervalMode.distanceBased ? "distance interval" : "time interval"}");
        return false;
      }
      LocationConfig locationConfig = LocationConfig();
      switch (selectedIntervalMode) {
        case CustomIntervalMode.distanceBased:
          locationConfig =
              LocationConfig(smallestDisplacement: customValue.toDouble());
          break;
        case CustomIntervalMode.timeBased:
          locationConfig =
              LocationConfig(intervalForAndroid: customValue.toInt() * 1000);
          break;
      }
      assetTracking.setLocationConfig(config: locationConfig);
    }
    return true;
  }

  void stopTracking() {
    configNotificationConfig();
    assetTracking.stopTracking();
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => const SettingsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Asset Tracking Flutter'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildNotificationConfig(),
              _buildMockLocationSwitch(),
              _buildTrackingModeRadioButtons(),
              _buildCustomTrackingConfig(),
              _buildTrackingButtons(),
              _buildTripButtons(),
              _buildStatusInfo(),
              _buildNavigationButtons(),
              const SizedBox(
                height: 16,
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       // Do something
              //     },
              //     child: const Text('View data uploaded logs'),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );

  bool customOptionAvailable() => !_isRunning && selectedOption == TrackingMode.custom;

  Future<void> pushToCreateAsset() async {
    final AssetResult<bool> trackResult = await assetTracking.isTracking();
    if (trackResult.data ?? false) {
      showToast('Please stop tracking before creating a new asset');
      return;
    }
    _navigateToScreen(const CreateAssetScreen());
  }

  void pushToViewCurrentTrip() {
    if (_currentTripID != null) {
      _navigateToScreen(CurrentTripInfoScreen(tripId: _currentTripID!));
    }
  }

  void pushToTripHistory() {
    _navigateToScreen(const TripHistoryScreen());
  }

  void pushToAssetDetail() {
    _navigateToScreen(const AssetDetailScreen());
  }

  void _navigateToScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => screen),
    );
  }

  // ==========================================
  // OnTrackingDataCallBack Implementation
  // ==========================================

  /// The [OnTrackingDataCallBack] interface provides real-time callbacks for
  /// asset tracking events including:
  /// - Location updates (success/failure)
  /// - Tracking status changes (start/stop)
  /// - Trip status changes (start/end/delete)

  /// Called when location acquisition fails
  ///
  /// This callback is triggered when the asset tracking system encounters
  /// an error while trying to obtain location data (e.g., GPS unavailable,
  /// permission denied, location services disabled).
  ///
  /// [message] Error message describing the location failure
  @override
  void onLocationFailure(String message) {
    _updateLocationInfo('------- Location Info ------- \n$message');
  }

  /// Called when a new location is successfully obtained
  ///
  /// This callback is triggered whenever the asset tracking system successfully
  /// acquires a new location update. The location data is only displayed when
  /// tracking is currently active.
  ///
  /// [location] The location data containing coordinates, accuracy, speed, etc.
  @override
  void onLocationSuccess(NBLocation? location) {
    if (_isRunning) {
      final String locationDetails = '------- Location Info ------- \n'
          'Provider: ${location?.provider}\n'
          'Latitude: ${location?.latitude}\n'
          'Longitude: ${location?.longitude}\n'
          'Altitude: ${location?.altitude}\n'
          'Accuracy: ${location?.accuracy}\n'
          'Speed: ${location?.speed}\n'
          'Bearing: ${location?.heading}\n'
          'Time: ${location?.timestamp}\n';
      _updateLocationInfo(locationDetails);
    }
  }

  /// Helper method to update location information display
  ///
  /// Updates the UI state with new location information received from
  /// tracking callbacks. This triggers a rebuild to show the updated info.
  ///
  /// [info] The location information string to display
  void _updateLocationInfo(String info) {
    setState(() => locationInfo = info);
  }

  /// Called when asset tracking starts
  ///
  /// This callback is triggered when the asset tracking system successfully
  /// starts tracking.
  ///
  /// [message] Status message about the tracking start event
  @override
  void onTrackingStart(String message) {
    _isRunning = true;
    updateTrackingStatus(isRunning: _isRunning, isTripInProgress: _isTripRunning);
    assetTracking.isTripInProgress().then((AssetResult<bool> value) {
      _isTripRunning = value.data ?? false;
      updateTrackingStatus(isRunning: _isRunning, isTripInProgress: _isTripRunning);
    });
  }

  /// Called when asset tracking stops
  ///
  /// This callback is triggered when the asset tracking system stops tracking.
  /// It updates the UI to reflect the stopped state and clears location info.
  ///
  /// [message] Status message about the tracking stop event
  @override
  void onTrackingStop(String message) {
    _isRunning = false;
    updateTrackingStatus(isRunning: _isRunning, isTripInProgress: _isTripRunning);
  }

  // UI Widget builders
  Widget _buildNotificationConfig() {
    if (Platform.isAndroid) {
      return const SizedBox.shrink();
    }
    return Column(
      children: <Widget>[
        _buildNotificationSwitch(
          'Enable Tracking Started Notification',
          enableTrackingStartedNotification,
          (bool value) {
            setState(() => enableTrackingStartedNotification = value);
            sharedPreferences.setBool(keyOfEnableTrackingStartedNotification, value);
          },
        ),
        _buildNotificationSwitch(
          'Enable Tracking Stopped Notification',
          enableTrackingStopNotification,
          (bool value) {
            setState(() => enableTrackingStopNotification = value);
            sharedPreferences.setBool(keyOfEnableTrackingStopNotification, value);
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSwitch(String label, bool value, ValueChanged<bool> onChanged) => Row(
      children: <Widget>[
        Flexible(child: Text(label, style: const TextStyle(fontSize: 16))),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ),
      ],
    );

  Widget _buildMockLocationSwitch() => Row(
      children: <Widget>[
        const Text('Allow mock location', style: TextStyle(fontSize: 16)),
        Transform.scale(
          scale: 0.7,
          child: Switch(
            value: isAllowMockLocation,
            onChanged: (bool value) {
              setState(() => isAllowMockLocation = value);
              assetTracking.setFakeGpsConfig(allow: value);
              sharedPreferences.setBool(keyOfFakeGpsFlag, value);
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          ),
        ),
      ],
    );

  Widget _buildTrackingModeRadioButtons() {
    const List<MapEntry<TrackingMode, String>> trackingModes = <MapEntry<TrackingMode, String>>[
      MapEntry<TrackingMode, String>(TrackingMode.active, 'TRACKING_MODE_ACTIVE'),
      MapEntry<TrackingMode, String>(TrackingMode.balanced, 'TRACKING_MODE_BALANCED'),
      MapEntry<TrackingMode, String>(TrackingMode.passive, 'TRACKING_MODE_PASSIVE'),
      MapEntry<TrackingMode, String>(TrackingMode.custom, 'TRACKING_MODE_CUSTOM'),
    ];

    return Column(
      children: trackingModes
          .map<Widget>((MapEntry<TrackingMode, String> mode) => _buildTrackingModeRadio(mode.key, mode.value))
          .toList(),
    );
  }

  Widget _buildTrackingModeRadio(TrackingMode mode, String title) => SizedBox(
      height: 40,
      child: RadioListTile<TrackingMode>(
        title: Text(title, style: const TextStyle(fontSize: 15)),
        value: mode,
        groupValue: selectedOption,
        onChanged: _isRunning ? null : (TrackingMode? value) => _onTrackingModeChanged(value!, mode),
        contentPadding: EdgeInsets.zero,
      ),
    );

  Widget _buildCustomTrackingConfig() => Padding(
      padding: const EdgeInsets.only(left: 48, top: 15),
      child: Row(
        children: <Widget>[
          if (Platform.isAndroid) _buildIntervalModeDropdown(),
          Expanded(child: _buildIntervalTextField()),
        ],
      ),
    );

  Widget _buildIntervalModeDropdown() => DropdownButton<CustomIntervalMode>(
      value: selectedIntervalMode,
      underline: Container(height: 1, color: Colors.grey),
      items: const <DropdownMenuItem<CustomIntervalMode>>[
        DropdownMenuItem<CustomIntervalMode>(
          value: CustomIntervalMode.distanceBased,
          child: Text('Distance based', style: TextStyle(fontSize: 15)),
        ),
        DropdownMenuItem<CustomIntervalMode>(
          value: CustomIntervalMode.timeBased,
          child: Text('Time based', style: TextStyle(fontSize: 15)),
        ),
      ],
      alignment: AlignmentDirectional.topCenter,
      onChanged: customOptionAvailable()
          ? (CustomIntervalMode? value) => setState(() => selectedIntervalMode = value!)
          : null,
    );

  Widget _buildIntervalTextField() => Container(
      margin: const EdgeInsets.only(left: 8, right: 8),
      height: 38,
      child: TextField(
        enabled: customOptionAvailable(),
        controller: textEditingController,
        maxLines: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: customOptionAvailable() ? Colors.black : Colors.grey.shade400,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          border: const OutlineInputBorder(),
          hintText: selectedIntervalMode == CustomIntervalMode.distanceBased
              ? 'Dist. in meters'
              : 'Time in seconds',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
      ),
    );

  Widget _buildTrackingButtons() => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Expanded(child: _buildButton('START TRACKING', _isRunning ? null : startTracking)),
          const SizedBox(width: 4),
          Expanded(child: _buildButton('STOP TRACKING', _isRunning ? stopTracking : null)),
        ],
      ),
    );

  Widget _buildTripButtons() => Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Expanded(child: _buildButton('START TRIP', _isTripRunning ? null : startTrip)),
          const SizedBox(width: 4),
          Expanded(child: _buildButton('END TRIP', _isTripRunning ? endTrip : null)),
        ],
      ),
    );

  Widget _buildButton(String text, VoidCallback? onPressed) => ElevatedButton(
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );

  Widget _buildStatusInfo() => Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(trackingStatus),
          const SizedBox(height: 16),
          Text(locationInfo),
          const SizedBox(height: 16),
        ],
      ),
    );

  Widget _buildNavigationButtons() => Column(
      children: <Widget>[
        _buildFullWidthButton('Create new Asset', pushToCreateAsset),
        if (_isRunning) ...<Widget>[
          const SizedBox(height: 8),
          _buildFullWidthButton(
            'View Asset Details',
            pushToAssetDetail,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
        _buildFullWidthButton('View Current Trip', pushToViewCurrentTrip),
        _buildFullWidthButton('Trip History', pushToTripHistory),
      ],
    );

  Widget _buildFullWidthButton(String text, VoidCallback onPressed, {ButtonStyle? style}) => SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
          onPressed: onPressed,
          style: style,
          child: Text(text),
        ),
      ),
    );

  // Helper methods
  void _onTrackingModeChanged(TrackingMode value, TrackingMode mode) {
    LocationConfig config;
    switch (mode) {
      case TrackingMode.active:
        config = LocationConfig.activeConfig();
        break;
      case TrackingMode.balanced:
        config = LocationConfig.balancedConfig();
        break;
      case TrackingMode.passive:
        config = LocationConfig.passiveConfig();
        break;
      case TrackingMode.custom:
        config = LocationConfig();
        break;
    }

    assetTracking.updateLocationConfig(config: config);
    setState(() => selectedOption = value);
    sharedPreferences.setString(keyOfTrackingMode, selectedOption.name);
  }

  /// Called when trip status changes
  ///
  /// This callback is triggered when there are changes to trip status such as
  /// trip start, end, or deletion. It manages the current trip state and updates
  /// the UI accordingly.
  ///
  /// [tripId] The unique identifier of the trip that changed status
  /// [state] The new state of the trip (started, ended,updated, or deleted)
  @override
  void onTripStatusChanged(String tripId, TripState state) {
    setState(() {
      switch (state) {
        case TripState.started:
          // Trip has started - store trip ID and update running state
          _currentTripID = tripId;
          _isTripRunning = true;
          break;

        case TripState.ended:
          // Trip has ended - clear trip ID, update state, and store history
          _currentTripID = null;
          _isTripRunning = false;
          storeTripHistory(tripId);
          break;

        case TripState.deleted:
          // Trip was deleted - clear current trip if it matches
          if (_currentTripID == tripId) {
            _currentTripID = null;
            _isTripRunning = false;
          }
          break;
        case TripState.updated:
          break;
      }
      updateTrackingStatus(isRunning: _isRunning, isTripInProgress: _isTripRunning);
    });
  }
}

