import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/scan_provider.dart';
import '../../providers/nutrition_provider.dart';

class AnalysisResultScreen extends StatefulWidget {
  const AnalysisResultScreen({super.key});

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  bool _added = false;

  void _addToLog() {
    final scan = context.read<ScanProvider>();
    final nutrition = context.read<NutritionProvider>();
    final result = scan.detectionResult!;

    nutrition.addMeal(
      name: result['name'] as String,
      calories: scan.adjustedCalories,
      carbs: scan.adjustedCarbs,
      protein: scan.adjustedProtein,
      fat: scan.adjustedFat,
      mealType: _getMealType(),
    );

    setState(() => _added = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${result['name']} ditambahkan ke catatan harian!'),
        backgroundColor: AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) Navigator.pop(context, true);
    });
  }

  String _getMealType() {
    final hour = DateTime.now().hour;
    if (hour < 10) return 'Breakfast';
    if (hour < 14) return 'Lunch';
    if (hour < 18) return 'Snack';
    return 'Dinner';
  }

  @override
  Widget build(BuildContext context) {
    final scan = context.watch<ScanProvider>();
    final result = scan.detectionResult;

    if (result == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final confidence = (result['confidence'] as num).toDouble();
    final description = result['description'] as String;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Top image area
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppTheme.darkGreen,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.darkGradient,
                ),
                child: Center(
                  child: FadeInDown(
                    child: Text(
                      result['imageEmoji'] as String,
                      style: const TextStyle(fontSize: 120),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Food name + confidence
                  FadeInUp(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result['name'] as String,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: _confidenceColor(confidence)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _confidenceColor(confidence)
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${confidence.toStringAsFixed(1)}%',
                                style: TextStyle(
                                  color: _confidenceColor(confidence),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'akurasi',
                                style: TextStyle(
                                  color: _confidenceColor(confidence),
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Total calorie banner
                  FadeInUp(
                    delay: const Duration(milliseconds: 150),
                    child: Container(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Kalori',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                              Text(
                                '${scan.adjustedCalories.round()} kal',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.local_fire_department_rounded,
                              color: Colors.white70, size: 44),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Macro detail
                  FadeInUp(
                    delay: const Duration(milliseconds: 250),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Detail Nutrisi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _NutrientRow(
                            label: 'Karbohidrat',
                            value: '${scan.adjustedCarbs.toStringAsFixed(1)} g',
                            color: AppTheme.carbColor,
                            icon: Icons.grain_rounded,
                          ),
                          _NutrientRow(
                            label: 'Protein',
                            value: '${scan.adjustedProtein.toStringAsFixed(1)} g',
                            color: AppTheme.proteinColor,
                            icon: Icons.fitness_center_rounded,
                          ),
                          _NutrientRow(
                            label: 'Lemak',
                            value: '${scan.adjustedFat.toStringAsFixed(1)} g',
                            color: AppTheme.fatColor,
                            icon: Icons.opacity_rounded,
                          ),
                          _NutrientRow(
                            label: 'Serat',
                            value: '${((result['fiber'] ?? 2.0) as num) * scan.portionMultiplier} g',
                            color: const Color(0xFF27AE60),
                            icon: Icons.spa_rounded,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Portion slider
                  FadeInUp(
                    delay: const Duration(milliseconds: 350),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Ukuran Porsi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightGreen,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${(scan.portionMultiplier * 100).round()}%',
                                  style: const TextStyle(
                                    color: AppTheme.darkGreen,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${scan.adjustedCalories.round()} kal total',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppTheme.primaryGreen,
                              inactiveTrackColor: AppTheme.lightGreen,
                              thumbColor: AppTheme.primaryGreen,
                              overlayColor:
                                  AppTheme.primaryGreen.withOpacity(0.15),
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 12),
                              trackHeight: 5,
                            ),
                            child: Slider(
                              value: scan.portionMultiplier,
                              min: 0.25,
                              max: 3.0,
                              divisions: 11,
                              onChanged: (v) =>
                                  context.read<ScanProvider>().setPortion(v),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('¼ porsi',
                                  style: TextStyle(
                                      color: AppTheme.textHint, fontSize: 11)),
                              Text('½ porsi',
                                  style: TextStyle(
                                      color: AppTheme.textHint, fontSize: 11)),
                              Text('1 porsi',
                                  style: TextStyle(
                                      color: AppTheme.textHint, fontSize: 11)),
                              Text('2 porsi',
                                  style: TextStyle(
                                      color: AppTheme.textHint, fontSize: 11)),
                              Text('3 porsi',
                                  style: TextStyle(
                                      color: AppTheme.textHint, fontSize: 11)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Add button
                  FadeInUp(
                    delay: const Duration(milliseconds: 450),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: _added
                              ? null
                              : AppTheme.primaryGradient,
                          color: _added ? Colors.grey.shade200 : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: _added
                              ? []
                              : [
                                  BoxShadow(
                                    color: AppTheme.primaryGreen
                                        .withOpacity(0.35),
                                    blurRadius: 15,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _added ? null : _addToLog,
                            borderRadius: BorderRadius.circular(16),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _added
                                        ? Icons.check_circle_rounded
                                        : Icons.add_circle_rounded,
                                    color: _added
                                        ? AppTheme.primaryGreen
                                        : Colors.white,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _added
                                        ? 'Ditambahkan!'
                                        : 'Tambah ke Catatan',
                                    style: TextStyle(
                                      color: _added
                                          ? AppTheme.primaryGreen
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _confidenceColor(double conf) {
    if (conf >= 90) return AppTheme.primaryGreen;
    if (conf >= 75) return AppTheme.carbColor;
    return Colors.red;
  }
}

class _NutrientRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  final bool isLast;

  const _NutrientRow({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(color: AppTheme.divider, height: 1, thickness: 1),
      ],
    );
  }
}
