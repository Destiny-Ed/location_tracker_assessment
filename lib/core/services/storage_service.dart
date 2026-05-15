import 'dart:convert';

import 'package:location_tracker_assessment/features/location_tracking/data/models/location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _logsKey = 'location_logs';
  static const _trackingKey = 'tracking_enabled';

  /// Logs are stored as JSON strings to allow for more complex data structures in the future
  static Future<void> saveLogs(List<LocationLogModel> logs) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = logs.map((e) => jsonEncode(e.toJson())).toList();

    await prefs.setStringList(_logsKey, encoded);
  }

  static Future<List<LocationLogModel>> getLogs() async {
    final prefs = await SharedPreferences.getInstance();

    final data = prefs.getStringList(_logsKey) ?? [];

    return data.map((e) => LocationLogModel.fromJson(jsonDecode(e))).toList();
  }

  /// Tracking state is stored to ensure that the service can resume tracking after app restarts
  static Future<void> saveTrackingState(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(_trackingKey, value);
  }

  static Future<bool> getTrackingState() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_trackingKey) ?? false;
  }
}
