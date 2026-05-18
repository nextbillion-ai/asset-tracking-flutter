# nb_asset_tracking_flutter_example

This example app demonstrates how to use `nb_asset_tracking_flutter` for:

- asset creation and binding
- location tracking start/stop
- trip lifecycle (start, update, end, history)
- tracking callbacks and status updates

## Getting Started

### 1) Prerequisites

Before running the example, make sure your local environment has:

- Flutter `>=3.5.0`
- Dart SDK `>=3.5.0 <4.0.0`
- Android Studio (for Android) and/or Xcode + CocoaPods (for iOS)
- A valid NextBillion access key

### 2) Configure your access key

Update the access key placeholder in `lib/util/consts.dart`:

```dart
const String accessKey = 'YOUR_NEXTBILLION_ACCESS_KEY';
```

If this value remains as `opensesame`, initialization may fail for real tracking usage.

### 3) Install dependencies

From the `example` directory:

```bash
flutter pub get
```

### 4) Run the app

```bash
flutter run
```

You can target a specific device if needed:

```bash
flutter run -d <device-id>
```

## First Run Flow (Important)

The example app expects this flow:

1. Open **Create new Asset**.
2. Create an asset and bind it (the bound id is saved locally).
3. Return to home and tap **START TRACKING**.
4. Optionally start/end trips from the trip actions.

If no asset is bound, the app will block tracking and show: `You must bind an asset Id first`.

## Platform Notes

### Android

The required permissions are already declared in `android/app/src/main/AndroidManifest.xml`, including:

- `ACCESS_COARSE_LOCATION`
- `ACCESS_FINE_LOCATION`
- `ACCESS_BACKGROUND_LOCATION`
- `FOREGROUND_SERVICE`
- `FOREGROUND_SERVICE_LOCATION`
- `POST_NOTIFICATIONS`

At runtime, the example requests foreground/background location permissions automatically.

When integrating this plugin into your own app, you must also request runtime location permissions
in app logic (foreground + background where required), not only declare them in `AndroidManifest.xml`.

### iOS

`ios/Runner/Info.plist` already includes:

- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription`
- `UIBackgroundModes` with `location`

When integrating into your own iOS project, also enable **Signing & Capabilities -> Background Modes -> Location updates**
in Xcode for your app target.

If you run into iOS dependency issues, run:

```bash
cd ios && pod install && cd ..
```

## Useful References

- Flutter docs: [https://docs.flutter.dev/](https://docs.flutter.dev/)
- Plugin API and integration guide: see the repository root `README.md`
