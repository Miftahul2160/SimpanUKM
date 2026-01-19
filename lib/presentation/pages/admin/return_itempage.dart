import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/data/services/borrow_service.dart';

class ReturnItemPage extends StatefulWidget {
  const ReturnItemPage({super.key});

  @override
  State<ReturnItemPage> createState() => _ReturnItemPageState();
}

class _ReturnItemPageState extends State<ReturnItemPage> {
  final BorrowService _borrowService = BorrowService();
  List<dynamic> approvedBorrows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApprovedBorrows();
  }

  Future<void> fetchApprovedBorrows() async {
    setState(() => isLoading = true);
    try {
      final result = await _borrowService.getApprovedBorrows();
      setState(() {
        approvedBorrows = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading data: $e")),
      );
    }
  }

  Future<void> markAsReturned(int id) async {
    try {
      final success = await _borrowService.returnBorrow(id);

      if (success) {
        fetchApprovedBorrows();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pengembalian Barang")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : approvedBorrows.isEmpty
              ? const Center(child: Text("Tidak ada barang dipinjam"))
              : RefreshIndicator(
                  onRefresh: fetchApprovedBorrows,
                  child: ListView.builder(
                    itemCount: approvedBorrows.length,
                    itemBuilder: (context, index) {
                      final data = approvedBorrows[index];

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(data['item_name'] ?? "Item ${data['item_id']}"),
                          subtitle: Text(
                            "${data['user_name'] ?? "User ${data['user_id']}"}\n${data['borrow_date'] ?? 'N/A'} - ${data['return_date'] ?? 'N/A'}",
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => markAsReturned(data['id']),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text("Kembalikan"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
