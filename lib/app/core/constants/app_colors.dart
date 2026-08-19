import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFF26A69A);
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Colors.white;

  // Risk Score Band Colors
  static const Color riskNormal = Color(0xFF4CAF50);    // 0 - 30 🟢
  static const Color riskAttention = Color(0xFFFFC107); // 31 - 60 🟡
  static const Color riskConcern = Color(0xFFFF9800);   // 61 - 80 🟠
  static const Color riskCritical = Color(0xFFF44336);  // 81 - 100 🔴

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}
