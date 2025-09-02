import 'package:permission_handler/permission_handler.dart';

Future<bool> checkLocationPermission() async {
  final PermissionStatus location = await Permission.location.status;
  if (location.isGranted) {
    final PermissionStatus locationAlways =
        await Permission.locationAlways.status;
    if (locationAlways.isGranted) {
      return true;
    }
  }
  return false;
}

Future<bool> checkAndRequestLocationPermission() async {
  PermissionStatus status = await Permission.location.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    status = await Permission.location.request();
    return status.isGranted;
  } else if (status.isPermanentlyDenied) {
    await openAppSettings();
    return false;
  }
  return false;
}
