import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/nutrition_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();
    final nutrition = context.watch<NutritionProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              decoration: const BoxDecoration(
                gradient: AppTheme.darkGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30, width: 3),
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 48),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    user.name.isEmpty ? 'GoHealth User' : user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email.isEmpty ? 'user@gohealth.ai' : user.email,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 20),
                  // Stats row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ProfileStat(
                        label: 'Tinggi',
                        value: '${user.heightCm.round()} cm',
                      ),
                      _ProfileStat(
                        label: 'BMI',
                        value: user.bmi > 0
                            ? user.bmi.toStringAsFixed(1)
                            : '21.4',
                        sub: user.bmi > 0 ? user.bmiCategory : 'Normal',
                        subColor: AppTheme.primaryGreen,
                      ),
                      _ProfileStat(
                        label: 'Berat',
                        value: '${user.weightKg.round()} kg',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _SectionTitle('Kesehatan'),
                  _MenuItem(
                    icon: Icons.track_changes_rounded,
                    label: 'Target Kalori Harian',
                    trailing:
                        '${nutrition.calorieTarget} kal',
                    iconColor: AppTheme.primaryGreen,
                  ),
                  _MenuItem(
                    icon: Icons.monitor_weight_rounded,
                    label: 'Berat Badan',
                    trailing: '${user.weightKg.round()} kg',
                    iconColor: AppTheme.carbColor,
                  ),
                  _MenuItem(
                    icon: Icons.height_rounded,
                    label: 'Tinggi Badan',
                    trailing: '${user.heightCm.round()} cm',
                    iconColor: AppTheme.proteinColor,
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle('Pengaturan'),
                  _MenuItem(
                    icon: Icons.notifications_rounded,
                    label: 'Notifikasi',
                    iconColor: AppTheme.fatColor,
                  ),
                  _MenuItem(
                    icon: Icons.language_rounded,
                    label: 'Bahasa',
                    trailing: 'Indonesia',
                    iconColor: const Color(0xFF3498DB),
                  ),
                  _MenuItem(
                    icon: Icons.privacy_tip_rounded,
                    label: 'Kebijakan Privasi',
                    iconColor: AppTheme.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Keluar',
                    iconColor: Colors.red.shade400,
                    textColor: Colors.red.shade400,
                    showArrow: false,
                    onTap: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (r) => false,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'GoHealth v1.0.0 • Smart Food AI',
                    style: TextStyle(
                      color: AppTheme.textHint,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final Color? subColor;

  const _ProfileStat({required this.label, required this.value, this.sub, this.subColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
        if (sub != null)
          Text(sub!,
              style: TextStyle(
                  color: subColor ?? Colors.white54, fontSize: 12)),
        Text(label,
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppTheme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  final Color iconColor;
  final Color? textColor;
  final bool showArrow;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.trailing,
    required this.iconColor,
    this.textColor,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor ?? AppTheme.textPrimary,
                ),
              ),
            ),
            if (trailing != null)
              Text(trailing!,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  )),
            if (showArrow) ...[
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right_rounded,
                  color: AppTheme.textHint, size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
