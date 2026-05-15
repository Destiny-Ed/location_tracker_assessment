import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location_tracker_assessment/features/location_tracking/data/models/location_model.dart';

class LogTiles extends StatelessWidget {
  const LogTiles({super.key, required this.dateLabel, required this.logs});

  final String dateLabel;
  final List<LocationLogModel> logs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Text(dateLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                        log.source == LocationSource.background ? Icons.cloud : Icons.phone_android,
                        size: 16,
                        color: log.source == LocationSource.background ? Colors.orange : Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        log.source == LocationSource.background ? 'Background' : 'Foreground',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: log.source == LocationSource.background ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(DateFormat('hh:mm a').format(log.timestamp), style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
