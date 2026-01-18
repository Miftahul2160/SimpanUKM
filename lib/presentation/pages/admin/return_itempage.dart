import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReturnItemPage extends StatefulWidget {
  const ReturnItemPage({super.key});

  @override
  State<ReturnItemPage> createState() => _ReturnItemPageState();
}

class _ReturnItemPageState extends State<ReturnItemPage> {
  List<dynamic> approvedBorrows = [];
  bool isLoading = true;

  final String baseUrl = "http://10.0.2.2:8000/api";

  @override
  void initState() {
    super.initState();
    fetchApprovedBorrows();
  }

  Future<void> fetchApprovedBorrows() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/borrows/approved"));

      if (response.statusCode == 200) {
        setState(() {
          approvedBorrows = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Gagal load data");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> markAsReturned(int id) async {
    try {
      final response = await http.put(Uri.parse("$baseUrl/borrows/$id/return"));

      if (response.statusCode == 200) {
        fetchApprovedBorrows();
      } else {
        throw Exception("Gagal update status");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengembalian Barang")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : approvedBorrows.isEmpty
              ? const Center(child: Text("Tidak ada barang dipinjam"))
              : ListView.builder(
                  itemCount: approvedBorrows.length,
                  itemBuilder: (context, index) {
                    final data = approvedBorrows[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(data['item_name']),
                        subtitle: Text(
                            "${data['user_name']} • ${data['borrow_date']} - ${data['return_date']}"),
                        trailing: ElevatedButton(
                          onPressed: () => markAsReturned(data['id']),
                          child: const Text("Returned"),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
