import 'package:flutter/foundation.dart';

class MealLog {
  final String name;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;
  final DateTime time;
  final String mealType;

  MealLog({
    required this.name,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.time,
    required this.mealType,
  });
}

class NutritionProvider with ChangeNotifier {
  int _calorieTarget = 2000;
  double _consumedCalories = 740;
  double _carbsConsumed = 85;
  double _proteinConsumed = 42;
  double _fatConsumed = 22;

  final List<MealLog> _mealLogs = [
    MealLog(
      name: 'Oatmeal Berry Bowl',
      calories: 320,
      carbs: 48,
      protein: 12,
      fat: 8,
      time: DateTime.now().subtract(const Duration(hours: 5)),
      mealType: 'Breakfast',
    ),
    MealLog(
      name: 'Greek Yogurt',
      calories: 130,
      carbs: 14,
      protein: 17,
      fat: 2,
      time: DateTime.now().subtract(const Duration(hours: 3)),
      mealType: 'Snack',
    ),
    MealLog(
      name: 'Telur Rebus',
      calories: 140,
      carbs: 2,
      protein: 12,
      fat: 10,
      time: DateTime.now().subtract(const Duration(hours: 5, minutes: 30)),
      mealType: 'Breakfast',
    ),
    MealLog(
      name: 'Almond',
      calories: 150,
      carbs: 5,
      protein: 5,
      fat: 13,
      time: DateTime.now().subtract(const Duration(hours: 1)),
      mealType: 'Snack',
    ),
  ];

  int get calorieTarget => _calorieTarget;
  double get consumedCalories => _consumedCalories;
  double get remainingCalories =>
      (_calorieTarget - _consumedCalories).clamp(0, double.infinity);
  double get progress =>
      (_consumedCalories / _calorieTarget).clamp(0.0, 1.0);
  double get carbsConsumed => _carbsConsumed;
  double get proteinConsumed => _proteinConsumed;
  double get fatConsumed => _fatConsumed;
  List<MealLog> get mealLogs => List.unmodifiable(_mealLogs);

  // Macro targets
  double get carbsTarget => _calorieTarget * 0.50 / 4;
  double get proteinTarget => _calorieTarget * 0.25 / 4;
  double get fatTarget => _calorieTarget * 0.25 / 9;

  void setCalorieTarget(int target) {
    _calorieTarget = target;
    notifyListeners();
  }

  void addMeal({
    required String name,
    required double calories,
    required double carbs,
    required double protein,
    required double fat,
    required String mealType,
  }) {
    _mealLogs.add(MealLog(
      name: name,
      calories: calories,
      carbs: carbs,
      protein: protein,
      fat: fat,
      time: DateTime.now(),
      mealType: mealType,
    ));
    _consumedCalories += calories;
    _carbsConsumed += carbs;
    _proteinConsumed += protein;
    _fatConsumed += fat;
    notifyListeners();
  }

  Map<String, List<MealLog>> get logsByType {
    final map = <String, List<MealLog>>{};
    for (final log in _mealLogs) {
      map.putIfAbsent(log.mealType, () => []).add(log);
    }
    return map;
  }
}
