import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class RiskBandHelper {
  static Color getColor(int score) {
    if (score >= 81) return AppColors.riskCritical;
    if (score >= 61) return AppColors.riskConcern;
    if (score >= 31) return AppColors.riskAttention;
    return AppColors.riskNormal;
  }

  static String getLabel(int score) {
    if (score >= 81) return 'CRITICAL';
    if (score >= 61) return 'CONCERN';
    if (score >= 31) return 'ATTENTION NEEDED';
    return 'SAFE / NORMAL';
  }

  static IconData getIcon(int score) {
    if (score >= 81) return Icons.gpp_maybe;
    if (score >= 61) return Icons.warning_amber_rounded;
    if (score >= 31) return Icons.info_outline;
    return Icons.check_circle_outline;
  }
}
