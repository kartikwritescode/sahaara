import 'package:flutter/material.dart';
import '../utils/risk_band_helper.dart';

class RiskStatusChip extends StatelessWidget {
  final int score;

  const RiskStatusChip({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    final color = RiskBandHelper.getColor(score);
    final label = RiskBandHelper.getLabel(score);
    final icon = RiskBandHelper.getIcon(score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            '$label ($score)',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
