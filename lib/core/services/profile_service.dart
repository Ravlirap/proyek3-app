import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProfileService {
  static const String baseUrl = 'http://10.0.171.132:8000/api';

  Map<String, String> _headers(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // ────────────────────────────────────────────────────
  // R – Ambil profile (nama, email, photo_url)
  // GET /api/profile  atau  /api/me  (keduanya sama)
  // ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: _headers(token),
    );
    return _handle(response);
  }

  // ────────────────────────────────────────────────────
  // C / U – Upload / ganti foto profil
  // POST /api/profile/photo  (multipart)
  // ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> uploadPhoto({
    required String token,
    required File image,
  }) async {
    final uri = Uri.parse('$baseUrl/upload-photo');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_headers(token))
      ..files.add(await http.MultipartFile.fromPath(
        'photo',
        image.path,
      ));

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _handle(response);
  }

  // ────────────────────────────────────────────────────
  // D – Hapus foto profil
  // DELETE /api/profile/photo
  // ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> deletePhoto(String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/profile/photo'), // DELETE tetap di route ini
      headers: _headers(token),
    );
    return _handle(response);
  }

  // ────────────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────────────
  Map<String, dynamic> _handle(http.Response response) {
    final dynamic decoded =
        response.body.isNotEmpty ? jsonDecode(response.body) : {};

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded as Map<String, dynamic>;
    }

    if (decoded is Map<String, dynamic> && decoded['message'] != null) {
      throw Exception(decoded['message']);
    }

    throw Exception('Error ${response.statusCode}');
  }
}
