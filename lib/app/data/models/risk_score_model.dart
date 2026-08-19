class RiskScoreFactor {
  final String label;
  final int points;

  RiskScoreFactor({required this.label, required this.points});

  factory RiskScoreFactor.fromJson(Map<String, dynamic> json) {
    return RiskScoreFactor(
      label: json['label'] as String? ?? 'Factor',
      points: json['points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'label': label, 'points': points};
}

class RiskScoreModel {
  final String id;
  final String seniorId;
  final int score;
  final String level; // 'normal','attention','concern','critical'
  final List<RiskScoreFactor> factors;
  final DateTime computedAt;

  RiskScoreModel({
    required this.id,
    required this.seniorId,
    required this.score,
    required this.level,
    required this.factors,
    required this.computedAt,
  });

  factory RiskScoreModel.fromJson(Map<String, dynamic> json) {
    var rawFactors = json['factors'] as List<dynamic>? ?? [];
    return RiskScoreModel(
      id: json['id'] as String,
      seniorId: json['senior_id'] as String,
      score: json['score'] as int? ?? 0,
      level: json['level'] as String? ?? 'normal',
      factors: rawFactors.map((f) => RiskScoreFactor.fromJson(f as Map<String, dynamic>)).toList(),
      computedAt: DateTime.parse(json['computed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senior_id': seniorId,
      'score': score,
      'level': level,
      'factors': factors.map((f) => f.toJson()).toList(),
      'computed_at': computedAt.toIso8601String(),
    };
  }
}
