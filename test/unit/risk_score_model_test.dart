import 'package:flutter_test/flutter_test.dart';
import 'package:sahaara/app/data/models/risk_score_model.dart';

void main() {
  group('RiskScoreModel JSON Serialization Tests', () {
    test('serializes to JSON and deserializes back correctly', () {
      final now = DateTime.now();
      final model = RiskScoreModel(
        id: 'score-123',
        seniorId: 'senior-456',
        score: 75,
        level: 'concern',
        factors: [
          RiskScoreFactor(label: 'Missed Check-in', points: 30),
          RiskScoreFactor(label: 'Location Anomaly', points: 45),
        ],
        computedAt: now,
      );

      final json = model.toJson();
      expect(json['id'], equals('score-123'));
      expect(json['senior_id'], equals('senior-456'));
      expect(json['score'], equals(75));
      expect(json['level'], equals('concern'));
      expect((json['factors'] as List).length, equals(2));

      final deserialized = RiskScoreModel.fromJson({
        'id': 'score-123',
        'senior_id': 'senior-456',
        'score': 75,
        'level': 'concern',
        'factors': [
          {'label': 'Missed Check-in', 'points': 30},
          {'label': 'Location Anomaly', 'points': 45},
        ],
        'computed_at': now.toIso8601String(),
      });

      expect(deserialized.id, equals(model.id));
      expect(deserialized.seniorId, equals(model.seniorId));
      expect(deserialized.score, equals(model.score));
      expect(deserialized.level, equals(model.level));
      expect(deserialized.factors.length, equals(2));
      expect(deserialized.factors[0].label, equals('Missed Check-in'));
    });
  });
}
