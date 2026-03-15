import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/history_tab.dart';
import 'tabs/report_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    DashboardTab(),
    HistoryTab(),
    SizedBox(), // Scan is handled separately
    ReportTab(),
    ProfileTab(),
  ];

  void _onTabTapped(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, AppConstants.scanRoute);
      return;
    }
    setState(() => _currentIndex = (index > 2) ? index - 1 : index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _tabs[0],
          _tabs[1],
          _tabs[3],
          _tabs[4],
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  index: 0,
                  currentIndex: _currentIndex,
                  onTap: () => _onTabTapped(0),
                ),
                _NavItem(
                  icon: Icons.history_rounded,
                  label: 'Riwayat',
                  index: 1,
                  currentIndex: _currentIndex,
                  onTap: () => _onTabTapped(1),
                ),
                // Center Scan button
                GestureDetector(
                  onTap: () => _onTabTapped(2),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryGreen.withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                _NavItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'Laporan',
                  index: 3,
                  currentIndex: _currentIndex,
                  onTap: () => _onTabTapped(3),
                ),
                _NavItem(
                  icon: Icons.person_rounded,
                  label: 'Profil',
                  index: 4,
                  currentIndex: _currentIndex,
                  onTap: () => _onTabTapped(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  bool get _isSelected {
    final normalizedIdx = index > 2 ? index - 1 : index;
    return normalizedIdx == currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _isSelected
              ? AppTheme.primaryGreen.withOpacity(0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: _isSelected ? AppTheme.primaryGreen : AppTheme.textHint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: _isSelected ? AppTheme.primaryGreen : AppTheme.textHint,
                fontSize: 10,
                fontWeight: _isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
