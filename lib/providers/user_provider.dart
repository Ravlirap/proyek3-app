import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String _name = '';
  String _email = '';
  DateTime? _dateOfBirth;
  double _heightCm = 170.0;
  double _weightKg = 65.0;
  int _calorieTarget = 2000;
  int _onboardingStep = 0;
  bool _onboardingComplete = false;

  String get name => _name;
  String get email => _email;
  DateTime? get dateOfBirth => _dateOfBirth;
  double get heightCm => _heightCm;
  double get weightKg => _weightKg;
  int get calorieTarget => _calorieTarget;
  int get onboardingStep => _onboardingStep;
  bool get onboardingComplete => _onboardingComplete;

  int get age {
    if (_dateOfBirth == null) return 0;
    final now = DateTime.now();
    int years = now.year - _dateOfBirth!.year;
    if (now.month < _dateOfBirth!.month ||
        (now.month == _dateOfBirth!.month && now.day < _dateOfBirth!.day)) {
      years--;
    }
    return years;
  }

  double get bmi {
    if (_heightCm <= 0) return 0;
    final heightM = _heightCm / 100;
    return _weightKg / (heightM * heightM);
  }

  String get bmiCategory {
    final b = bmi;
    if (b < 18.5) return 'Kurus';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Berlebih';
    return 'Obesitas';
  }

  void setName(String val) {
    _name = val;
    notifyListeners();
  }

  void setEmail(String val) {
    _email = val;
    notifyListeners();
  }

  void setDateOfBirth(DateTime dob) {
    _dateOfBirth = dob;
    notifyListeners();
  }

  void setHeight(double height) {
    _heightCm = height;
    _recalculateCalories();
    notifyListeners();
  }

  void setWeight(double weight) {
    _weightKg = weight;
    _recalculateCalories();
    notifyListeners();
  }

  void nextStep() {
    if (_onboardingStep < 2) {
      _onboardingStep++;
      notifyListeners();
    }
  }

  void prevStep() {
    if (_onboardingStep > 0) {
      _onboardingStep--;
      notifyListeners();
    }
  }

  void completeOnboarding() {
    _onboardingComplete = true;
    notifyListeners();
  }

  void _recalculateCalories() {
    // Simple Mifflin-St Jeor estimate (sedentary activity)
    _calorieTarget = (10 * _weightKg + 6.25 * _heightCm - 5 * age + 5).round();
    if (_calorieTarget < 1200) _calorieTarget = 1200;
    if (_calorieTarget > 4000) _calorieTarget = 4000;
  }
}
