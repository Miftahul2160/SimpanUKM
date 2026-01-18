import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:simpanukm_uas_pam/data/services/api_service.dart';

class AuthService {
  static const String baseUrl = "http://127.0.0.1:8000/api";
  static Future login(Map data) async {
  return await ApiService.post("auth/login", data);
}

static Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
  final res = await http.post(
    Uri.parse("$baseUrl/auth/register"),
    body: jsonEncode(data),
    headers: {"Content-Type": "application/json"},
  );

  return jsonDecode(res.body);
}
}
