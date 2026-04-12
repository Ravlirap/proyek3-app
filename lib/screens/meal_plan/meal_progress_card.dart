import 'package:flutter/material.dart';

class MealProgressCard extends StatelessWidget {
  final String mealName;
  final String mealIcon;
  final double consumed;
  final double target;
  final Color color;

  const MealProgressCard({
    super.key,
    required this.mealName,
    required this.mealIcon,
    required this.consumed,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (consumed / target).clamp(0.0, 1.0);
    final isComplete = consumed >= target;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(mealIcon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mealName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${consumed.round()}/${target.round()} kal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isComplete ? Colors.green : Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              color: isComplete ? Colors.green : color,
              minHeight: 8,
            ),
          ),
          if (percentage < 0.3 && !isComplete)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '⚠️ Belum makan $mealName nih',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.orange.shade700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}