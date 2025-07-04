
## Introduction

The Nextbillion.AI Asset Tracking Flutter plugin is designed to enable developers to integrate location tracking functionality into their Android or iOS applications. It facilitates real-time tracking of assets, allowing data to be uploaded to the Nextbillion.AI backend or a custom database.

## Key Features and Capabilities
* Asset create
* Bind asset
* Location information callback
* Tracking status callback
* Start and stop tracking function
* Asset details retrieve
* Start a trip 
* End a trip 
* Delete a trip
* Trip details retrieve
* Trip updates

## Getting Started
### Prerequisites
Before integrating the SDK into your application, ensure that your development environment meets the following prerequisites:

**Access Key**: To utilize Nextbillion.ai's Flutter Asset Tracking SDK, developers must obtain an access key, which serves as the authentication mechanism for accessing the SDK's features and functionalities.

**Platform Requirements:**
Android: The minimum supported Android SDK version for using the Flutter Asset Tracking SDK is API level 21 (Android 5.0, "Lollipop") or higher.
iOS: The SDK is compatible with iOS 11 or later versions.

**Flutter Compatibility:** The Flutter Asset Tracking SDK requires Flutter version 3.3.0 or higher to ensure seamless integration and optimal performance with the Flutter framework.

**CocoaPods:** For iOS projects, the SDK requires CocoaPods version 1.11.3 or newer to manage dependencies effectively and ensure proper integration with iOS projects.

### Installation
To use this library, add the following dependency to your pubspec.yaml file:
```
dependencies:    
  nb_asset_tracking_flutter: ^<version_number>
```
Replace <version_number> with the desired version of the library.For the latest version, please check out the [Flutter Asset Tracking Plugin]()

### Required Permissions
To ensure the proper functioning of NextBillion.ai's Flutter Asset Tracking SDK, you need to grant location permissions and declare them for both Android and iOS platforms.
#### Android
```
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
  <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
  <uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION"/> 
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

* `ACCESS_COARSE_LOCATION` : Allows the app to access approximate location based on sources like Wi-Fi and cell towers. Accuracy is typically within a few hundred meters.
*  `ACCESS_FINE_LOCATION` : Grants access to precise location using GPS, Wi-Fi, and cellular networks.
Necessary for features requiring high-accuracy location tracking.
*  `ACCESS_BACKGROUND_LOCATION` : Allows the app to access location even when running in the background.
Required if your app needs to track location continuously, even when not in use.
*  `INTERNET` : Grants the app permission to access the internet. Needed for network operations like API calls, fetching data, or uploading information.
*  `FOREGROUND_SERVICE` : Allows the app to run foreground services. Essential for long-running tasks like media playback, ongoing location tracking, or health monitoring.
*  `FOREGROUND_SERVICE_LOCATION` : Specifically for foreground services that use location updates. Required for location-tracking apps running a foreground service.
*  `POST_NOTIFICATIONS` (Android 13+): Allows the app to send push notifications. Required to display alerts, reminders, or updates to the user.

##### Requesting Location Runtime Permissions (Foreground and Background) in Android 6.0 and Above

For Android 6.0 (API 23) and above, you need to dynamically request permissions. Below is how to request location permissions using the `permission_handler` , including foreground and background permissions:
```
import 'package:permission_handler/permission_handler.dart';

Future<void> checkAndRequestLocationPermissions() async {
  // Request foreground location permission
  PermissionStatus status = await Permission.location.request();
  
  if (status.isGranted) {
    // If foreground location permission is granted, further request background location permission
    // This permission is needed for Android 10 and above, if you need to continue updating navigation data when the app goes to the background
    PermissionStatus backgroundStatus = await Permission.locationAlways.request();

    if (!backgroundStatus.isGranted) {
      // If background location permission is denied, notify the user and exit
      print("Background location permission is required.");
      return;
    }
  } else {
    // If foreground location permission is denied, notify the user
    print("Foreground location permission is required.");
    return;
  }
}
```
##### Requesting Notification Runtime Permission in Android 13 and Above
For Android 13 (API 33) and above, you need to dynamically request notification permissions if you want to show notifications while the app is in the background:

```
Future<void> checkAndRequestNotificationPermission() async {
  // Check notification permission status
  PermissionStatus status = await Permission.notification.status;

  if (!status.isGranted) {
    // Request notification permission
    status = await Permission.notification.request();
    if (status.isGranted) {
      print("Notification permission granted.");
    } else {
      print("Notification permission denied.");
    }
  } else {
    print("Notification permission already granted.");
  }
}
```

#### Android Notification Configuration

##### Icon Configuration

When configuring Android notifications, you can specify icons using string names that correspond to drawable resources in your Android project.

##### Usage Example

```dart
var androidNotificationConfig = AndroidNotificationConfig(
  channelId: "my_channel",
  channelName: "My Channel",
  title: "Tracking Started",
  content: "Asset tracking is now active",
  smallIcon: "ic_launcher",     // Uses ic_launcher from drawable resources
  largeIcon: "ic_launcher"      // Uses ic_launcher from drawable resources
);

assetTracking.setAndroidNotificationConfig(config: androidNotificationConfig);
```

##### Icon Requirements

1. **Icon Files**: Place your icon files in the `android/app/src/main/res/drawable/` directory
2. **File Names**: Use the filename without extension (e.g., `ic_launcher` for `ic_launcher.png`)
3. **Resource Types**: Supported formats include PNG, JPG, XML drawables
4. **Default Icons**: If no icon is specified or the icon is not found, the system will use a default icon

#### Custom Icons

To use custom icons:
1. Add your icon file to `android/app/src/main/res/drawable/`
2. Reference it by filename without extension in the configuration

```dart
AndroidNotificationConfig(
  smallIcon: "my_custom_icon",  // References my_custom_icon.png/xml
  largeIcon: "my_custom_icon"
)
```


#### iOS
###### Getting Location Access
The *NSLocationWhenInUseUsageDescription* and *NSLocationAlwaysUsageDescription* keys must be defined in your **Info.plist** file, which is located in the *Runner* folder of your Flutter project. These keys give users a clear and concise explanation of why your app requires access to their location data. This proactive approach promotes transparency and trust among your app's users.
```
<key>NSLocationWhenInUseUsageDescription</key>
<string>[Your explanation here]</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>[Your explanation here]</string>
```

Replace `[Your explanation here]` with a brief but informative description of why your app requires access to the user's location data. This description should clearly communicate the value that users will receive by granting this access.

###### Enabling Background Location Updates

The *UIBackgroundModes* key must be defined to enable location updates even when your app is running in the background. The location value is specified within this key, indicating that your app intends to use background location services. In addition, an audio mode is included to ensure that your app continues to receive location updates while audio services are active.
```
<key>UIBackgroundModes</key>
<array>
<string>location</string>
<string>audio</string>
</array>
```

This setting enables your app to keep accurate location data even when it is not actively in the foreground, resulting in a more seamless user experience for location-based functionalities.

By configuring these elements meticulously within your **Info.plist** file, you ensure that your application complies with privacy regulations, respects user preferences, and provides the best possible experience when utilizing location-based features, both in the foreground and background.

### Usage
#### 1.Import the necessary classes:
`import 'package:nb_asset_tracking_flutter/asset_tracking.dart';`

#### 2.Create an instance of AssetTracking:

`AssetTracking assetTracking = AssetTracking();`

#### 3.Initialize the library with your API key:
`await assetTracking.initialize(apiKey: '<your_api_key>');`

#### 4. Start using the provided methods to manage assets, track locations, and configure notifications.
```
// Create an asset
AssetResult<String> assetResult = await assetTracking.createAsset(profile: assetProfile);
// Bind an asset
AssetResult<String> bindResult = await assetTracking.bindAsset(customId: '<custom_id>');
// Start tracking
await assetTracking.startTracking();
// Get asset details
AssetResult<Map> assetDetails = await assetTracking.getAssetDetail();
// Stop tracking
await assetTracking.stopTracking();
```


### Custom Configurations
#### 1. Default Configuration(Optional)
Create a default configuration object if you want to customize default settings:
```
DefaultConfig defaultConfig = DefaultConfig(); 
await assetTracking.setDefaultConfig(config: defaultConfig);
 ```

#### 2. Android Notification Configuration(Optional)
Customize Android notification settings if needed:
```
AndroidNotificationConfig androidConfig = AndroidNotificationConfig();
await assetTracking.setAndroidNotificationConfig(config: androidConfig);
```
#### 3. iOS Notification Configuration(Optional)
Configure iOS notification settings based on your requirements:
```
IOSNotificationConfig iosConfig = IOSNotificationConfig();
await assetTracking.setIOSNotificationConfig(config: iosConfig);
```

#### 4. Location Configuration(Optional)
Adjust location tracking settings according to your preferences:
```
LocationConfig locationConfig = LocationConfig();
await assetTracking.setLocationConfig(config: locationConfig);
```
#### 5. Data Tracking Configuration(Optional)
Customize data tracking settings if required:
```
DataTrackingConfig dataTrackingConfig = DataTrackingConfig();
await assetTracking.setDataTrackingConfig(config: dataTrackingConfig);
```
#### 6. Start a trip
```
var profile = TripProfile(name: 'test trip', description: description, customId: customId);
await assetTracking.startTrip(profile: profile)
```
#### 7. End a trip
```
await assetTracking.endTrip();
```
#### 8. Get a trip
```
AssetResult result = await AssetTracking().getTrip(tripId: tripId);
```
#### 9. Delete a trip
```
AssetResult result = await AssetTracking().deleteTrip(tripId: tripId);
```

#### 10. Check whether the trip in progress
```
AssetResult result = await assetTracking.isTripInProgress()
```

### Event Listeners
Register listeners to receive updates:
```

class ConcreteTrackingListener implements OnTrackingDataCallBack {
  @override
  void onLocationSuccess(NBLocation location) {
    print('Location update successful: $location');
    // Handle successful location update logic here
  }

  @override
  void onLocationFailure(String message) {
    print('Location update failed: $message');
    // Handle location update failure logic here
  }

  @override
  void onTrackingStart(String assetId) {
    print('Tracking started for asset: $assetId');
    // Handle tracking start logic here
  }

  @override
  void onTrackingStop(String assetId) {
    print('Tracking stopped for asset: $assetId');
    // Handle tracking stop logic here
  }
}

// Create an instance of the concrete listener
ConcreteTrackingListener concreteListener = ConcreteTrackingListener();
  
// Add a listener
assetTracking.addDataListener(concreteListener);

// Remove a listener
assetTracking.removeDataListener(concreteListener);
```

#### License
This library is licensed under the MIT License.

Feel free to customize the README to better fit your documentation style and include additional details as needed.










