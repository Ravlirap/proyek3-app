// lib/screens/tabs/history_tab.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  DateTime selectedDate = DateTime.now();
  DateTime currentMonth = DateTime.now();

  final Color primaryGreen = const Color(0xFF00A86B);
  final Color textDark = const Color(0xFF111827);
  final Color bgColor = const Color(0xFFF8F9FB);

  // Dummy data berdasarkan tanggal (simulasi)
  Map<String, Map<String, dynamic>> dataPerTanggal = {};

  void _generateDataForDate(DateTime date) {
    // Simulasi data berbeda per tanggal
    final key = DateFormat('yyyy-MM-dd').format(date);
    if (!dataPerTanggal.containsKey(key)) {
      final isWeekend = date.weekday == 6 || date.weekday == 7;
      dataPerTanggal[key] = {
        'calories': isWeekend ? 1850 + (date.day % 200) : 1650 + (date.day % 150),
        'caloriesBurned': 1316.4 + (date.day % 50),
        'protein': isWeekend ? 85 + (date.day % 30) : 75 + (date.day % 25),
        'fat': isWeekend ? 35 + (date.day % 15) : 28 + (date.day % 12),
        'carbs': isWeekend ? 180 + (date.day % 40) : 150 + (date.day % 35),
        'fiber': 12 + (date.day % 8),
        'proteinTarget': 135,
        'fatTarget': 50,
        'carbsTarget': 203,
        'fiberTarget': 25,
        'calorieTarget': 1800,
      };
    }
  }

  Map<String, dynamic> _getCurrentData() {
    final key = DateFormat('yyyy-MM-dd').format(selectedDate);
    _generateDataForDate(selectedDate);
    return dataPerTanggal[key]!;
  }

  List<DateTime> get weekDates {
    // Mulai dari hari Kamis (4) sampai Senin (1)
    final now = selectedDate;
    // Cari hari Kamis terdekat sebelum atau sama dengan selectedDate
    int daysToThursday = (now.weekday - 4) % 7;
    final thursday = now.subtract(Duration(days: daysToThursday));
    
    return [
      thursday, // Kamis
      thursday.add(const Duration(days: 1)), // Jumat
      thursday.add(const Duration(days: 2)), // Sabtu
      thursday.add(const Duration(days: 3)), // Minggu
      thursday.add(const Duration(days: 4)), // Senin
    ];
  }

  List<DateTime> get monthDates {
    final firstDay = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    final List<DateTime> dates = [];
    for (int i = 1; i <= lastDay.day; i++) {
      dates.add(DateTime(currentMonth.year, currentMonth.month, i));
    }
    return dates;
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      // Jika selectedDate melebihi bulan baru, set ke tanggal terakhir bulan baru
      if (selectedDate.month == currentMonth.month + 1 || 
          selectedDate.year > currentMonth.year) {
        final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);
        selectedDate = selectedDate.year == currentMonth.year && 
                       selectedDate.month == currentMonth.month + 1
            ? DateTime(currentMonth.year, currentMonth.month, 
                selectedDate.day <= lastDay.day ? selectedDate.day : lastDay.day)
            : DateTime(currentMonth.year, currentMonth.month, 1);
      }
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      if (selectedDate.month == currentMonth.month - 1) {
        selectedDate = DateTime(currentMonth.year, currentMonth.month, 
            selectedDate.day <= DateTime(currentMonth.year, currentMonth.month + 1, 0).day 
                ? selectedDate.day 
                : DateTime(currentMonth.year, currentMonth.month + 1, 0).day);
      }
    });
  }

  String get monthYear => DateFormat('MMMM yyyy', 'id_ID').format(currentMonth);

  @override
  Widget build(BuildContext context) {
    final data = _getCurrentData();
    final calorieProgress = (data['calories'] / data['calorieTarget']).clamp(0.0, 1.0);
    final proteinProgress = (data['protein'] / data['proteinTarget']).clamp(0.0, 1.0);
    final fatProgress = (data['fat'] / data['fatTarget']).clamp(0.0, 1.0);
    final carbsProgress = (data['carbs'] / data['carbsTarget']).clamp(0.0, 1.0);
    final fiberProgress = (data['fiber'] / data['fiberTarget']).clamp(0.0, 1.0);

    final macroItems = [
      {'icon': '🥩', 'title': 'Protein', 'value': '${data['protein'].round()} / ${data['proteinTarget']}', 'color': const Color(0xFFFFDDE1), 'progress': proteinProgress},
      {'icon': '💧', 'title': 'Lemak', 'value': '${data['fat'].round()} / ${data['fatTarget']}', 'color': const Color(0xFFFFF7B8), 'progress': fatProgress},
      {'icon': '🌾', 'title': 'Karbohidrat', 'value': '${data['carbs'].round()} / ${data['carbsTarget']}', 'color': const Color(0xFFFFE8C7), 'progress': carbsProgress},
      {'icon': '🌿', 'title': 'Serat', 'value': '${data['fiber'].round()} / ${data['fiberTarget']}', 'color': const Color(0xFFD8F8E4), 'progress': fiberProgress},
    ];

    final mealData = [
      {'title': 'Sarapan', 'subtitle': '300-500 kal', 'icon': '🍳'},
      {'title': 'Makan siang', 'subtitle': '300-600 kal', 'icon': '🥗'},
      {'title': 'Makan malam', 'subtitle': '400-700 kal', 'icon': '🍽️'},
      {'title': 'Camilan', 'subtitle': '100-300 kal', 'icon': '🍎'},
    ];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              _buildDateSelector(),
              const SizedBox(height: 24),
              _buildMacroCards(macroItems),
              const SizedBox(height: 18),
              _buildWeightTracker(),
              const SizedBox(height: 22),
              _buildCalorieCircle(data, calorieProgress),
              const SizedBox(height: 22),
              ...mealData.map((meal) => _buildMealRow(meal)),
              const SizedBox(height: 28),
              _buildAnalysisSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          monthYear,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textDark),
        ),
        Row(
          children: [
            _arrowButton(Icons.chevron_left, onTap: _previousMonth),
            const SizedBox(width: 10),
            _arrowButton(Icons.chevron_right, onTap: _nextMonth),
          ],
        ),
      ],
    );
  }

  Widget _arrowButton(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.grey.shade700, size: 28),
      ),
    );
  }

  Widget _buildDateSelector() {
    final dayNames = ['Kam', 'Jum', 'Sab', 'Min', 'Sen'];
    final weekDates = this.weekDates;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(weekDates.length, (index) {
        final date = weekDates[index];
        final isSelected = date.year == selectedDate.year && 
                           date.month == selectedDate.month && 
                           date.day == selectedDate.day;

        return GestureDetector(
          onTap: () => setState(() => selectedDate = date),
          child: Container(
            width: 64,
            height: 76,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFBDEEFF) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (!isSelected)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dayNames[index], style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                const SizedBox(height: 6),
                Text('${date.day}', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textDark)),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMacroCards(List<Map<String, dynamic>> macroItems) {
    return Row(
      children: List.generate(macroItems.length, (index) {
        final macro = macroItems[index];
        return Expanded(
          child: Container(
            height: 145,
            margin: EdgeInsets.only(right: index == macroItems.length - 1 ? 0 : 8),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: macro['color'] as Color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(macro['icon'] as String, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text(
                  macro['title'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, height: 1.1, color: textDark, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: macro['progress'] as double,
                    minHeight: 4,
                    backgroundColor: Colors.white.withValues(alpha: 0.6),
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  macro['value'] as String,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildWeightTracker() {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showComingSoon('Lacak berat badan'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.monitor_weight_outlined, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            Expanded(
              child: Text('Mulai lacak berat badan Anda', style: TextStyle(fontSize: 15, color: Colors.grey.shade600)),
            ),
            const Icon(Icons.add, color: Colors.blue, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCalorieCircle(Map<String, dynamic> data, double progress) {
    final calories = data['calories'].round();
    final calorieTarget = data['calorieTarget'];
    final burned = data['caloriesBurned'];
    final remaining = (calorieTarget - calories).clamp(0, 9999);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Icon(Icons.info_outline, color: Colors.grey.shade300, size: 22),
          ),
          const SizedBox(height: 6),
          Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE9F8EE)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 205,
                  height: 205,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 11,
                    backgroundColor: Colors.white,
                    color: const Color(0xFF58D68D),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('$calories', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: textDark)),
                    const SizedBox(height: 4),
                    Text(
                      'kalori yang dimakan\nhari ini',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, height: 1.2, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Target: $calorieTarget',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${burned.toStringAsFixed(1)} terbakar\nsejauh ini',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, height: 1.15, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFDDF8E7),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(
              '$remaining kal kekurangan',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF0F9F63), fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealRow(Map<String, dynamic> meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200, width: 3),
            ),
            child: Center(child: Text(meal['icon'] as String, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal['title'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textDark)),
                const SizedBox(height: 4),
                Text(meal['subtitle'] as String, style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _showComingSoon('Tambah ${meal['title']}'),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.add, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSection() {
    final data = _getCurrentData();
    final monthDates = this.monthDates;
    final checkedDays = monthDates.where((date) {
      final key = DateFormat('yyyy-MM-dd').format(date);
      return dataPerTanggal.containsKey(key) && dataPerTanggal[key]!['calories'] > 0;
    }).length;

    final streak = _calculateStreak();
    final monthlyRate = (checkedDays / monthDates.length * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analisis', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textDark)),
        const SizedBox(height: 18),
        _buildCalendarCard(),
        const SizedBox(height: 18),
        Row(
          children: [
            _buildStatCard(
              icon: Icons.check_circle_outline,
              iconColor: primaryGreen,
              title: 'Check-in Bulanan',
              value: '$checkedDays',
              unit: 'hari',
            ),
            const SizedBox(width: 14),
            _buildStatCard(
              icon: Icons.bolt_outlined,
              iconColor: Colors.blue,
              title: 'Total Check-in',
              value: '${dataPerTanggal.length}',
              unit: 'hari',
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _buildStatCard(
              icon: Icons.percent,
              iconColor: Colors.amber,
              title: 'Tingkat Bulanan',
              value: '$monthlyRate',
              unit: '%',
            ),
            const SizedBox(width: 14),
            _buildStatCard(
              icon: Icons.local_fire_department_outlined,
              iconColor: Colors.redAccent,
              title: 'Beruntun',
              value: '$streak',
              unit: 'hari',
            ),
          ],
        ),
        const SizedBox(height: 22),
        _buildMacroBalanceCard(),
      ],
    );
  }

  int _calculateStreak() {
    int streak = 0;
    DateTime checkDate = selectedDate;
    while (true) {
      final key = DateFormat('yyyy-MM-dd').format(checkDate);
      if (dataPerTanggal.containsKey(key) && dataPerTanggal[key]!['calories'] > 0) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  Widget _buildCalendarCard() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final startWeekday = firstDayOfMonth.weekday;
    int offset = startWeekday - 1; // Senin = 1, Minggu = 7
    if (offset < 0) offset = 6;
    
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final List<DateTime?> calendarDays = [];
    
    for (int i = 0; i < offset; i++) {
      calendarDays.add(null);
    }
    for (int i = 1; i <= daysInMonth; i++) {
      calendarDays.add(DateTime(currentMonth.year, currentMonth.month, i));
    }
    while (calendarDays.length % 7 != 0) {
      calendarDays.add(null);
    }

    final weekDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) => 
              SizedBox(
                width: 40,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                ),
              )
            ).toList(),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: calendarDays.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 12,
              crossAxisSpacing: 0,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final date = calendarDays[index];
              if (date == null) {
                return const SizedBox.shrink();
              }
              
              final isSelected = date.year == selectedDate.year && 
                                 date.month == selectedDate.month && 
                                 date.day == selectedDate.day;
              final hasData = dataPerTanggal.containsKey(DateFormat('yyyy-MM-dd').format(date));

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                    if (currentMonth.year != date.year || currentMonth.month != date.month) {
                      currentMonth = DateTime(date.year, date.month);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFFBDEEFF) : Colors.transparent,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (hasData && !isSelected)
                        Positioned(
                          bottom: 2,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                            color: isSelected ? Colors.blue : textDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'Tekan pada tanggal untuk melihat data nutrisi',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
  }) {
    return Expanded(
      child: Container(
        height: 122,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 8),
                Expanded(child: Text(title, style: TextStyle(fontSize: 14, color: textDark, fontWeight: FontWeight.w500))),
              ],
            ),
            const Spacer(),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: value, style: TextStyle(color: textDark, fontSize: 28, fontWeight: FontWeight.w800)),
                    TextSpan(text: ' $unit', style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroBalanceCard() {
    final data = _getCurrentData();
    final proteinProgress = (data['protein'] / data['proteinTarget']).clamp(0.0, 1.0);
    final fatProgress = (data['fat'] / data['fatTarget']).clamp(0.0, 1.0);
    final carbsProgress = (data['carbs'] / data['carbsTarget']).clamp(0.0, 1.0);
    final fiberProgress = (data['fiber'] / data['fiberTarget']).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Keseimbangan Makro Hari Ini', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: Color(0xFF111827))),
          const SizedBox(height: 24),
          _buildMacroProgress(
            icon: '🥩',
            label: 'Protein',
            value: '${data['protein'].round()}g / ${data['proteinTarget']}g',
            progress: proteinProgress,
            color: const Color(0xFFF49BA5),
          ),
          _buildMacroProgress(
            icon: '💧',
            label: 'Lemak',
            value: '${data['fat'].round()}g / ${data['fatTarget']}g',
            progress: fatProgress,
            color: const Color(0xFFF4D23C),
          ),
          _buildMacroProgress(
            icon: '🌾',
            label: 'Karbohidrat',
            value: '${data['carbs'].round()}g / ${data['carbsTarget']}g',
            progress: carbsProgress,
            color: const Color(0xFFF2A65A),
          ),
          _buildMacroProgress(
            icon: '🌿',
            label: 'Serat',
            value: '${data['fiber'].round()}g / ${data['fiberTarget']}g',
            progress: fiberProgress,
            color: const Color(0xFF37C978),
          ),
        ],
      ),
    );
  }

  Widget _buildMacroProgress({
    required String icon,
    required String label,
    required String value,
    required double progress,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Text(label, style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              const Spacer(),
              Text(value, style: TextStyle(fontSize: 16, color: textDark, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: color.withValues(alpha: 0.18),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}