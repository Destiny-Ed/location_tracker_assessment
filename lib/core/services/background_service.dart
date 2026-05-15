import 'dart:async';
import 'dart:developer';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:location_tracker_assessment/features/location_tracking/data/repositories/location_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
class BackgroundServiceHandler {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        foregroundServiceNotificationId: 1001,
        initialNotificationTitle: 'Location Tracking Active',
        initialNotificationContent: 'Preparing service...',
      ),
      iosConfiguration: IosConfiguration(),
    );
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    final prefs = await SharedPreferences.getInstance();
    final isTracking = prefs.getBool('tracking_enabled') ?? false;

    if (!isTracking) {
      service.stopSelf();
      return;
    }

    if (service is AndroidServiceInstance) {
      service.setAsForegroundService();

      service.setForegroundNotificationInfo(
        title: "Location Tracker Active",
        content: "Initializing location service...",
      );
    }

    service.on('stopService').listen((event) async {
      await prefs.setBool('tracking_enabled', false);
      service.stopSelf();
    });

    Timer.periodic(const Duration(minutes: 1), (timer) async {
      try {
        final position = await LocationRepository.getCurrentLocation();

        if (service is AndroidServiceInstance) {
          service.setForegroundNotificationInfo(
            title: "Tracking Location 📍",
            content:
                "Lat: ${position.latitude.toStringAsFixed(5)} | Lng: ${position.longitude.toStringAsFixed(5)}",
          );
        }

        service.invoke('location_update', {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': DateTime.now().toIso8601String(),
          'source': 'background',
        });
      } catch (e) {
        log("Background error: $e");
      }
    });
  }
}
