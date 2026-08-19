class IncidentModel {
  final String id;
  final String seniorId;
  final String? riskScoreId;
  final String status; // 'open', 'acknowledged', 'resolved'
  final String? aiSummary;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  IncidentModel({
    required this.id,
    required this.seniorId,
    this.riskScoreId,
    required this.status,
    this.aiSummary,
    required this.createdAt,
    this.resolvedAt,
  });

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'] as String,
      seniorId: json['senior_id'] as String,
      riskScoreId: json['risk_score_id'] as String?,
      status: json['status'] as String? ?? 'open',
      aiSummary: json['ai_summary'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senior_id': seniorId,
      'risk_score_id': riskScoreId,
      'status': status,
      'ai_summary': aiSummary,
      'created_at': createdAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }
}
