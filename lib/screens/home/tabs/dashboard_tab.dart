import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_localizations.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/nutrition_provider.dart';
import '../../../widgets/calorie_ring.dart';
import '../../../widgets/nutrition_card.dart';
import '../../../widgets/meal_item_card.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  String _getGreeting(AppLocalizations local) {
    final hour = DateTime.now().hour;
    if (hour < 12) return local.goodMorning;
    if (hour < 17) return local.goodAfternoon;
    return local.goodEvening;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final nutrition = context.watch<NutritionProvider>();
    final local = AppLocalizations.of(context);
    
    // Null check - WAJIB
    if (local == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Top Header Banner
              Container(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                decoration: const BoxDecoration(
                  gradient: AppTheme.darkGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    // Greeting row
                    FadeInDown(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getGreeting(local),
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.name.isEmpty
                                      ? 'User GoHealth!'
                                      : '${user.name}! 👋',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: AppTheme.primaryGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.notifications_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Calorie Ring
                    FadeInUp(
                      delay: const Duration(milliseconds: 200),
                      child: CalorieRing(
                        consumed: nutrition.consumedCalories,
                        target: nutrition.calorieTarget,
                        size: 190,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Info row
                    FadeInUp(
                      delay: const Duration(milliseconds: 350),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _InfoChip(
                              label: local.target,
                              value: '${nutrition.calorieTarget} kal',
                              icon: Icons.track_changes_rounded,
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: Colors.white12,
                            ),
                            _InfoChip(
                              label: local.consumed,
                              value:
                                  '${nutrition.consumedCalories.round()} kal',
                              icon: Icons.local_fire_department_rounded,
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: Colors.white12,
                            ),
                            _InfoChip(
                              label: local.remaining,
                              value:
                                  '${nutrition.remainingCalories.round()} kal',
                              icon: Icons.battery_5_bar_rounded,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Macro Section
                    FadeInUp(
                      delay: const Duration(milliseconds: 400),
                      child: Text(
                        local.nutritionToday,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    FadeInUp(
                      delay: const Duration(milliseconds: 450),
                      child: Row(
                        children: [
                          Expanded(
                            child: NutritionCard(
                              label: local.carbs,
                              consumed: nutrition.carbsConsumed,
                              target: nutrition.carbsTarget,
                              unit: 'g',
                              color: AppTheme.carbColor,
                              icon: Icons.grain_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: NutritionCard(
                              label: local.protein,
                              consumed: nutrition.proteinConsumed,
                              target: nutrition.proteinTarget,
                              unit: 'g',
                              color: AppTheme.proteinColor,
                              icon: Icons.fitness_center_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: NutritionCard(
                              label: local.fat,
                              consumed: nutrition.fatConsumed,
                              target: nutrition.fatTarget,
                              unit: 'g',
                              color: AppTheme.fatColor,
                              icon: Icons.opacity_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    FadeInUp(
                      delay: const Duration(milliseconds: 500),
                      child: Text(
                        local.quickActions,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    FadeInUp(
                      delay: const Duration(milliseconds: 550),
                      child: Row(
                        children: [
                          Expanded(
                            child: _QuickActionCard(
                              icon: Icons.qr_code_scanner_rounded,
                              label: local.scanFood,
                              color: AppTheme.primaryGreen,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppConstants.scanRoute,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _QuickActionCard(
                              icon: Icons.restaurant_menu_rounded,
                              label: local.mealPlan,
                              color: AppTheme.carbColor,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppConstants.mealPlanRoute,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _QuickActionCard(
                              icon: Icons.water_drop_rounded,
                              label: local.recordWater,
                              color: const Color(0xFF3498DB),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recent Meals
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            local.recentMeals,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            local.viewAll,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    FadeInUp(
                      delay: const Duration(milliseconds: 650),
                      child: Column(
                        children: nutrition.mealLogs
                            .take(3)
                            .map(
                              (log) => MealItemCard(
                                emoji: '🍽️',
                                name: log.name,
                                calories: log.calories,
                                mealType: log.mealType,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryGreen, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}