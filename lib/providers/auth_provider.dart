import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/models/user_model.dart';
import '../core/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _token;
  UserModel? _user;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    loadSession();
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();

    final savedToken = prefs.getString('auth_token');
    final savedUserId = prefs.getInt('user_id');
    final savedName = prefs.getString('user_name');
    final savedEmail = prefs.getString('user_email');
    final savedSource = prefs.getString('user_source');

    if (savedToken != null &&
        savedUserId != null &&
        savedName != null &&
        savedEmail != null) {
      _token = savedToken;
      _user = UserModel(
        id: savedUserId,
        name: savedName,
        email: savedEmail,
        source: savedSource,
      );
      _isLoggedIn = true;
    }

    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _authService.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: password,
      );

      final token = response['token'] as String?;
      final userJson = response['user'] as Map<String, dynamic>?;

      if (token == null || userJson == null) {
        throw Exception('Response register tidak valid');
      }

      final user = _authService.parseUser(userJson);

      await _saveSession(token, user);

      _token = token;
      _user = user;
      _isLoggedIn = true;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      final token = response['token'] as String?;
      final userJson = response['user'] as Map<String, dynamic>?;

      if (token == null || userJson == null) {
        throw Exception('Response login tidak valid');
      }

      final user = _authService.parseUser(userJson);

      await _saveSession(token, user);

      _token = token;
      _user = user;
      _isLoggedIn = true;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);

    try {
      if (_token != null) {
        await _authService.logout(_token!);
      }
    } catch (_) {
      // abaikan error logout server, tetap hapus session lokal
    } finally {
      await _clearSession();
      _token = null;
      _user = null;
      _isLoggedIn = false;
      _errorMessage = null;
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> _saveSession(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setInt('user_id', user.id);
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    if (user.source != null) {
      await prefs.setString('user_source', user.source!);
    }
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    await prefs.remove('user_source');
  }
}
