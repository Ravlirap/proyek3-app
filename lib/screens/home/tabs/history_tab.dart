import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/nutrition_provider.dart';
import '../../../widgets/meal_item_card.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final nutrition = context.watch<NutritionProvider>();
    final logsByType = nutrition.logsByType;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Riwayat Makan'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.lightGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                DateFormat('dd MMM yyyy').format(DateTime.now()),
                style: const TextStyle(
                  color: AppTheme.darkGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryGreen.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _SummaryItem(
                    label: 'Total Kalori',
                    value: '${nutrition.consumedCalories.round()}',
                    unit: 'kal',
                  ),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _SummaryItem(
                    label: 'Makanan',
                    value: '${nutrition.mealLogs.length}',
                    unit: 'item',
                  ),
                  Container(width: 1, height: 40, color: Colors.white24),
                  _SummaryItem(
                    label: 'Tersisa',
                    value: '${nutrition.remainingCalories.round()}',
                    unit: 'kal',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...logsByType.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...entry.value.map((log) => MealItemCard(
                        emoji: '🍽️',
                        name: log.name,
                        calories: log.calories,
                        mealType:
                            DateFormat('HH:mm').format(log.time),
                      )),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _SummaryItem({required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(unit, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}
