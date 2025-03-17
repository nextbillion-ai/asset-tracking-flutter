import 'package:permission_handler/permission_handler.dart';

Future<bool> checkLocationPermission() async {
  var location = await Permission.location.status;
  if (location.isGranted) {
    var locationAlways = await Permission.locationAlways.status;
    if (locationAlways.isGranted) {
      return true;
    }

  }
  return false;
}

Future<bool> checkAndRequestLocationPermission() async {
  var status = await Permission.location.status;
  if (status.isGranted) {
    return true;
  } else if (status.isDenied) {
    status = await Permission.location.request();
    return status.isGranted;
  } else if (status.isPermanentlyDenied) {
    openAppSettings();
    return false;
  }
  return false;
}
