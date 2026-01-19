import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/data/services/borrow_service.dart';

class BorrowHistoryPage extends StatefulWidget {
  const BorrowHistoryPage({super.key});

  @override
  State<BorrowHistoryPage> createState() => _BorrowHistoryPageState();
}

class _BorrowHistoryPageState extends State<BorrowHistoryPage> {
  final BorrowService _borrowService = BorrowService();
  List<dynamic> borrowHistory = [];
  bool isLoading = true;
  String selectedStatus = "all";

  @override
  void initState() {
    super.initState();
    fetchBorrowHistory();
  }

  Future<void> fetchBorrowHistory() async {
    setState(() => isLoading = true);
    try {
      final result = await _borrowService.getBorrowHistory();
      setState(() {
        borrowHistory = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading history: $e")),
      );
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "approved":
        return Colors.green;
      case "rejected":
        return Colors.red;
      case "returned":
        return Colors.blue;
      case "pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  List<dynamic> get filteredHistory {
    if (selectedStatus == "all") return borrowHistory;
    return borrowHistory
        .where((e) => (e['status'] ?? '').toLowerCase() == selectedStatus.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History Peminjaman")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter status
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

                // List history
                Expanded(
                  child: filteredHistory.isEmpty
                      ? const Center(child: Text("Belum ada data"))
                      : RefreshIndicator(
                          onRefresh: fetchBorrowHistory,
                          child: ListView.builder(
                            itemCount: filteredHistory.length,
                            itemBuilder: (context, index) {
                              final data = filteredHistory[index];

                              return Card(
                                margin: const EdgeInsets.all(8),
                                child: ListTile(
                                  title: Text(data['item_name'] ?? "Item ${data['item_id']}"),
                                  subtitle: Text(
                                    "${data['user_name'] ?? "User ${data['user_id']}"}\n${data['borrow_date'] ?? 'N/A'} - ${data['return_date'] ?? 'N/A'}",
                                  ),
                                  trailing: Chip(
                                    label: Text((data['status'] ?? 'unknown').toUpperCase()),
                                    backgroundColor: statusColor(data['status'] ?? ''),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                )
              ],
            ),
    );
  }
}
