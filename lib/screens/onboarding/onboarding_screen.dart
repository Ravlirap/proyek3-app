import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/user_provider.dart';
import '../../providers/nutrition_provider.dart';
import '../../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  DateTime? _selectedDate;
  double _height = 170;
  double _weight = 65;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final user = context.read<UserProvider>();
    if (user.onboardingStep < 2) {
      user.nextStep();
      _pageController.animateToPage(
        user.onboardingStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _prevPage() {
    final user = context.read<UserProvider>();
    if (user.onboardingStep > 0) {
      user.prevStep();
      _pageController.animateToPage(
        user.onboardingStep,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finish() {
    final user = context.read<UserProvider>();
    user.completeOnboarding();
    context.read<NutritionProvider>().setCalorieTarget(user.calorieTarget);
    Navigator.pushReplacementNamed(context, AppConstants.homeRoute);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime(now.year - 10),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppTheme.primaryGreen,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
      context.read<UserProvider>().setDateOfBirth(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  if (user.onboardingStep > 0)
                    GestureDetector(
                      onTap: _prevPage,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_rounded,
                            color: AppTheme.darkGreen, size: 20),
                      ),
                    )
                  else
                    const SizedBox(width: 40),
                  const Spacer(),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppTheme.primaryGreen,
                      dotColor: AppTheme.lightGreen,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _finish,
                    child: const Text(
                      'Lewati',
                      style: TextStyle(
                        color: AppTheme.textHint,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _StepDOB(
                    selectedDate: _selectedDate,
                    onPickDate: _pickDate,
                  ),
                  _StepHeight(
                    value: _height,
                    onChanged: (v) {
                      setState(() => _height = v);
                      context.read<UserProvider>().setHeight(v);
                    },
                  ),
                  _StepWeight(
                    value: _weight,
                    onChanged: (v) {
                      setState(() => _weight = v);
                      context.read<UserProvider>().setWeight(v);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 36),
              child: CustomButton(
                text: user.onboardingStep < 2 ? 'Lanjut' : 'Selesai',
                icon: user.onboardingStep < 2
                    ? Icons.arrow_forward_rounded
                    : Icons.check_circle_rounded,
                onPressed: _nextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepDOB extends StatelessWidget {
  final DateTime? selectedDate;
  final VoidCallback onPickDate;

  const _StepDOB({this.selectedDate, required this.onPickDate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        children: [
          FadeInDown(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cake_rounded, color: Colors.white, size: 50),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Tanggal Lahir Anda?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Kami gunakan untuk menghitung\nkebutuhan kalori harian Anda',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 36),
          GestureDetector(
            onTap: onPickDate,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: selectedDate != null
                    ? AppTheme.lightGreen
                    : const Color(0xFFF0F7F3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selectedDate != null
                      ? AppTheme.primaryGreen
                      : AppTheme.divider,
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: selectedDate != null
                          ? AppTheme.primaryGreen
                          : AppTheme.lightGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.calendar_today_rounded,
                      color: selectedDate != null
                          ? Colors.white
                          : AppTheme.darkGreen,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tanggal Lahir',
                        style: TextStyle(
                            color: AppTheme.textSecondary, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedDate != null
                            ? DateFormat('dd MMMM yyyy', 'id')
                                .format(selectedDate!)
                            : 'Pilih tanggal...',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: selectedDate != null
                              ? AppTheme.textPrimary
                              : AppTheme.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepHeight extends StatelessWidget {
  final double value;
  final void Function(double) onChanged;

  const _StepHeight({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        children: [
          FadeInDown(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.height_rounded, color: Colors.white, size: 50),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Berapa Tinggi Anda?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tinggi badan membantu kami\nmenghitung BMI dan kebutuhan nutrisi',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.6),
          ),
          const Spacer(),
          Text(
            '${value.round()} cm',
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryGreen,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryGreen,
              inactiveTrackColor: AppTheme.lightGreen,
              thumbColor: AppTheme.primaryGreen,
              overlayColor: AppTheme.primaryGreen.withOpacity(0.15),
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 14),
              trackHeight: 6,
            ),
            child: Slider(
              value: value,
              min: 130,
              max: 220,
              divisions: 90,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('130 cm',
                  style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
              Text('220 cm',
                  style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _StepWeight extends StatelessWidget {
  final double value;
  final void Function(double) onChanged;

  const _StepWeight({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: Column(
        children: [
          FadeInDown(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.monitor_weight_rounded,
                  color: Colors.white, size: 50),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Berapa Berat Anda?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Berat badan digunakan untuk menghitung\nkalori yang ideal untuk Anda',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 14, height: 1.6),
          ),
          const Spacer(),
          Text(
            '${value.round()} kg',
            style: const TextStyle(
              fontSize: 52,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryGreen,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryGreen,
              inactiveTrackColor: AppTheme.lightGreen,
              thumbColor: AppTheme.primaryGreen,
              overlayColor: AppTheme.primaryGreen.withOpacity(0.15),
              thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 14),
              trackHeight: 6,
            ),
            child: Slider(
              value: value,
              min: 30,
              max: 150,
              divisions: 120,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('30 kg',
                  style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
              Text('150 kg',
                  style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
