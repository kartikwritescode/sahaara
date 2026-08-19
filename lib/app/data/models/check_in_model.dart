class CheckInModel {
  final String id;
  final String seniorId;
  final DateTime scheduledTime;
  final DateTime? respondedAt;
  final String response; // 'safe', 'need_help', 'no_response'
  final DateTime createdAt;

  CheckInModel({
    required this.id,
    required this.seniorId,
    required this.scheduledTime,
    this.respondedAt,
    required this.response,
    required this.createdAt,
  });

  factory CheckInModel.fromJson(Map<String, dynamic> json) {
    return CheckInModel(
      id: json['id'] as String,
      seniorId: json['senior_id'] as String,
      scheduledTime: DateTime.parse(json['scheduled_time']),
      respondedAt: json['responded_at'] != null ? DateTime.parse(json['responded_at']) : null,
      response: json['response'] as String? ?? 'no_response',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senior_id': seniorId,
      'scheduled_time': scheduledTime.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
      'response': response,
    };
  }
}
