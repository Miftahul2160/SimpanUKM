import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/borrow.dart';
import '../models/borrow_history.dart';

class BorrowService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  static final Map<String, String> _headers = {
    "Content-Type": "application/json",
  };

  Future<List<BorrowItem>> getUserBorrows(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/borrows/user/$userId"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return List.from(data['data'])
              .map((e) => BorrowItem.fromJson(e))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print("Error loading user borrows: $e");
      return [];
    }
  }

  Future<bool> requestBorrow(BorrowItem borrow) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/borrows"),
        body: jsonEncode(borrow.toJson()),
        headers: _headers,
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Error requesting borrow: $e");
      return false;
    }
  }

  Future<bool> approveBorrow(int borrowId) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/borrows/$borrowId/approve"),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error approving borrow: $e");
      return false;
    }
  }

  Future<bool> rejectBorrow(int borrowId) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/borrows/$borrowId/reject"),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error rejecting borrow: $e");
      return false;
    }
  }

  Future<List<BorrowItem>> getPendingBorrows() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/borrows/pending"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return List.from(data['data'])
              .map((e) => BorrowItem.fromJson(e))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print("Error loading pending borrows: $e");
      return [];
    }
  }

  Future<List<dynamic>> getBorrowHistory() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/borrows/history"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print("Error loading borrow history: $e");
      return [];
    }
  }

  Future<List<dynamic>> getUserBorrowHistory(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/borrows/user/$userId/history"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print("Error loading user borrow history: $e");
      return [];
    }
  }

  Future<List<dynamic>> getApprovedBorrows() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/borrows/approved"),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print("Error loading approved borrows: $e");
      return [];
    }
  }

  Future<bool> returnBorrow(int borrowId) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/borrows/$borrowId/return"),
        headers: _headers,
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error returning borrow: $e");
      return false;
    }
  }
}
