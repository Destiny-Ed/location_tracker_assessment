import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestLocationPermission() async {
    final location = await Permission.location.request();

    if (!location.isGranted) return false;

    final background = await Permission.locationAlways.request();

    if (!background.isGranted) return false;

    final notification = await Permission.notification.request();

    return notification.isGranted;
  }

  static Future<bool> isLocationPermanentlyDenied() async {
    return await Permission.location.isPermanentlyDenied;
  }

  static Future<bool> isBackgroundPermanentlyDenied() async {
    return await Permission.locationAlways.isPermanentlyDenied;
  }

  static Future<bool> isNotificationPermanentlyDenied() async {
    return await Permission.notification.isPermanentlyDenied;
  }
}
