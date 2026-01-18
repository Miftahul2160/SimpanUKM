import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BorrowApprovePage extends StatefulWidget {
  const BorrowApprovePage({super.key});

  @override
  State<BorrowApprovePage> createState() => _BorrowApprovePageState();
}

class _BorrowApprovePageState extends State<BorrowApprovePage> {
  List<dynamic> pendingBorrows = [];
  bool isLoading = true;

  final String baseUrl = "http://10.0.2.2:8000/api";

  @override
  void initState() {
    super.initState();
    fetchPendingBorrows();
  }

  Future<void> fetchPendingBorrows() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/borrows/pending"));

      if (response.statusCode == 200) {
        setState(() {
          pendingBorrows = jsonDecode(response.body);
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

  Future<void> updateStatus(int id, String action) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/borrows/$id/$action"),
      );

      if (response.statusCode == 200) {
        fetchPendingBorrows();
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
      appBar: AppBar(title: const Text("Approval Peminjaman")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingBorrows.isEmpty
              ? const Center(child: Text("Tidak ada pengajuan"))
              : ListView.builder(
                  itemCount: pendingBorrows.length,
                  itemBuilder: (context, index) {
                    final data = pendingBorrows[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(data['item_name']),
                        subtitle: Text(
                          "${data['user_name']} • ${data['borrow_date']} - ${data['return_date']}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () =>
                                  updateStatus(data['id'], "approve"),
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.green),
                            ),
                            IconButton(
                              onPressed: () =>
                                  updateStatus(data['id'], "reject"),
                              icon: const Icon(Icons.cancel, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
