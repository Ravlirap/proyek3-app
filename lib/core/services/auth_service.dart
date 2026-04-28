import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.102:8000/api';

  Map<String, String> _headers({String? token}) {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: _headers(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: _headers(token: token),
    );

    return _handleResponse(response);
  }

  Future<void> logout(String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: _headers(token: token),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Logout gagal');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final dynamic decoded = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded as Map<String, dynamic>;
    }

    if (decoded is Map<String, dynamic>) {
      if (decoded['message'] != null) {
        throw Exception(decoded['message']);
      }

      if (decoded['errors'] is Map<String, dynamic>) {
        final errors = decoded['errors'] as Map<String, dynamic>;
        final firstKey = errors.keys.first;
        final firstValue = errors[firstKey];
        if (firstValue is List && firstValue.isNotEmpty) {
          throw Exception(firstValue.first.toString());
        }
      }
    }

    throw Exception('Terjadi kesalahan (${response.statusCode})');
  }

  UserModel parseUser(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }
}
