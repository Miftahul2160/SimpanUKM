import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/data/models/borrow.dart';
import 'package:simpanukm_uas_pam/data/services/borrow_service.dart';
import 'package:simpanukm_uas_pam/data/services/item_service.dart';
import 'package:simpanukm_uas_pam/presentation/widgets/pending_card.dart';
import 'package:simpanukm_uas_pam/presentation/widgets/statistic_card.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  final itemService = ItemService();
  final borrowService = BorrowService();

  Map<String, dynamic> summary = {};
  List<BorrowItem> pendingList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final itemSummary = await itemService.getItemSummary();
      final pending = await borrowService.getPendingBorrows();

      setState(() {
        summary = {
          'total': itemSummary['total'] ?? 0,
          'borrowed': itemSummary['borrowed'] ?? 0,
          'available': itemSummary['available'] ?? 0,
        };
        pendingList = pending;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading dashboard: $e");
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading dashboard: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Admin")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadDashboard,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text("Statistik Barang",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      StatisticCard(
                        title: "Total Barang",
                        value: summary['total']?.toString() ?? "0",
                        icon: Icons.inventory,
                      ),
                      StatisticCard(
                        title: "Dipinjam",
                        value: summary['borrowed']?.toString() ?? "0",
                        icon: Icons.assignment_returned,
                      ),
                      StatisticCard(
                        title: "Tersedia",
                        value: summary['available']?.toString() ?? "0",
                        icon: Icons.check_circle,
                      ),
                      StatisticCard(
                        title: "Pending",
                        value: pendingList.length.toString(),
                        icon: Icons.pending_actions,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const Text("Pengajuan Peminjaman",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),

                  if (pendingList.isEmpty)
                    const Text("Tidak ada pengajuan pending"),

                  ...pendingList.map((borrow) => PendingBorrowCard(
                        borrowerName: "User ${borrow.userId}",
                        itemName: "Item ${borrow.itemId}",
                        date: borrow.borrowDate,
                        onApprove: () async {
                          await borrowService.approveBorrow(borrow.id);
                          loadDashboard();
                        },
                        onReject: () async {
                          await borrowService.rejectBorrow(borrow.id);
                          loadDashboard();
                        },
                      ))
                ],
              ),
            ),
    );
  }
}
