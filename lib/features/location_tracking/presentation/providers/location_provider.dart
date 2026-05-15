import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_tracker_assessment/core/services/permission_service.dart';
import 'package:location_tracker_assessment/core/services/storage_service.dart';
import 'package:location_tracker_assessment/core/utils/date_formatter.dart';
import 'package:location_tracker_assessment/features/location_tracking/data/models/location_model.dart';
import 'package:location_tracker_assessment/features/location_tracking/data/repositories/location_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider extends ChangeNotifier {
  Position? currentPosition;

  bool isTrackingEnabled = false;

  bool isLoading = true;

  bool hasPermission = false;

  bool permissionDeniedForever = false;

  List<LocationLogModel> logs = [];

  StreamSubscription? _serviceSubscription;

  LocationProvider() {
    initialize();
  }

  Future<void> initialize() async {
    isLoading = true;

    notifyListeners();

    logs = await StorageService.getLogs();

    isTrackingEnabled = await StorageService.getTrackingState();

    await checkAndRequestPermissions();

    if (hasPermission) {
      await getCurrentLocation();

      listenForUpdates();
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    if (!hasPermission) {
      return;
    }

    try {
      currentPosition = await LocationRepository.getCurrentLocation();

      //Log the initial position when the app starts
      final log = LocationLogModel(
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
        timestamp: DateTime.now(),
        source: LocationSource.foreground,
      );

      logs.insert(0, log);

      await StorageService.saveLogs(logs);
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggleTracking(bool value) async {
    if (!hasPermission) {
      return;
    }

    final service = FlutterBackgroundService();

    if (value) {
      await service.startService();
    } else {
      service.invoke('stopService');
    }

    isTrackingEnabled = value;

    await StorageService.saveTrackingState(value);

    notifyListeners();
  }

  Future<void> checkAndRequestPermissions() async {
    final granted = await PermissionService.requestLocationPermission();

    print("granted: $granted");

    hasPermission = granted;

    // Combine all "permanently denied" states properly
    final locationDenied = await PermissionService.isLocationPermanentlyDenied();

    final backgroundDenied = await PermissionService.isBackgroundPermanentlyDenied();

    final notificationDenied = await PermissionService.isNotificationPermanentlyDenied();

    permissionDeniedForever = locationDenied || backgroundDenied || notificationDenied;

    notifyListeners();
  }

  Future<void> listenForUpdates() async {
    final service = FlutterBackgroundService();

    _serviceSubscription?.cancel();

    _serviceSubscription = service.on('location_update').listen((event) async {
      if (event == null) {
        return;
      }

      try {
        final latitude = (event['latitude'] as num).toDouble();
        final longitude = (event['longitude'] as num).toDouble();
        final source = event['source'] == 'background'
            ? LocationSource.background
            : LocationSource.foreground;

        final timestamp = DateTime.parse(event['timestamp'].toString());

        currentPosition = Position(
          longitude: longitude,
          latitude: latitude,
          timestamp: timestamp,
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );

        final log = LocationLogModel(
          latitude: latitude,
          longitude: longitude,
          timestamp: timestamp,
          source: source,
        );

        logs.insert(0, log);

        // Prevent huge local storage growth
        if (logs.length > 500) {
          logs = logs.take(500).toList();
        }

        await StorageService.saveLogs(logs);

        notifyListeners();
      } catch (e) {
        debugPrint('Location update error: $e');
      }
    });
  }

  Future<void> openPermissionSettings() async {
    await openAppSettings();
  }

  //Log grouping logic for the UI
  Map<String, List<LocationLogModel>> groupLogsByDate(List<LocationLogModel> logs) {
    final Map<String, List<LocationLogModel>> grouped = {};

    for (final log in logs) {
      final date = log.timestamp;
      final key = getDateLabel(date);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(log);
    }

    return grouped;
  }

  List<MapEntry<String, List<LocationLogModel>>> getGroupedLogs(List<LocationLogModel> logs) {
    final grouped = groupLogsByDate(logs);

    final entries = grouped.entries.toList();

    // sort by latest date first
    entries.sort((a, b) {
      final aDate = a.value.first.timestamp;
      final bDate = b.value.first.timestamp;
      return bDate.compareTo(aDate);
    });

    return entries;
  }
}
