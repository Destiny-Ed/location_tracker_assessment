enum LocationSource { foreground, background }

class LocationLogModel {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final LocationSource source;

  LocationLogModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.source,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.toIso8601String(),
      'source': source.name,
    };
  }

  factory LocationLogModel.fromJson(Map<String, dynamic> json) {
    return LocationLogModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
      source: LocationSource.values.firstWhere(
        (e) => e.name == json['source'],
        orElse: () => LocationSource.foreground,
      ),
    );
  }
}
