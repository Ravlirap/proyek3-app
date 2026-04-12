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
  Widget _buildMacroItem({
  required String icon,
  required String label,
  required double consumed,
  required double target,
  required String unit,
  required Color color,
}) {
  final percentage = (consumed / target).clamp(0.0, 1.0);
  
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${consumed.round()}/${target.round()}$unit',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 4,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildSmartSuggestion({
  required String icon,
  required String title,
  required String message,
  required Color color,
}) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                message,
                style: const TextStyle(fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                    // Ganti bagian NUTRISI HARI INI (3 kartu terpisah) dengan ini:

FadeInUp(
  delay: const Duration(milliseconds: 400),
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Row(
          children: [
            Icon(Icons.analytics_rounded, size: 20, color: AppTheme.primaryGreen),
            SizedBox(width: 8),
            Text(
              'Nutrisi Hari Ini',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // 3 Makro dalam satu baris
        Consumer<NutritionProvider>(
          builder: (context, provider, child) {
            return Row(
              children: [
                _buildMacroItem(
                  icon: '🍚',
                  label: 'Karbo',
                  consumed: provider.carbsConsumed,
                  target: provider.carbsTarget,
                  unit: 'g',
                  color: AppTheme.carbColor,
                ),
                const SizedBox(width: 12),
                _buildMacroItem(
                  icon: '🥩',
                  label: 'Protein',
                  consumed: provider.proteinConsumed,
                  target: provider.proteinTarget,
                  unit: 'g',
                  color: AppTheme.proteinColor,
                ),
                const SizedBox(width: 12),
                _buildMacroItem(
                  icon: '🧈',
                  label: 'Lemak',
                  consumed: provider.fatConsumed,
                  target: provider.fatTarget,
                  unit: 'g',
                  color: AppTheme.fatColor,
                ),
              ],
            );
          },
        ),
        
        const SizedBox(height: 16),
        
        // Saran cerdas (berdasarkan nutrisi yang paling kurang)
        Consumer<NutritionProvider>(
          builder: (context, provider, child) {
            final carbPercent = provider.carbsConsumed / provider.carbsTarget;
            final proteinPercent = provider.proteinConsumed / provider.proteinTarget;
            final fatPercent = provider.fatConsumed / provider.fatTarget;
            
            // Cari yang paling kurang
            if (proteinPercent < carbPercent && proteinPercent < fatPercent) {
              final need = (provider.proteinTarget - provider.proteinConsumed).round();
              return _buildSmartSuggestion(
                icon: '🥚',
                title: 'Protein kurang nih!',
                message: 'Butuh +$need g lagi. Coba telur, ayam, atau tahu',
                color: AppTheme.proteinColor,
              );
            } else if (carbPercent < proteinPercent && carbPercent < fatPercent) {
              final need = (provider.carbsTarget - provider.carbsConsumed).round();
              return _buildSmartSuggestion(
                icon: '🍚',
                title: 'Karbohidrat kurang',
                message: 'Butuh +$need g lagi. Nasi merah atau ubi bisa jadi pilihan',
                color: AppTheme.carbColor,
              );
            } else if (fatPercent < carbPercent && fatPercent < proteinPercent) {
              final need = (provider.fatTarget - provider.fatConsumed).round();
              return _buildSmartSuggestion(
                icon: '🥑',
                title: 'Lemak sehat kurang',
                message: 'Butuh +$need g lagi. Alpukat atau kacang-kacangan',
                color: AppTheme.fatColor,
              );
            }
            
            return _buildSmartSuggestion(
              icon: '🎉',
              title: 'Nutrisi seimbang!',
              message: 'Pertahankan pola makan yang baik',
              color: AppTheme.primaryGreen,
            );
          },
        ),
      ],
    ),
  ),
),

                    // Recent Meals
                    // Recent Meals - DIGANTI DENGAN PROGRESS MAKAN
                    FadeInUp(
                      delay: const Duration(milliseconds: 600),
                      child: Consumer<NutritionProvider>(
                        builder: (context, provider, child) {
                          return Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '📊 Progress Makan Hari Ini',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Ringkasan total kalori
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.green.shade400,
                                        Colors.green.shade600,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Total Kalori Hari Ini',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${provider.consumedCalories.round()}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            'Target Harian',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${provider.calorieTarget} kal',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Progress per jenis makan (sementara pakai container biasa dulu)
                                _buildMealProgressCard(
                                  mealName: 'Sarapan',
                                  mealIcon: '🍳',
                                  consumed: provider.consumedBreakfast,
                                  target: provider.targetBreakfast,
                                  color: Colors.orange,
                                ),

                                _buildMealProgressCard(
                                  mealName: 'Makan Siang',
                                  mealIcon: '🍲',
                                  consumed: provider.consumedLunch,
                                  target: provider.targetLunch,
                                  color: Colors.blue,
                                ),

                                _buildMealProgressCard(
                                  mealName: 'Makan Malam',
                                  mealIcon: '🍽️',
                                  consumed: provider.consumedDinner,
                                  target: provider.targetDinner,
                                  color: Colors.purple,
                                ),

                                _buildMealProgressCard(
                                  mealName: 'Camilan',
                                  mealIcon: '🍎',
                                  consumed: provider.consumedSnack,
                                  target: provider.targetSnack,
                                  color: Colors.teal,
                                ),

                                const SizedBox(height: 8),

                                // Tombol aksi cepat (opsional, karena sudah ada quick actions di atas)
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppConstants.scanRoute,
                                          );
                                        },
                                        icon: const Icon(Icons.qr_code_scanner),
                                        label: const Text('Scan Makanan'),
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          // Navigasi ke halaman catat manual
                                        },
                                        icon: const Icon(Icons.edit_note),
                                        label: const Text('Catat Manual'),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealProgressCard({
    required String mealName,
    required String mealIcon,
    required double consumed,
    required double target,
    required Color color,
  }) {
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
          LinearProgressIndicator(
            value: percentage,
            color: color,
            backgroundColor: color.withValues(alpha: 0.15),
          ),
        ],
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
