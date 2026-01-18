import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/borrow.dart';

class BorrowService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<BorrowItem>> getUserBorrows(int userId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/borrows/user/$userId"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List.from(data['data'])
          .map((e) => BorrowItem.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<bool> requestBorrow(BorrowItem borrow) async {
    final response = await http.post(
      Uri.parse("$baseUrl/borrows"),
      body: borrow.toJson(),
    );

    return response.statusCode == 201;
  }

  Future<bool> approveBorrow(int borrowId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/borrows/$borrowId/approve"),
    );

    return response.statusCode == 200;
  }

  Future<bool> rejectBorrow(int borrowId) async {
    final response = await http.put(
      Uri.parse("$baseUrl/borrows/$borrowId/reject"),
    );

    return response.statusCode == 200;
  }

  Future<List<BorrowItem>> getPendingBorrows() async {
  final response = await http.get(Uri.parse("$baseUrl/borrows/pending"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return List.from(data['data'])
        .map((e) => BorrowItem.fromJson(e))
        .toList();
  }

  return [];
}

}
