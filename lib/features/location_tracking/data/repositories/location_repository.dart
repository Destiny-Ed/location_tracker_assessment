import 'package:geolocator/geolocator.dart';

class LocationRepository {
  static Future<Position> getCurrentLocation() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
