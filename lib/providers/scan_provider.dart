import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';

class ScanProvider with ChangeNotifier {
  bool _isScanning = false;
  bool _hasResult = false;
  Map<String, dynamic>? _detectionResult;
  double _portionMultiplier = 1.0;

  bool get isScanning => _isScanning;
  bool get hasResult => _hasResult;
  Map<String, dynamic>? get detectionResult => _detectionResult;
  double get portionMultiplier => _portionMultiplier;

  double get adjustedCalories {
    if (_detectionResult == null) return 0;
    return (_detectionResult!['calories'] as num).toDouble() * _portionMultiplier;
  }

  double get adjustedCarbs {
    if (_detectionResult == null) return 0;
    return (_detectionResult!['carbs'] as num).toDouble() * _portionMultiplier;
  }

  double get adjustedProtein {
    if (_detectionResult == null) return 0;
    return (_detectionResult!['protein'] as num).toDouble() * _portionMultiplier;
  }

  double get adjustedFat {
    if (_detectionResult == null) return 0;
    return (_detectionResult!['fat'] as num).toDouble() * _portionMultiplier;
  }

  Future<void> startScan() async {
    _isScanning = true;
    _hasResult = false;
    _detectionResult = null;
    _portionMultiplier = 1.0;
    notifyListeners();

    // Simulate AI detection delay
    await Future.delayed(const Duration(seconds: 3));

    // Pick a random result
    final results = AppConstants.fakeFoodResults;
    final index = DateTime.now().millisecond % results.length;
    _detectionResult = Map<String, dynamic>.from(results[index]);

    _isScanning = false;
    _hasResult = true;
    notifyListeners();
  }

  void setPortion(double multiplier) {
    _portionMultiplier = multiplier;
    notifyListeners();
  }

  void reset() {
    _isScanning = false;
    _hasResult = false;
    _detectionResult = null;
    _portionMultiplier = 1.0;
    notifyListeners();
  }
}
