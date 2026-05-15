import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_tracker_assessment/features/location_tracking/data/models/location_model.dart';
import 'package:location_tracker_assessment/features/location_tracking/presentation/widgets/info_tiles.dart';
import 'package:location_tracker_assessment/features/location_tracking/presentation/widgets/location_log_card.dart';
import 'package:provider/provider.dart';

import '../providers/location_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LocationProvider>();

    final groupedLogs = provider.getGroupedLogs(provider.logs);

    return Scaffold(
      appBar: AppBar(title: const Text('Location Tracker')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : !provider.hasPermission
          ? SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_off, size: 90),

                      const SizedBox(height: 24),

                      const Text(
                        'Location Permission Required',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        provider.permissionDeniedForever
                            ? 'Permission permanently denied. Please enable it from settings.'
                            : 'This app requires location permission to function.',
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: provider.permissionDeniedForever
                              ? provider.openPermissionSettings
                              : provider.checkAndRequestPermissions,
                          child: Text(
                            provider.permissionDeniedForever ? 'Open Settings' : 'Grant Permission',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    LocationLogCard(provider: provider),

                    const SizedBox(height: 20),

                    SwitchListTile(
                      value: provider.isTrackingEnabled,
                      onChanged: provider.toggleTracking,
                      title: const Text('Enable Background Tracking'),
                      subtitle: const Text('Tracks every 1 minute'),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: provider.logs.isEmpty
                          ? const Center(child: Text('No location logs yet'))
                          : ListView.builder(
                              itemCount: groupedLogs.length,
                              itemBuilder: (context, index) {
                                final entry = groupedLogs[index];

                                final dateLabel = entry.key;
                                final logs = entry.value;

                                return LogTiles(dateLabel: dateLabel, logs: logs);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
