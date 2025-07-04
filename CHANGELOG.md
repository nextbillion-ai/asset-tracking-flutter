## 2.1.0
- **BREAKING**: `AndroidNotificationConfig.smallIcon` and `largeIcon` now use `String` type instead of `int`
  - This change improves resource management by allowing drawable resource names instead of hardcoded IDs
  - Added automatic string-to-resource-ID conversion on Android side
## 2.0.3
* Fix [AssetTracking.updateAsset] method not working on Android
## 2.0.2
* README Update
* Fix [AssetTracking.setupUserId] exceptions 
## 2.0.1
* Upgraded Android native frameworks to v2.0.1 to fix the issue of 'android.buildFeatures.buildConfig true' in the app's build.gradle file.
## 2.0.0
* Upgraded Android native frameworks to v2.0.0 with AGP 8+ compatibility.

## 1.2.0
* Updated iOS native frameworks to v1.2.0 to disable Bitcode support, ensuring compatibility with Xcode 16 for upload.

## 1.1.0
* Updated Android native frameworks to v1.1.0 to support the new user-agent format. 
* Updated iOS native frameworks to v1.1.0 to support the new user-agent format. 
* Added AssetTracking.setupUserId method to allow users to customize the user ID. This ID will be automatically included in the user-agent.

## 1.0.6
* Fix the default base url issue in DataTrackingConfig
  
## 1.0.5
* Update Android native framework to 1.0.5 to fix these issue
  * Fix location upload latency issue on Android

## 1.0.4
* Update iOS native framework to 1.0.4 to fix these issue
  * Fix location upload latency issue

## 1.0.3
* Update android native framework to 1.0.4
  * Compatibility with Android 34
## 1.0.1
* Update iOS native framework to 1.0.3 to fix these issue
    * Fix asset id check issue when start trip
## 1.0.0
* Trip implementation
  * 
## 0.2.0
* Update android native framework to 0.3.5 to fix these issue
    * Fix update asset api parameters issue
    * Fix error message of network exception
    * fix android take over asset id issue

## 0.1.0
* Asset create
* Bind asset
* Location information callback
* Start and stop tracking
* Retrieve asset details
