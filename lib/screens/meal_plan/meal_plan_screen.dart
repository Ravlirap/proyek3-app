import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Rencana Makan'),
        centerTitle: false,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.lightGreen,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_rounded,
                color: AppTheme.darkGreen, size: 20),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daily calorie target banner
            FadeInDown(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.darkGradient,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Target Kalori Hari Ini',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            '2.000 kal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Seimbang & bergizi tinggi',
                            style: TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.restaurant_menu_rounded,
                        color: AppTheme.primaryGreen,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Macro summary chips
            FadeInUp(
              delay: const Duration(milliseconds: 100),
              child: Row(
                children: [
                  Expanded(
                    child: _MacroChip(
                        label: 'Karbo', value: '250g', color: AppTheme.carbColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MacroChip(
                        label: 'Protein', value: '125g', color: AppTheme.proteinColor),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MacroChip(
                        label: 'Lemak', value: '55g', color: AppTheme.fatColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Meal sections
            _MealSection(
              mealType: 'Sarapan',
              icon: '☀️',
              time: '07:00 – 09:00',
              menu: AppConstants.breakfastMenu,
              delay: 200,
            ),
            _MealSection(
              mealType: 'Makan Siang',
              icon: '🌤️',
              time: '12:00 – 13:30',
              menu: AppConstants.lunchMenu,
              delay: 300,
            ),
            _MealSection(
              mealType: 'Snack',
              icon: '🍃',
              time: '15:00 – 16:00',
              menu: AppConstants.snackMenu,
              delay: 400,
            ),
            _MealSection(
              mealType: 'Makan Malam',
              icon: '🌙',
              time: '18:00 – 20:00',
              menu: AppConstants.dinnerMenu,
              delay: 500,
            ),

            const SizedBox(height: 8),
            // Total
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Kalori Rencana',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${_total()} kal',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  int _total() {
    int total = 0;
    for (final m in [
      ...AppConstants.breakfastMenu,
      ...AppConstants.lunchMenu,
      ...AppConstants.snackMenu,
      ...AppConstants.dinnerMenu,
    ]) {
      total += (m['calories'] as int);
    }
    return total;
  }
}

class _MacroChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MacroChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MealSection extends StatelessWidget {
  final String mealType;
  final String icon;
  final String time;
  final List<Map<String, dynamic>> menu;
  final int delay;

  const _MealSection({
    required this.mealType,
    required this.icon,
    required this.time,
    required this.menu,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final totalCal = menu.fold<int>(0, (s, m) => s + (m['calories'] as int));

    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.lightGreen.withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mealType,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGreen.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$totalCal kal',
                      style: const TextStyle(
                        color: AppTheme.darkGreen,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Menu items
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: menu.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.lightGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              item['icon'] as String,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item['name'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '${item['calories']} kal',
                          style: const TextStyle(
                            color: AppTheme.darkGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
