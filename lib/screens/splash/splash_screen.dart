import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/custom_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Logo area
                FadeInDown(
                  duration: const Duration(milliseconds: 700),
                  child: AnimatedBuilder(
                    animation: _pulseAnim,
                    builder: (_, child) => Transform.scale(
                      scale: _pulseAnim.value,
                      child: child,
                    ),
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryGreen.withOpacity(0.5),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.eco_rounded,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    AppConstants.appName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInUp(
                  delay: const Duration(milliseconds: 500),
                  duration: const Duration(milliseconds: 700),
                  child: Text(
                    AppConstants.appTagline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                // Feature pills
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _FeaturePill(icon: Icons.camera_alt_rounded, label: 'AI Scan'),
                      _FeaturePill(icon: Icons.restaurant_menu_rounded, label: 'Meal Plan'),
                      _FeaturePill(icon: Icons.analytics_rounded, label: 'Nutrisi'),
                      _FeaturePill(icon: Icons.track_changes_rounded, label: 'Kalori'),
                    ],
                  ),
                ),
                const Spacer(),
                FadeInUp(
                  delay: const Duration(milliseconds: 800),
                  duration: const Duration(milliseconds: 600),
                  child: CustomButton(
                    text: 'Mulai Sekarang',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppConstants.registerRoute),
                  ),
                ),
                const SizedBox(height: 16),
                FadeInUp(
                  delay: const Duration(milliseconds: 950),
                  duration: const Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, AppConstants.loginRoute),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: AppTheme.primaryGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
