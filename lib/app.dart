import 'package:flutter/material.dart';
import 'package:location_tracker_assessment/features/location_tracking/presentation/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location Tracker',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
