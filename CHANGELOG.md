# Changelog

## [2.5.0] - 2026-03-25
- Upgrade iOS native SDK to 1.4.0 and upgrade Android native SDK to 2.4.0
- API-SECURITY enhancement Supported,Starting from this version, you can configure security restrictions for Android and iOS apps at [https://console.nextbillion.ai/credentials](Starting from this version, you can configure security restrictions for Android and iOS apps at https://console.nextbillion.ai/credentials.).

## [2.4.1] - 2026-03-12
- Upgrade iOS native SDK to 1.3.2
- Fix tracking stopping after switching to another app (e.g. Google Maps) even with background permission enabled
- Fix intermittent startup failure with `kCLErrorDomain Code: 0`

## [2.4.0] - 2026-03-03

### Changed
- **Android Native SDK**: Upgraded to version 2.3.1 for enhanced system compatibility
- **Kotlin version**: Upgraded from 1.9.25 to 2.2.0 for improved language features and compatibility
- **16 KB page size support**: Added support for 16 KB memory page alignment for newer Android devices and kernel configurations
- **MMKV library**: Pinned MMKV version to 1.3.16 for stable 32-bit and 64-bit architecture support
- **ABI compatibility**: Optimized native library packaging for improved Application Binary Interface (ABI) compatibility across different Android architectures

### Technical Details
- **Kotlin compatibility**: Upgraded Kotlin Gradle Plugin to 2.2.0 to resolve metadata version conflicts
- **Memory alignment**: Ensures compatibility with Android 15+ devices using 16 KB page size
- **Architecture support**: Improved compatibility across ARM64-v8a, ARMv7, x86, and x86_64 architectures
- **Native packaging**: Enhanced native library bundling for better cross-device compatibility
- **MMKV stability**: Locked MMKV dependency to prevent version conflicts in multi-architecture builds

### Deprecated API Fixes
- **Switch widget**: Updated `activeColor` to `thumbColor` with `WidgetStatePropertyAll`
- **Analysis options**: Removed deprecated lint rules (`invariant_booleans`, `prefer_equal_for_default_values`) for Dart 3.0+ compatibility

## [2.3.0] - 2026-01-08

### Changed
- **Android Native SDK**: Upgraded to version 2.3.0 for 16kb alignment
- **Update android minSdkVersion from 21 to 23

## [2.2.2] - 2025-12-10

### Changed
- **iOS Native SDK**: Upgraded to version 1.3.1 for improved location data reliability
- **Android Native SDK**: Upgraded to version 2.2.3 for enhanced data persistence

### Fixed
- **Location data persistence**: Fixed critical issue where location data was lost and not uploaded during prolonged periods without network connectivity
- **Offline data handling**: Improved data buffering and retry mechanism for offline scenarios
- **Data synchronization**: Enhanced location data queue management to prevent data loss during network interruptions
- **Network resilience**: Strengthened location tracking reliability in poor or intermittent network conditions

## [2.2.1] - 2025-10-23
* Remove `org.jlleitschuh.gradle.ktlint` in android plugin

## [2.2.0] - 2025-09-11

### Breaking Changes
- **Java toolchain upgrade**: Upgraded from Java 1.8 to Java 11 for better performance and compatibility (cdec4a5)
- **API rename**: `showAssetIdTakenNotification` → `showAssetDisableNotification` 
  - **Migration Required**: Replace any usage of the old flag with `showAssetDisableNotification`
  - Default value changed to `true`

### Changed
- **Build system**: Upgraded Gradle from 8.2.1 → 8.6 with related Kotlin version upgrades
- **Code quality**: Comprehensive lint rule implementation across all project files
- **Dependencies**: Updated Android and Flutter dependencies for better compatibility

### Fixed
- **TripSummary**: Fixed route parsing issue affecting location data processing
- **NBLocation**: Fixed location parsing issue and null return type error
- **Android build**: Resolved APK build error caused by incorrect Kotlin version configuration (9b83564)
- **Lint issues**: Fixed 857+ Flutter analyze issues across the entire codebase (47bc039)
- **iOS tooling**: Fixed lint check command execution (8e91ac4)
- **Type safety**: Added comprehensive `always_specify_types` annotations
- **Exception handling**: Improved `avoid_catches_without_on_clauses` compliance
- **Build context**: Fixed `use_build_context_synchronously` warnings with proper mounted checks

### Added
- **Location service check**: Enhanced tracking start with location service status validation
- **Comprehensive lint coverage**: Added lint checks for all source code files
- **Code documentation**: Improved inline documentation and comments
- **Better error handling**: Enhanced exception handling with specific exception types

## [2.1.1] - 2025-08-15

### Changed
- **Kotlin version**: Updated from 1.7.20 to 1.8.10 to resolve Flutter compatibility warnings
- **Android Gradle Plugin**: Updated from 7.3.0 to 8.1.0 for better build performance
- **Android SDK**: Updated compileSdkVersion from 33 to 34 for latest Android features
- **Gradle wrapper**: Updated from 8.0 to 8.4 for improved build stability
- **CI/CD**: Updated GitHub workflow Flutter version from 3.19.0 to 3.24.0

### Added
- **Documentation**: Added platform-specific documentation for `setDefaultConfig` and `getDefaultConfig` methods (Android only)

## [2.1.0] - 2024-07-20

### Breaking Changes
- **AndroidNotificationConfig API**: `smallIcon` and `largeIcon` properties now use `String` type instead of `int`
  - **Migration Required**: Update notification configurations to use drawable resource names
  - **Benefit**: Improves resource management by allowing drawable resource names instead of hardcoded IDs
  - **Implementation**: Added automatic string-to-resource-ID conversion on Android side

## [2.0.3] - 2024-06-15

### Fixed
- **Android platform**: Fixed `AssetTracking.updateAsset` method not working on Android devices
- **Asset management**: Resolved asset update API synchronization issues

## [2.0.2] - 2024-05-25

### Changed
- **Documentation**: Updated README with improved setup instructions and examples

### Fixed
- **User ID setup**: Fixed `AssetTracking.setupUserId` method exceptions and error handling
- **API stability**: Improved error handling for user ID configuration

## [2.0.1] - 2024-05-10

### Fixed
- **Android build**: Upgraded Android native frameworks to v2.0.1 to resolve `android.buildFeatures.buildConfig true` requirement
- **Build configuration**: Fixed compatibility issues with app's build.gradle file requirements

## [2.0.0] - 2024-04-30

### Changed
- **Android compatibility**: Upgraded Android native frameworks to v2.0.0 with Android Gradle Plugin 8+ support
- **Build system**: Enhanced compatibility with modern Android build tools

## [1.2.0] - 2024-03-15

### Changed
- **iOS compatibility**: Updated iOS native frameworks to v1.2.0 with Bitcode support disabled
- **Xcode support**: Ensured compatibility with Xcode 16 for app store uploads

## [1.1.0] - 2024-02-10

### Added
- **User ID customization**: Added `AssetTracking.setupUserId` method for custom user ID configuration
- **User-agent enhancement**: User ID automatically included in user-agent for better tracking

### Changed
- **Android native**: Updated Android native frameworks to v1.1.0 with improved user-agent format
- **iOS native**: Updated iOS native frameworks to v1.1.0 with improved user-agent format

## [1.0.6] - 2024-01-20

### Fixed
- **Configuration**: Fixed default base URL issue in `DataTrackingConfig`
- **API endpoints**: Resolved URL configuration problems affecting data uploads

## [1.0.5] - 2024-01-05

### Fixed
- **Android performance**: Updated Android native framework to 1.0.5
- **Location upload**: Fixed location upload latency issue on Android platform
- **Data synchronization**: Improved real-time location data processing

## [1.0.4] - 2023-12-15

### Fixed
- **iOS performance**: Updated iOS native framework to 1.0.4
- **Location upload**: Fixed location upload latency issue on iOS platform
- **Battery optimization**: Improved power consumption during location tracking

## [1.0.3] - 2023-11-30

### Changed
- **Android compatibility**: Updated Android native framework to 1.0.4
- **Android 34 support**: Added full compatibility with Android API level 34

## [1.0.1] - 2023-11-10

### Fixed
- **iOS native**: Updated iOS native framework to 1.0.3
- **Trip management**: Fixed asset ID validation issue when starting trips
- **Error handling**: Improved trip start error detection and reporting

## [1.0.0] - 2023-10-25

### Added
- **Trip management**: Complete trip implementation and lifecycle management
- **Trip operations**: Full trip creation, start, stop, and monitoring capabilities

## [0.2.0] - 2023-09-15

### Fixed
- **Android native**: Updated Android native framework to 0.3.5
- **API parameters**: Fixed update asset API parameters issue
- **Error messaging**: Improved error message handling for network exceptions
- **Asset management**: Fixed Android asset ID takeover issue

## [0.1.0] - 2023-08-01

### Added
- **Asset creation**: Core asset creation and management functionality
- **Asset binding**: Asset binding and association capabilities
- **Location callbacks**: Real-time location information callback system
- **Tracking controls**: Basic start and stop tracking functionality
- **Asset details**: Asset detail retrieval and display features
