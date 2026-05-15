import 'package:flutter/material.dart';
import 'package:location_tracker_assessment/features/location_tracking/presentation/providers/location_provider.dart';

class LocationLogCard extends StatelessWidget {
  final LocationProvider provider;
  const LocationLogCard({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            provider.isTrackingEnabled ? 'Tracking Active' : 'Tracking Disabled',
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
    );
  }
}
