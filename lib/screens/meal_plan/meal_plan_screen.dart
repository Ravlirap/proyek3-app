import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rencana Makan'),
        centerTitle: false,
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MealPlanCard(
            meal: 'Sarapan',
            time: '07:00 - 08:00',
            calories: '350-450 kal',
            foods: ['Oatmeal', 'Pisang', 'Telur rebus'],
            color: const Color(0xFFFF9800),
          ),
          _MealPlanCard(
            meal: 'Makan Siang',
            time: '12:00 - 13:00',
            calories: '500-600 kal',
            foods: ['Nasi merah', 'Ayam panggang', 'Sayuran'],
            color: const Color(0xFF4CAF50),
          ),
          _MealPlanCard(
            meal: 'Camilan Sore',
            time: '15:00 - 16:00',
            calories: '150-200 kal',
            foods: ['Yogurt', 'Buah segar', 'Kacang almond'],
            color: const Color(0xFF2196F3),
          ),
          _MealPlanCard(
            meal: 'Makan Malam',
            time: '18:00 - 19:00',
            calories: '400-500 kal',
            foods: ['Ikan bakar', 'Quinoa', 'Salad'],
            color: const Color(0xFF9C27B0),
          ),
        ],
      ),
    );
  }
}

class _MealPlanCard extends StatelessWidget {
  final String meal;
  final String time;
  final String calories;
  final List<String> foods;
  final Color color;

  const _MealPlanCard({
    required this.meal,
    required this.time,
    required this.calories,
    required this.foods,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getMealIcon(meal),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    calories,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: foods
                  .map((food) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            Icon(Icons.circle, size: 6, color: color),
                            const SizedBox(width: 8),
                            Text(food),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMealIcon(String meal) {
    switch (meal) {
      case 'Sarapan':
        return Icons.free_breakfast_rounded;
      case 'Makan Siang':
        return Icons.lunch_dining_rounded;
      case 'Camilan Sore':
        return Icons.cake_rounded;
      case 'Makan Malam':
        return Icons.dinner_dining_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }
}