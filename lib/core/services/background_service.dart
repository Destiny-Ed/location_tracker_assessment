import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

class BackgroundServiceHandler {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        isForegroundMode: true,
        autoStart: false,
        foregroundServiceNotificationId: 1001,
        initialNotificationTitle: 'Location Tracking',
        initialNotificationContent: 'Tracking active...',
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) {
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      final position = await Geolocator.getCurrentPosition();

      service.invoke('location_update', {'lat': position.latitude, 'lng': position.longitude});
    });
  }
}
