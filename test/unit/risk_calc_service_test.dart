import 'package:flutter_test/flutter_test.dart';
import 'package:sahaara/app/data/services/risk_calc_service.dart';

void main() {
  group('RiskCalcService Tests', () {
    late RiskCalcService service;

    setUp(() {
      service = RiskCalcService();
    });

    test('calculates normal risk when inactive < 3h and no missed checkin', () {
      final scoreModel = service.calculateMockRiskScore('senior-1', hoursInactive: 1, missedCheckin: false);
      expect(scoreModel.score, equals(0));
      expect(scoreModel.level, equals('normal'));
      expect(scoreModel.factors, isEmpty);
    });

    test('calculates attention level when inactive for 4 hours', () {
      final scoreModel = service.calculateMockRiskScore('senior-1', hoursInactive: 4, missedCheckin: false);
      expect(scoreModel.score, equals(40));
      expect(scoreModel.level, equals('attention'));
      expect(scoreModel.factors.length, equals(1));
      expect(scoreModel.factors.first.label, contains('Inactivity'));
    });

    test('calculates critical level when missed checkin and long inactivity', () {
      final scoreModel = service.calculateMockRiskScore('senior-1', hoursInactive: 6, missedCheckin: true);
      // Inactivity: 40 pts, Missed checkin: 30 pts => total 70 => concern level
      expect(scoreModel.score, equals(70));
      expect(scoreModel.level, equals('concern'));
      expect(scoreModel.factors.length, equals(2));
    });
  });
}
