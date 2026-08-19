import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sahaara/app/core/constants/app_colors.dart';
import 'package:sahaara/app/core/utils/risk_band_helper.dart';

void main() {
  group('RiskBandHelper Tests', () {
    test('returns correct label for different risk scores', () {
      expect(RiskBandHelper.getLabel(10), equals('SAFE / NORMAL'));
      expect(RiskBandHelper.getLabel(35), equals('ATTENTION NEEDED'));
      expect(RiskBandHelper.getLabel(65), equals('CONCERN'));
      expect(RiskBandHelper.getLabel(85), equals('CRITICAL'));
    });

    test('returns correct color for different risk scores', () {
      expect(RiskBandHelper.getColor(20), equals(AppColors.riskNormal));
      expect(RiskBandHelper.getColor(40), equals(AppColors.riskAttention));
      expect(RiskBandHelper.getColor(70), equals(AppColors.riskConcern));
      expect(RiskBandHelper.getColor(90), equals(AppColors.riskCritical));
    });

    test('returns correct icon for different risk scores', () {
      expect(RiskBandHelper.getIcon(15), equals(Icons.check_circle_outline));
      expect(RiskBandHelper.getIcon(45), equals(Icons.info_outline));
      expect(RiskBandHelper.getIcon(75), equals(Icons.warning_amber_rounded));
      expect(RiskBandHelper.getIcon(95), equals(Icons.gpp_maybe));
    });
  });
}
