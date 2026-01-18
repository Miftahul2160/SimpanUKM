import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String baseUrl = "http://localhost/api";

  Future<Users?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/login"),
      body: {
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Users.fromJson(data['data']);
    }

    return null;
  }

  Future<bool> register(
      String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse("$baseUrl/auth/register"),
      body: {
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      },
    );

    return response.statusCode == 201;
  }
}
