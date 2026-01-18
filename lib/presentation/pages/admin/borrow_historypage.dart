import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BorrowHistoryPage extends StatefulWidget {
  const BorrowHistoryPage({super.key});

  @override
  State<BorrowHistoryPage> createState() =>
      _BorrowHistoryPageState();
}

class _BorrowHistoryPageState extends State<BorrowHistoryPage> {
  List<dynamic> borrowHistory = [];
  bool isLoading = true;
  String selectedStatus = "all";

  static const baseUrl = "http://127.0.0.1:8000/api"; 

  @override
  void initState() {
    super.initState();
    fetchBorrowHistory();
  }

  Future<void> fetchBorrowHistory() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/borrows/history"));

      if (response.statusCode == 200) {
        setState(() {
          borrowHistory = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Gagal load history");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Color statusColor(String status) {
    switch (status) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "returned":
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  List<dynamic> get filteredHistory {
    if (selectedStatus == "all") return borrowHistory;
    return borrowHistory.where((e) => e['status'] == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History Peminjaman")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // FILTER STATUS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ["all", "pending", "approved", "rejected", "returned"]
                        .map(
                          (status) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: ChoiceChip(
                              label: Text(status.toUpperCase()),
                              selected: selectedStatus == status,
                              onSelected: (_) {
                                setState(() => selectedStatus = status);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                const Divider(),

                // LIST HISTORY
                Expanded(
                  child: filteredHistory.isEmpty
                      ? const Center(child: Text("Belum ada data"))
                      : ListView.builder(
                          itemCount: filteredHistory.length,
                          itemBuilder: (context, index) {
                            final data = filteredHistory[index];

                            return Card(
                              margin: const EdgeInsets.all(8),
                              child: ListTile(
                                title: Text(data['item_name']),
                                subtitle: Text(
                                    "${data['user_name']} • ${data['borrow_date']} - ${data['return_date']}"),
                                trailing: Chip(
                                  label: Text(data['status']),
                                  backgroundColor: statusColor(data['status']),
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
    );
  }
}
