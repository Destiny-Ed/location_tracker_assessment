import 'package:flutter/material.dart';
import 'package:location_tracker_assessment/app.dart';
import 'package:location_tracker_assessment/core/services/background_service.dart';
import 'package:location_tracker_assessment/core/services/notification_service.dart';
import 'package:provider/provider.dart';

import 'features/location_tracking/presentation/providers/location_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize();
  await BackgroundServiceHandler.initializeService();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LocationProvider())],
      child: const MyApp(),
    ),
  );
}
