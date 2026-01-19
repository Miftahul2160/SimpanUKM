import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:simpanukm_uas_pam/data/services/api_service.dart';
import '../models/item.dart';

class ItemService {
  static const String baseUrl = "http://127.0.0.1:8000/api";

  Future<List<Item>> getItems() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null) {
          return List.from(data['data'])
              .map((e) => Item.fromJson(e))
              .toList();
        }
        return [];
      } else {
        throw Exception("Failed to load items: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading items: $e");
      return [];
    }
  }

  Future<bool> createItem(Item item) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/items"),
        body: jsonEncode(item.toJson()),
        headers: {"Content-Type": "application/json"},
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Error creating item: $e");
      return false;
    }
  }

  Future<bool> updateItem(Item item) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/items/${item.id}"),
        body: jsonEncode(item.toJson()),
        headers: {"Content-Type": "application/json"},
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error updating item: $e");
      return false;
    }
  }

  Future<bool> deleteItem(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/items/$id"),
        headers: {"Content-Type": "application/json"},
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error deleting item: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> getItemSummary() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/items/summary"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'] ?? {};
      }
      return {};
    } catch (e) {
      print("Error loading summary: $e");
      return {};
    }
  }

  Future<bool> createItemWithImage(
    String name,
    String location,
    int stock,
    Uint8List? imageBytes,
    String? imageName,
  ) async {
    try {
      final response = await ApiService.multipart(
        "items",
        {
          "name": name,
          "location": location,
          "quantity_total": stock.toString(),
        },
        imageBytes,
        imageName,
      );

      return response != null;
    } catch (e) {
      print("Error creating item with image: $e");
      return false;
    }
  }

  Future<bool> updateItemWithImage(
    String id,
    String name,
    String location,
    int stock,
    Uint8List? imageBytes,
    String? imageName,
  ) async {
    try {
      final response = await ApiService.multipart(
        "items/$id",
        {
          "name": name,
          "location": location,
          "quantity_total": stock.toString(),
        },
        imageBytes,
        imageName,
        method: "PUT",
      );

      return response != null;
    } catch (e) {
      print("Error updating item with image: $e");
      return false;
    }
  }
}
