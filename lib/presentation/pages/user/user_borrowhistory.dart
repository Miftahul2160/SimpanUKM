import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/data/services/borrow_service.dart';

class UserBorrowHistoryPage extends StatefulWidget {
  final int userId;

  const UserBorrowHistoryPage({super.key, required this.userId});

  @override
  State<UserBorrowHistoryPage> createState() => _UserBorrowHistoryPageState();
}

class _UserBorrowHistoryPageState extends State<UserBorrowHistoryPage> {
  final BorrowService _borrowService = BorrowService();
  List<dynamic> borrows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    setState(() => isLoading = true);
    try {
      final result = await _borrowService.getUserBorrowHistory(widget.userId);
      setState(() {
        borrows = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading history: $e")),
      );
    }
  }

  Future<void> returnItem(int borrowId) async {
    try {
      final success = await _borrowService.returnBorrow(borrowId);

      if (success) {
        fetchHistory();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Barang berhasil dikembalikan")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengembalikan barang")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'returned':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Peminjaman")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : borrows.isEmpty
              ? const Center(child: Text("Belum ada peminjaman"))
              : RefreshIndicator(
                  onRefresh: fetchHistory,
                  child: ListView.builder(
                    itemCount: borrows.length,
                    itemBuilder: (context, index) {
                      final borrow = borrows[index];
                      final status = borrow['status'] ?? 'unknown';

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: (borrow['item_photo_url'] ?? '').isNotEmpty
                              ? Image.network(
                                  borrow['item_photo_url'],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                )
                              : const Icon(Icons.image),
                          title: Text(
                            borrow['item_name'] ?? "Item ${borrow['item_id']}",
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${borrow['borrow_date'] ?? 'N/A'} - ${borrow['return_date'] ?? 'N/A'}",
                              ),
                              Text(
                                status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor(status),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          trailing: status.toLowerCase() == 'approved'
                              ? ElevatedButton(
                                  onPressed: () => returnItem(borrow['id']),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text("Kembalikan"),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
