import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:simpanukm_uas_pam/data/services/api_service.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    try {
      return await ApiService.post("auth/login", data);
    } catch (e) {
      return {
        "success": false,
        "message": "Login error: $e",
      };
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        return {
          "success": false,
          "message": "Registrasi gagal",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Register error: $e",
      };
    }
  }

  static Future<bool> logout() async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/auth/logout"),
        headers: {"Content-Type": "application/json"},
      );
      return res.statusCode == 200;
    } catch (e) {
      print("Logout error: $e");
      return false;
    }
  }
}
