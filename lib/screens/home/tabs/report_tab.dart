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
    
    if (local == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    // DATA LENGKAP 7 HARI
    final List<DailyCalorie> weeklyData = [
      DailyCalorie(day: 'Senin', date: '5 Apr', calories: 820, isError: false, errorMsg: null),
      DailyCalorie(day: 'Selasa', date: '6 Apr', calories: 1540, isError: false, errorMsg: null),
      DailyCalorie(day: 'Rabu', date: '7 Apr', calories: 1880, isError: false, errorMsg: null),
      DailyCalorie(day: 'Kamis', date: '8 Apr', calories: 2100, isError: false, errorMsg: null),
      DailyCalorie(day: 'Jumat', date: '9 Apr', calories: 1650, isError: false, errorMsg: null),
      DailyCalorie(day: 'Sabtu', date: '10 Apr', calories: 1850, isError: false, errorMsg: null),
      DailyCalorie(day: 'Minggu', date: '11 Apr', calories: 740, isError: false, errorMsg: null),
    ];
    
    final int targetMin = 1600;
    final int targetMax = 2100;
    final int avgCalories = 1701;
    final int daysAchieved = 5;
    final int avgProtein = 38;
    final int totalFoods = 24;
    
    final validDays = weeklyData.where((d) => !d.isError).toList();
    final bestDay = validDays.reduce((a, b) => a.calories > b.calories ? a : b);
    final worstDay = validDays.reduce((a, b) => a.calories < b.calories ? a : b);
    
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(local.weeklyReport),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color.fromARGB(0, 23, 2, 2),
        foregroundColor: const Color.fromARGB(255, 0, 6, 3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3 KARTU STATISTIK
            Row(
              children: [
                _buildMainStatCard(
                  icon: Icons.local_fire_department_rounded,
                  value: '$avgCalories',
                  unit: 'kal',
                  label: local.avgCalories,
                  color: const Color.fromARGB(255, 254, 42, 0),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMainStatCard(
                    icon: Icons.emoji_events_rounded,
                    value: '$daysAchieved/7',
                    unit: 'hari',
                    label: local.daysAchieved,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMainStatCard(
                    icon: Icons.fitness_center_rounded,
                    value: '$avgProtein',
                    unit: 'g',
                    label: local.proteinAvg,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // GRAFIK BAR CHART (FIXED - NO OVERFLOW)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bar_chart_rounded, size: 20, color: AppTheme.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        local.weeklyCalories,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 1, 3, 2),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Scrollable bar chart
                  SizedBox(
                    height: 170,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(weeklyData.length, (i) {
                          final data = weeklyData[i];
                          final maxCal = 2200.0;
                          double heightPercent = data.isError ? 0.3 : (data.calories / maxCal).clamp(0.08, 1.0);
                          final barHeight = (heightPercent * 120).clamp(12.0, 120.0);
                          final isBest = !data.isError && data.calories == bestDay.calories;
                          
                          return SizedBox(
                            width: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (data.isError)
                                  const Icon(Icons.error_outline, size: 14, color: Colors.red)
                                else
                                  Text(
                                    '${data.calories}',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: isBest ? FontWeight.bold : FontWeight.normal,
                                      color: _getColorByCalorie(data.calories, targetMin, targetMax),
                                    ),
                                  ),
                                const SizedBox(height: 4),
                                Container(
                                  width: 32,
                                  height: barHeight,
                                  decoration: BoxDecoration(
                                    color: data.isError
                                        ? const Color.fromARGB(255, 243, 23, 23)
                                        : _getColorByCalorie(data.calories, targetMin, targetMax).withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _shortDayName(data.day),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  data.date,
                                  style: const TextStyle(fontSize: 8, color: AppTheme.textHint),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegend('Rendah', Colors.red),
                      const SizedBox(width: 10),
                      _buildLegend('Normal', Colors.green),
                      const SizedBox(width: 10),
                      _buildLegend('Tinggi', Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // RINGKASAN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('📊 Ringkasan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _buildInfoRow('🍽️ Total Makanan', '$totalFoods items'),
                  const SizedBox(height: 8),
                  _buildInfoRow('🎯 Target Harian', '$targetMin - $targetMax kalori'),
                  const SizedBox(height: 8),
                  _buildInfoRow('🏆 Hari Terbaik', '${bestDay.day} (${bestDay.calories} kal)'),
                  const SizedBox(height: 8),
                  _buildInfoRow('⚠️ Hari Terendah', '${worstDay.day} (${worstDay.calories} kal)'),
                  if (weeklyData.any((d) => d.isError)) ...[
                    const SizedBox(height: 8),
                    _buildInfoRow('Data Terendah ', '${worstDay.day} (${worstDay.calories} kal)'),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // SARAN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightGreen,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('💡 Saran Minggu Depan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 10),
                  _buildSuggestion('🥩 Tingkatkan protein di hari Senin & Minggu'),
                  const SizedBox(height: 6),
                  _buildSuggestion('⚠️ Perbaiki data error di hari Jumat'),
                  const SizedBox(height: 6),
                  _buildSuggestion('📈 Pertahankan konsistensi seperti hari Kamis'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMainStatCard({
    required IconData icon,
    required String value,
    required String unit,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            Text(unit, style: const TextStyle(fontSize: 9, color: AppTheme.textHint)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
  
  Widget _buildSuggestion(String text) {
    return Row(
      children: [
        const Text('• ', style: TextStyle(fontSize: 12)),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
  
  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textHint)),
      ],
    );
  }
  
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2)),
      ],
    );
  }
  
  Color _getColorByCalorie(int calorie, int min, int max) {
    if (calorie < min) return Colors.red;
    if (calorie > max) return Colors.orange;
    return Colors.green;
  }
  
  String _shortDayName(String day) {
    if (day.contains('Sen')) return 'Sen';
    if (day.contains('Sel')) return 'Sel';
    if (day.contains('Rab')) return 'Rab';
    if (day.contains('Kam')) return 'Kam';
    if (day.contains('Jum')) return 'Jum';
    if (day.contains('Sab')) return 'Sab';
    if (day.contains('Min')) return 'Min';
    return day.length > 3 ? day.substring(0, 3) : day;
  }
}

class DailyCalorie {
  final String day;
  final String date;
  final int calories;
  final bool isError;
  final String? errorMsg;
  
  DailyCalorie({
    required this.day,
    required this.date,
    required this.calories,
    required this.isError,
    this.errorMsg,
  });
}