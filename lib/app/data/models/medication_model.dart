class MedicationModel {
  final String id;
  final String seniorId;
  final String name;
  final String? dosage;
  final List<dynamic>? scheduleTimes;
  final bool active;

  MedicationModel({
    required this.id,
    required this.seniorId,
    required this.name,
    this.dosage,
    this.scheduleTimes,
    required this.active,
  });

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] as String,
      seniorId: json['senior_id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String?,
      scheduleTimes: json['schedule_times'] as List<dynamic>?,
      active: json['active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senior_id': seniorId,
      'name': name,
      'dosage': dosage,
      'schedule_times': scheduleTimes ?? [],
      'active': active,
    };
  }
}
