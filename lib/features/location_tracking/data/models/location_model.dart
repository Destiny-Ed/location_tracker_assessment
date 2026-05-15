class LocationLogModel {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  LocationLogModel({required this.latitude, required this.longitude, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude, 'timestamp': timestamp.toIso8601String()};
  }

  factory LocationLogModel.fromJson(Map<String, dynamic> json) {
    return LocationLogModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
