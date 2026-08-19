class ActivityEventModel {
  final String id;
  final String seniorId;
  final String eventType; // 'app_open','manual_active','movement','checkin_response','medication_confirm'
  final String source;
  final DateTime occurredAt;
  final Map<String, dynamic>? metadata;

  ActivityEventModel({
    required this.id,
    required this.seniorId,
    required this.eventType,
    required this.source,
    required this.occurredAt,
    this.metadata,
  });

  factory ActivityEventModel.fromJson(Map<String, dynamic> json) {
    return ActivityEventModel(
      id: json['id'] as String,
      seniorId: json['senior_id'] as String,
      eventType: json['event_type'] as String,
      source: json['source'] as String? ?? 'app',
      occurredAt: DateTime.parse(json['occurred_at']),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senior_id': seniorId,
      'event_type': eventType,
      'source': source,
      'occurred_at': occurredAt.toIso8601String(),
      'metadata': metadata ?? {},
    };
  }
}
