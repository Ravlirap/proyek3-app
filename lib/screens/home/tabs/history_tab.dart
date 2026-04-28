// lib/screens/tabs/history_tab.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  DateTime selectedDate = DateTime(2026, 4, 27);

  final Color primaryGreen = const Color(0xFF00A86B);
  final Color textDark = const Color(0xFF111827);
  final Color bgColor = const Color(0xFFF8F9FB);

  final List<Map<String, dynamic>> macroData = [
    {'icon': '🥩', 'title': 'Protein', 'value': '0 / 135', 'color': Color(0xFFFFDDE1)},
    {'icon': '💧', 'title': 'Lemak', 'value': '0 / 50', 'color': Color(0xFFFFF7B8)},
    {'icon': '🌾', 'title': 'Karbohidrat', 'value': '0 / 203', 'color': Color(0xFFFFE8C7)},
    {'icon': '🌿', 'title': 'Serat', 'value': '0 / 25', 'color': Color(0xFFD8F8E4)},
  ];

  final List<Map<String, dynamic>> mealData = [
    {'title': 'Sarapan', 'subtitle': '300-500 kal', 'icon': '🍳'},
    {'title': 'Makan siang', 'subtitle': '300-600 kal', 'icon': '🥗'},
    {'title': 'Makan malam', 'subtitle': '400-700 kal', 'icon': '🍽️'},
    {'title': 'Camilan', 'subtitle': '100-300 kal', 'icon': '🍎'},
  ];

  List<DateTime> get weekDates => [
        DateTime(2026, 4, 23),
        DateTime(2026, 4, 24),
        DateTime(2026, 4, 25),
        DateTime(2026, 4, 26),
        DateTime(2026, 4, 27),
      ];

  @override
  Widget build(BuildContext context) {
    final monthYear = DateFormat('MMMM yyyy', 'id_ID').format(selectedDate);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(monthYear),
              const SizedBox(height: 22),
              _buildDateSelector(),
              const SizedBox(height: 24),
              _buildMacroCards(),
              const SizedBox(height: 18),
              _buildWeightTracker(),
              const SizedBox(height: 22),
              _buildCalorieCircle(),
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

  Widget _buildHeader(String monthYear) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          monthYear,
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textDark),
        ),
        Row(
          children: [
            _arrowButton(Icons.chevron_left),
            const SizedBox(width: 10),
            _arrowButton(Icons.chevron_right, disabled: true),
          ],
        ),
      ],
    );
  }

  Widget _arrowButton(IconData icon, {bool disabled = false}) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: disabled
          ? null
          : () {
              setState(() {
                selectedDate = DateTime(selectedDate.year, selectedDate.month - 1, selectedDate.day);
              });
            },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Icon(icon, color: disabled ? Colors.grey.shade300 : Colors.grey.shade700, size: 28),
      ),
    );
  }

  Widget _buildDateSelector() {
    final dayNames = ['Kam', 'Jum', 'Sab', 'Min', 'Sen'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(weekDates.length, (index) {
        final date = weekDates[index];
        final isSelected = date.day == selectedDate.day;

        return GestureDetector(
          onTap: () => setState(() => selectedDate = date),
          child: Container(
            width: 64,
            height: 76,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFBDEEFF) : Colors.white,
              borderRadius: BorderRadius.circular(16),
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

  Widget _buildMacroCards() {
    return Row(
      children: List.generate(macroData.length, (index) {
        final macro = macroData[index];

        return Expanded(
          child: Container(
            height: 145,
            margin: EdgeInsets.only(right: index == macroData.length - 1 ? 0 : 8),
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
                Container(
                  height: 4,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(20)),
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

  Widget _buildCalorieCircle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
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
                    value: 0.73,
                    strokeWidth: 11,
                    backgroundColor: Colors.white,
                    color: Color(0xFF58D68D),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('0', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: textDark)),
                    const SizedBox(height: 4),
                    Text(
                      'kalori yang dimakan\nhari ini',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, height: 1.2, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Target: 1800',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '1316.4 terbakar\nsejauh ini',
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
            decoration: BoxDecoration(color: const Color(0xFFDDF8E7), borderRadius: BorderRadius.circular(22)),
            child: const Text(
              '1316.4 kal kekurangan',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Color(0xFF0F9F63), fontSize: 13, fontWeight: FontWeight.w800),
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
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200, width: 3)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analisis', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: textDark)),
        const SizedBox(height: 18),
        _buildCalendarCard(),
        const SizedBox(height: 18),
        Row(
          children: [
            _buildStatCard(icon: Icons.check_circle_outline, iconColor: primaryGreen, title: 'Check-in Bulanan', value: '0', unit: 'hari'),
            const SizedBox(width: 14),
            _buildStatCard(icon: Icons.bolt_outlined, iconColor: Colors.blue, title: 'Total Check-in', value: '1', unit: 'hari'),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _buildStatCard(icon: Icons.percent, iconColor: Colors.amber, title: 'Tingkat Bulanan', value: '0', unit: '%'),
            const SizedBox(width: 14),
            _buildStatCard(icon: Icons.local_fire_department_outlined, iconColor: Colors.redAccent, title: 'Beruntun', value: '0', unit: 'hari'),
          ],
        ),
        const SizedBox(height: 22),
        _buildMacroBalanceCard(),
      ],
    );
  }

  Widget _buildCalendarCard() {
    final days = [13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 14, crossAxisSpacing: 10),
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = day == selectedDate.day;

              return InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () => setState(() => selectedDate = DateTime(2026, 4, day)),
                child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? const Color(0xFFEAF4FF) : Colors.transparent),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected ? Colors.blue : textDark,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 18),
          Text(
            'Tekan lama atau ketuk dua kali pada hari dengan data nutrisi untuk melihat detail.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500, height: 1.4),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Keseimbangan Makro Hari Ini', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: textDark)),
          const SizedBox(height: 24),
          _buildMacroProgress(icon: '🥩', label: 'Protein', value: '0g / 135g', color: const Color(0xFFF49BA5)),
          _buildMacroProgress(icon: '💧', label: 'Lemak', value: '0g / 50g', color: const Color(0xFFF4D23C)),
          _buildMacroProgress(icon: '🌾', label: 'Karbohidrat', value: '0g / 203g', color: const Color(0xFFF2A65A)),
          _buildMacroProgress(icon: '🌿', label: 'Serat', value: '0g / 25g', color: const Color(0xFF37C978)),
        ],
      ),
    );
  }

  Widget _buildMacroProgress({
    required String icon,
    required String label,
    required String value,
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
            child: LinearProgressIndicator(value: 0, minHeight: 8, backgroundColor: color.withOpacity(0.18), color: color),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating),
    );
  }
}