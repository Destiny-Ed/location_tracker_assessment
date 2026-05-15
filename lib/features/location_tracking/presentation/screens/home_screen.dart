import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_tracker_assessment/features/location_tracking/data/models/location_model.dart';
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
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.primaryContainer,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.isTracking ? 'Tracking Active' : 'Tracking Disabled',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 20),

                          const Text('Latitude'),

                          const SizedBox(height: 4),

                          Text(
                            provider.currentPosition?.latitude.toStringAsFixed(6) ?? '--',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),

                          const SizedBox(height: 16),

                          const Text('Longitude'),

                          const SizedBox(height: 4),

                          Text(
                            provider.currentPosition?.longitude.toStringAsFixed(6) ?? '--',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),

                          const SizedBox(height: 16),

                          Text('Logs Recorded: ${provider.logs.length}'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    SwitchListTile(
                      value: provider.isTracking,
                      onChanged: provider.toggleTracking,
                      title: const Text('Enable Background Tracking'),
                      subtitle: const Text('Tracks every 15 seconds'),
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

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Section Header
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                      child: Text(
                                        dateLabel,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                    ),

                                    //Logs under the sectiion date
                                    ...logs.map((log) {
                                      return Card(
                                        child: ListTile(
                                          title: Text('Lat: ${log.latitude}'),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Lng: ${log.longitude}'),
                                              const SizedBox(height: 4),

                                              Row(
                                                children: [
                                                  Icon(
                                                    log.source == LocationSource.background
                                                        ? Icons.cloud
                                                        : Icons.phone_android,
                                                    size: 16,
                                                    color: log.source == LocationSource.background
                                                        ? Colors.orange
                                                        : Colors.green,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    log.source == LocationSource.background
                                                        ? 'Background'
                                                        : 'Foreground',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: log.source == LocationSource.background
                                                          ? Colors.orange
                                                          : Colors.green,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 4),

                                              Text(
                                                DateFormat('hh:mm a').format(log.timestamp),
                                                style: const TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                );
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
