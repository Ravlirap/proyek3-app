import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/app_localizations.dart';
import '../../../providers/nutrition_provider.dart';

class ReportTab extends StatelessWidget {
  const ReportTab({super.key});

  @override
  Widget build(BuildContext context) {
    final nutrition = context.watch<NutritionProvider>();
    final local = AppLocalizations.of(context);
    
    // Null check - WAJIB
    if (local == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // Fake weekly data
    final weeklyData = [820, 1540, 1880, 2100, 1650, 1920, nutrition.consumedCalories.round()];
    final dayLabels = [local.mon, local.tue, local.wed, local.thu, local.fri, local.sat, local.sun];
    final maxVal = 2200;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(local.weeklyReport),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bar chart card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      local.weeklyCalories,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        local.thisWeek,
                        style: const TextStyle(
                          color: AppTheme.darkGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 160,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (i) {
                        final pct = weeklyData[i] / maxVal;
                        final isToday = i == 6;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${weeklyData[i]}',
                              style: TextStyle(
                                fontSize: 9,
                                color: isToday
                                    ? AppTheme.primaryGreen
                                    : AppTheme.textHint,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            AnimatedContainer(
                              duration:
                                  Duration(milliseconds: 600 + i * 100),
                              curve: Curves.easeOut,
                              width: 32,
                              height: (pct * 130).clamp(8.0, 130.0),
                              decoration: BoxDecoration(
                                gradient: isToday
                                    ? AppTheme.primaryGradient
                                    : null,
                                color: isToday ? null : AppTheme.lightGreen,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              dayLabels[i],
                              style: TextStyle(
                                fontSize: 11,
                                color: isToday
                                    ? AppTheme.primaryGreen
                                    : AppTheme.textHint,
                                fontWeight: isToday
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Stats grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.4,
              children: [
                _StatCard(
                  label: local.avgCalories,
                  value: '1.701',
                  unit: 'kal/hari',
                  icon: Icons.local_fire_department_rounded,
                  color: AppTheme.primaryGreen,
                ),
                _StatCard(
                  label: local.daysAchieved,
                  value: '5/7',
                  unit: local.daysAchieved,
                  icon: Icons.emoji_events_rounded,
                  color: AppTheme.carbColor,
                ),
                _StatCard(
                  label: local.proteinAvg,
                  value: '38',
                  unit: 'g/hari',
                  icon: Icons.fitness_center_rounded,
                  color: AppTheme.proteinColor,
                ),
                _StatCard(
                  label: local.totalFoodsReport,
                  value: '24',
                  unit: 'item',
                  icon: Icons.restaurant_rounded,
                  color: AppTheme.fatColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}