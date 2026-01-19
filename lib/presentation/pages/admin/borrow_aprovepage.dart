import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/data/models/borrow.dart';
import 'package:simpanukm_uas_pam/data/services/borrow_service.dart';

class BorrowApprovePage extends StatefulWidget {
  const BorrowApprovePage({super.key});

  @override
  State<BorrowApprovePage> createState() => _BorrowApprovePageState();
}

class _BorrowApprovePageState extends State<BorrowApprovePage> {
  final BorrowService _borrowService = BorrowService();
  List<BorrowItem> pendingBorrows = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPendingBorrows();
  }

  Future<void> fetchPendingBorrows() async {
    setState(() => isLoading = true);
    try {
      final result = await _borrowService.getPendingBorrows();
      setState(() {
        pendingBorrows = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading borrows: $e")),
      );
    }
  }

  Future<void> updateStatus(int id, bool approve) async {
    try {
      final success = approve
          ? await _borrowService.approveBorrow(id)
          : await _borrowService.rejectBorrow(id);

      if (success) {
        fetchPendingBorrows();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              approve ? "Pengajuan disetujui" : "Pengajuan ditolak",
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengupdate status")),
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
      appBar: AppBar(title: const Text("Approval Peminjaman")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : pendingBorrows.isEmpty
              ? const Center(child: Text("Tidak ada pengajuan pending"))
              : RefreshIndicator(
                  onRefresh: fetchPendingBorrows,
                  child: ListView.builder(
                    itemCount: pendingBorrows.length,
                    itemBuilder: (context, index) {
                      final borrow = pendingBorrows[index];

                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text("Item ${borrow.itemId}"),
                          subtitle: Text(
                            "User ${borrow.userId}\n${borrow.borrowDate} - ${borrow.returnDate}",
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => updateStatus(borrow.id, true),
                                icon: const Icon(Icons.check_circle, color: Colors.green),
                              ),
                              IconButton(
                                onPressed: () => updateStatus(borrow.id, false),
                                icon: const Icon(Icons.cancel, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
