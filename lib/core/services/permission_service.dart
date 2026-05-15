import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestLocationPermission() async {
    final foreground = await Permission.location.request();

    if (!foreground.isGranted) {
      return false;
    }

    final background = await Permission.locationAlways.request();

    return background.isGranted;
  }
}
