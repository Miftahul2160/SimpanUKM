import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://127.0.0.1:8000/api"; 
  // static const baseUrl = "http://192.168.56.1:8000/api"; 

  static Future post(String endpoint, Map data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/$endpoint"),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json"},
    );

    return jsonDecode(response.body);
  }
}
