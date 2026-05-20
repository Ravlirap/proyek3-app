import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  
  // Ganti ini sesuai kebutuhan:
  static const String baseUrl = 'http:// 192.168.0.102:3000'; // Untuk emulator Android
  
  String? _idToken;
  String? _accessToken;
  String? _displayName;
  String? _email;
  String? _photoUrl;
  
  // Login biasa
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _email = email;
      _displayName = email.split('@')[0];
      return {
        'success': true,
        'user': {
          'email': email, 
          'name': email.split('@')[0],
          'photoUrl': null,
        },
        'token': 'dummy_token_123'
      };
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }
  
  // Register biasa
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      _email = email;
      _displayName = name;
      return {
        'success': true,
        'user': {'email': email, 'name': name, 'photoUrl': null},
        'token': 'dummy_token_123'
      };
    } catch (e) {
      debugPrint('Register error: $e');
      rethrow;
    }
  }
  
  // Sign in dengan Google
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('User cancelled sign in');
      }
      
      _displayName = googleUser.displayName;
      _email = googleUser.email;
      _photoUrl = googleUser.photoUrl;
      
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      _idToken = googleAuth.idToken;
      _accessToken = googleAuth.accessToken;
      
      debugPrint('Google Sign-In Success: $_email');
      debugPrint('Name: $_displayName');
      
      // Coba kirim ke backend jika backend running
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/auth/google'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'idToken': _idToken,
            'accessToken': _accessToken,
            'email': _email,
            'name': _displayName,
            'photoUrl': _photoUrl,
          }),
        ).timeout(const Duration(seconds: 3));
        
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          return {
            'success': true,
            'user': responseData['user'],
            'token': responseData['token'],
          };
        }
      } catch (e) {
        debugPrint('Backend not available, using local data: $e');
      }
      
      // Fallback jika backend tidak jalan
      return {
        'success': true,
        'user': {
          'email': _email,
          'name': _displayName,
          'photoUrl': _photoUrl,
        },
        'token': 'google_token_${DateTime.now().millisecondsSinceEpoch}',
      };
      
    } catch (e) {
      debugPrint('Google sign in error: $e');
      rethrow;
    }
  }
  
  // Get user profile
  Future<Map<String, dynamic>> getUserProfile(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/user/$email'),
      ).timeout(const Duration(seconds: 3));
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint('Get user profile error: $e');
    }
    
    // Fallback
    return {
      'success': true,
      'user': {
        'email': _email ?? email,
        'name': _displayName ?? email.split('@')[0],
        'photoUrl': _photoUrl,
      }
    };
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _idToken = null;
      _accessToken = null;
      _displayName = null;
      _email = null;
      _photoUrl = null;
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }
  
  bool isLoggedIn() {
    return _idToken != null || _email != null;
  }
  
  String? getUserEmail() => _email;
  String? getUserName() => _displayName;
  String? getPhotoUrl() => _photoUrl;
  String? getToken() => _idToken;
}