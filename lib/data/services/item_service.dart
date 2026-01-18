import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:simpanukm_uas_pam/data/services/http_service.dart';
import '../models/item.dart';

class ItemService {
  // final HttpService httpService;
  static const String baseUrl = "http://localhost/api";
  Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse("$baseUrl/items"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List.from(data['data'])
          .map((e) => Item.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<bool> createItem(Item item) async {
    final response = await http.post(
      Uri.parse("$baseUrl/items"),
      body: item.toJson(),
    );

    return response.statusCode == 201;
  }

  Future<bool> updateItem(Item item) async {
    final response = await http.put(
      Uri.parse("$baseUrl/items/${item.id}"),
      body: item.toJson(),
    );

    return response.statusCode == 200;
  }

  Future<bool> deleteItem(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/items/$id"),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> getItemSummary() async {
  final response = await http.get(Uri.parse("$baseUrl/items/summary"));

  if (response.statusCode == 200) {
    return jsonDecode(response.body)['data'];
  }

  return {};
}
}
