class LocationModel {
  final String id;
  final String seniorId;
  final double lat;
  final double lng;
  final double? accuracyM;
  final DateTime recordedAt;

  LocationModel({
    required this.id,
    required this.seniorId,
    required this.lat,
    required this.lng,
    this.accuracyM,
    required this.recordedAt,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      seniorId: json['senior_id'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      accuracyM: (json['accuracy_m'] as num?)?.toDouble(),
      recordedAt: DateTime.parse(json['recorded_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senior_id': seniorId,
      'lat': lat,
      'lng': lng,
      'accuracy_m': accuracyM,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }
}
