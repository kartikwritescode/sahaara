class VitalsModel {
  final String id;
  final String seniorId;
  final int? heartRateBpm;
  final int? spo2Percent;
  final DateTime recordedAt;

  VitalsModel({
    required this.id,
    required this.seniorId,
    this.heartRateBpm,
    this.spo2Percent,
    required this.recordedAt,
  });

  factory VitalsModel.fromJson(Map<String, dynamic> json) {
    return VitalsModel(
      id: json['id'] ?? '',
      seniorId: json['senior_id'] ?? '',
      heartRateBpm: json['heart_rate_bpm'],
      spo2Percent: json['spo2_percent'],
      recordedAt: DateTime.tryParse(json['recorded_at'] ?? '') ?? DateTime.now(),
    );
  }
}
