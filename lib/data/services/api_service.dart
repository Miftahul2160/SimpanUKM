import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = "http://127.0.0.1:8000/api"; 
  // static const baseUrl = "http://192.168.56.1:8000/api"; 

  static final Map<String, String> _headers = {
    "Content-Type": "application/json",
  };

  static Future<dynamic> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$endpoint"),
        headers: _headers,
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception("GET Error: $e");
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/$endpoint"),
        body: jsonEncode(data),
        headers: _headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception("POST Error: $e");
    }
  }

  static Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$endpoint"),
        body: jsonEncode(data),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception("PUT Error: $e");
    }
  }

  static Future<dynamic> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$endpoint"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("HTTP ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      throw Exception("DELETE Error: $e");
    }
  }

  static Future<dynamic> multipart(
    String endpoint,
    Map<String, dynamic> data,
    File? file, {
    String method = "POST",
  }) async {
    try {
      var request = http.MultipartRequest(method, Uri.parse("$baseUrl/$endpoint"));
      
      // Add fields
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      
      // Add file
      if (file != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', file.path),
        );
      }
      
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(responseBody);
      } else {
        throw Exception("HTTP ${response.statusCode}: $responseBody");
      }
    } catch (e) {
      throw Exception("Multipart Error: $e");
    }
  }
}
