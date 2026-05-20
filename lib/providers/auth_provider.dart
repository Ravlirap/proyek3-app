import 'package:flutter/material.dart';
import '../core/services/auth_service.dart';
import 'user_provider.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _userData;
  bool _isAuthenticated = false;
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get userData => _userData;
  bool get isAuthenticated => _isAuthenticated;
  
  Future<bool> login(String email, String password, UserProvider userProvider) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.login(email, password);
      _userData = result;
      _isAuthenticated = true;
      
      if (result['user'] != null) {
        userProvider.setUserProfile(result['user']);
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      debugPrint('Login error in provider: $e');
      return false;
    }
  }
  
  Future<bool> register(String name, String email, String password, UserProvider userProvider) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.register(name, email, password);
      _userData = result;
      _isAuthenticated = true;
      
      if (result['user'] != null) {
        userProvider.setUserProfile(result['user']);
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      debugPrint('Register error in provider: $e');
      return false;
    }
  }
  
  Future<bool> signInWithGoogle(UserProvider userProvider) async {
    _setLoading(true);
    _clearError();
    
    try {
      final result = await _authService.signInWithGoogle();
      _userData = result;
      _isAuthenticated = true;
      
      if (result['user'] != null) {
        userProvider.setUserProfile(result['user']);
        debugPrint('User saved: ${result['user']['name']} - ${result['user']['email']}');
      }
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      debugPrint('Google sign in error in provider: $e');
      return false;
    }
  }
  
  Future<void> logout(UserProvider userProvider) async {
    _setLoading(true);
    
    try {
      await _authService.signOut();
      _userData = null;
      _isAuthenticated = false;
      _errorMessage = null;
      userProvider.clearUserProfile();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      debugPrint('Logout error: $e');
    }
  }
  
  void _clearError() {
    _errorMessage = null;
  }
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  Future<void> checkAuthStatus() async {
    final isLoggedIn = _authService.isLoggedIn();
    _isAuthenticated = isLoggedIn;
    notifyListeners();
  }
}