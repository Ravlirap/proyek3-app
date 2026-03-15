import 'package:flutter/foundation.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _userName = '';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get userEmail => _userEmail;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1200));

    _isLoggedIn = true;
    _userEmail = email;
    _userName = email.split('@').first;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    notifyListeners();
  }
}
