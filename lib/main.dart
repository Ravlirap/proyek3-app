import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/utils/app_localizations.dart';
import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/nutrition_provider.dart';
import 'providers/scan_provider.dart';
import 'providers/language_provider.dart';

import 'screens/splash/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/scan/scan_screen.dart';
import 'screens/scan/analysis_result_screen.dart';
import 'screens/meal_plan/meal_plan_screen.dart';
import 'screens/home/recommendation_detail_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const GoHealthApp());
}

class GoHealthApp extends StatelessWidget {
  const GoHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NutritionProvider()),
        ChangeNotifierProvider(create: (_) => ScanProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            locale: languageProvider.locale,
            supportedLocales: const [
              Locale('id', 'ID'),
              Locale('en', 'US'),
              Locale('zh', 'CN'),
              Locale('ja', 'JP'),
            ],
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            initialRoute: AppConstants.splashRoute,
            routes: {
              AppConstants.splashRoute: (_) => const SplashScreen(),
              AppConstants.loginRoute: (_) => const LoginScreen(),
              AppConstants.registerRoute: (_) => const RegisterScreen(),
              AppConstants.onboardingRoute: (_) => const OnboardingScreen(),
              AppConstants.homeRoute: (_) => const HomeScreen(),
              AppConstants.scanRoute: (_) => const ScanScreen(),
              AppConstants.analysisResultRoute: (_) =>
                  const AnalysisResultScreen(),
              AppConstants.mealPlanRoute: (_) => const MealPlanScreen(),
              AppConstants.recommendationRoute: (_) => const RecommendationDetailScreen(),
            },
          );
        },
      ),
    );
  }
}