class AppConstants {
  // App info
  static const String appName = 'GoHealth';
  static const String appTagline = 'Smart Food AI for a Healthier Life';

  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String onboardingRoute = '/onboarding';
  static const String homeRoute = '/home';
  static const String scanRoute = '/scan';
  static const String analysisResultRoute = '/analysis-result';
  static const String mealPlanRoute = '/meal-plan';

  // Default values
  static const int defaultCalorieTarget = 2000;
  static const double defaultHeight = 170.0;
  static const double defaultWeight = 65.0;

  // Fake food detection results
  static const List<Map<String, dynamic>> fakeFoodResults = [
    {
      'name': 'Nasi Goreng',
      'confidence': 94.7,
      'calories': 520,
      'carbs': 68.0,
      'protein': 14.5,
      'fat': 18.2,
      'fiber': 2.1,
      'sugar': 4.3,
      'imageEmoji': '🍳',
      'description': 'Nasi goreng khas Indonesia dengan bumbu rempah pilihan.',
    },
    {
      'name': 'Gado-Gado',
      'confidence': 91.2,
      'calories': 320,
      'carbs': 35.0,
      'protein': 16.0,
      'fat': 12.5,
      'fiber': 6.2,
      'sugar': 8.1,
      'imageEmoji': '🥗',
      'description': 'Salad khas Indonesia dengan saus kacang yang lezat.',
    },
    {
      'name': 'Ayam Bakar',
      'confidence': 97.3,
      'calories': 280,
      'carbs': 8.0,
      'protein': 32.0,
      'fat': 13.5,
      'fiber': 0.8,
      'sugar': 5.2,
      'imageEmoji': '🍗',
      'description': 'Ayam bakar dengan bumbu kecap manis dan rempah pilihan.',
    },
  ];

  // Meal plan data
  static const List<Map<String, dynamic>> breakfastMenu = [
    {'name': 'Oatmeal Berry Bowl', 'calories': 320, 'icon': '🥣'},
    {'name': 'Telur Rebus (2 butir)', 'calories': 140, 'icon': '🥚'},
    {'name': 'Jus Jeruk Segar', 'calories': 90, 'icon': '🍊'},
  ];

  static const List<Map<String, dynamic>> lunchMenu = [
    {'name': 'Nasi Merah (150g)', 'calories': 210, 'icon': '🍚'},
    {'name': 'Ayam Panggang', 'calories': 250, 'icon': '🍗'},
    {'name': 'Sayur Bayam', 'calories': 80, 'icon': '🥬'},
  ];

  static const List<Map<String, dynamic>> snackMenu = [
    {'name': 'Greek Yogurt', 'calories': 130, 'icon': '🫙'},
    {'name': 'Almond (30g)', 'calories': 170, 'icon': '🌰'},
  ];

  static const List<Map<String, dynamic>> dinnerMenu = [
    {'name': 'Ikan Salmon Bakar', 'calories': 300, 'icon': '🐟'},
    {'name': 'Quinoa (100g)', 'calories': 180, 'icon': '🌾'},
    {'name': 'Salad Sayuran', 'calories': 75, 'icon': '🥗'},
  ];
}
