import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/nutrition_provider.dart';

class DailyProgressSection extends StatelessWidget {
  const DailyProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  Icon(Icons.bar_chart_rounded, size: 20, color: AppTheme.primaryGreen),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Progress Makan Hari Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Total Kalori Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Kalori',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${provider.consumedCalories.round()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Target Harian',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${provider.calorieTarget}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // Meal Progress Cards
            _buildMealCard(
              icon: '🍳',
              name: 'Sarapan',
              consumed: provider.consumedBreakfast,
              target: provider.targetBreakfast,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            _buildMealCard(
              icon: '🍲',
              name: 'Makan Siang',
              consumed: provider.consumedLunch,
              target: provider.targetLunch,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            _buildMealCard(
              icon: '🍽️',
              name: 'Makan Malam',
              consumed: provider.consumedDinner,
              target: provider.targetDinner,
              color: Colors.purple,
            ),
            const SizedBox(height: 8),
            _buildMealCard(
              icon: '🍎',
              name: 'Camilan',
              consumed: provider.consumedSnack,
              target: provider.targetSnack,
              color: Colors.teal,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMealCard({
    required String icon,
    required String name,
    required double consumed,
    required double target,
    required Color color,
  }) {
    final percent = (consumed / target).clamp(0.0, 1.0);
    final isOver = consumed > target;
    final progressColor = isOver ? Colors.orange : color;
    final bgColor = (isOver ? Colors.orange : color).withValues(alpha: 0.15);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '${consumed.round()}/${target.round()}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isOver ? Colors.orange.shade700 : color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 5,
              backgroundColor: bgColor,
              color: progressColor,
            ),
          ),
          if (isOver) ...[
            const SizedBox(height: 4),
            Text(
              'Melebihi ${(consumed - target).round()} kalori',
              style: TextStyle(
                fontSize: 9,
                color: Colors.orange.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}