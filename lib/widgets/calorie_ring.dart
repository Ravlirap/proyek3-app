import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../core/theme/app_theme.dart';

class CalorieRing extends StatelessWidget {
  final double consumed;
  final int target;
  final double size;

  const CalorieRing({
    super.key,
    required this.consumed,
    required this.target,
    this.size = 180,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (consumed / target).clamp(0.0, 1.0);
    final remaining = (target - consumed).clamp(0, double.infinity).round();

    return CircularPercentIndicator(
      radius: size / 2,
      lineWidth: 14,
      percent: progress,
      animation: true,
      animationDuration: 1200,
      animateFromLastPercent: true,
      backgroundColor: AppTheme.lightGreen,
      linearGradient: const LinearGradient(
        colors: [AppTheme.primaryGreen, AppTheme.accentGreen],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      circularStrokeCap: CircularStrokeCap.round,
      center: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${consumed.round()}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color.fromARGB(255, 223, 255, 241),
              height: 1.0,
            ),
          ),
          const Text(
            'kal',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 198, 255, 221),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Sisa $remaining kal',
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.darkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
