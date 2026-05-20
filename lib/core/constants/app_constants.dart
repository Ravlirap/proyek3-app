class AppConstants {
  static const String appName = 'GoHealth';
  static const String appTagline = 'Smart Food AI';
  static const String apiUrl = 'https://your-api-url.com';
  
  // Routes
  static const String splashRoute = '/';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String onboardingRoute = '/onboarding';
  static const String onboardingDateRoute = '/onboarding-date';
  static const String onboardingHeightRoute = '/onboarding-height';
  static const String onboardingWeightRoute = '/onboarding-weight';
  static const String homeRoute = '/home';
  static const String scanRoute = '/scan';
  static const String analysisResultRoute = '/analysis-result';
  static const String mealPlanRoute = '/meal-plan';
  static const String recommendationRoute = '/recommendation';
  
  // Menu Data
  static final List<Map<String, dynamic>> breakfastMenu = [
    {'name': 'Oatmeal with Berries', 'calories': 320, 'protein': 12, 'carbs': 48, 'fat': 8, 'time': '15 min'},
    {'name': 'Greek Yogurt Parfait', 'calories': 280, 'protein': 18, 'carbs': 35, 'fat': 6, 'time': '10 min'},
    {'name': 'Avocado Toast', 'calories': 350, 'protein': 10, 'carbs': 30, 'fat': 22, 'time': '10 min'},
    {'name': 'Smoothie Bowl', 'calories': 300, 'protein': 8, 'carbs': 50, 'fat': 7, 'time': '15 min'},
  ];
  
  static final List<Map<String, dynamic>> lunchMenu = [
    {'name': 'Grilled Chicken Salad', 'calories': 420, 'protein': 35, 'carbs': 20, 'fat': 18, 'time': '20 min'},
    {'name': 'Quinoa Bowl', 'calories': 450, 'protein': 15, 'carbs': 60, 'fat': 12, 'time': '25 min'},
    {'name': 'Nasi Goreng Sehat', 'calories': 380, 'protein': 12, 'carbs': 55, 'fat': 10, 'time': '20 min'},
    {'name': 'Soto Ayam', 'calories': 350, 'protein': 20, 'carbs': 40, 'fat': 8, 'time': '30 min'},
  ];
  
  static final List<Map<String, dynamic>> snackMenu = [
    {'name': 'Apple with Peanut Butter', 'calories': 180, 'protein': 5, 'carbs': 20, 'fat': 9, 'time': '5 min'},
    {'name': 'Handful of Almonds', 'calories': 160, 'protein': 6, 'carbs': 6, 'fat': 14, 'time': '2 min'},
    {'name': 'Protein Bar', 'calories': 200, 'protein': 12, 'carbs': 22, 'fat': 8, 'time': '2 min'},
    {'name': 'Hummus with Veggies', 'calories': 150, 'protein': 4, 'carbs': 15, 'fat': 8, 'time': '10 min'},
  ];
  
  static final List<Map<String, dynamic>> dinnerMenu = [
    {'name': 'Salmon with Vegetables', 'calories': 520, 'protein': 40, 'carbs': 25, 'fat': 28, 'time': '35 min'},
    {'name': 'Chicken Stir Fry', 'calories': 480, 'protein': 35, 'carbs': 30, 'fat': 15, 'time': '25 min'},
    {'name': 'Pasta with Tomato Sauce', 'calories': 450, 'protein': 14, 'carbs': 65, 'fat': 12, 'time': '25 min'},
    {'name': 'Tofu Curry', 'calories': 400, 'protein': 18, 'carbs': 45, 'fat': 16, 'time': '30 min'},
  ];
  
  // Fake food data for scan
  static final List<Map<String, dynamic>> fakeFoodResults = [
    {'name': 'Mie Ayam', 'calories': 420, 'protein': 10, 'carbs': 55, 'fat': 14, 'confidence': 0.95},
    {'name': 'Nasi Goreng', 'calories': 450, 'carbs': 65, 'protein': 12, 'fat': 15, 'confidence': 0.95},
    {'name': 'Sate Ayam', 'calories': 350, 'carbs': 25, 'protein': 28, 'fat': 18, 'confidence': 0.92},
    {'name': 'Gado-gado', 'calories': 380, 'carbs': 40, 'protein': 10, 'fat': 20, 'confidence': 0.88},
    {'name': 'Bakso', 'calories': 320, 'carbs': 45, 'protein': 15, 'fat': 10, 'confidence': 0.90},
  ];
}