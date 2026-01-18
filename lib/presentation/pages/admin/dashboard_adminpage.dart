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
    final itemSummary = await itemService.getItemSummary();
    final pending = await borrowService.getPendingBorrows();

    setState(() {
      summary = itemSummary;
      pendingList = pending;
      isLoading = false;
    });
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
<<<<<<< HEAD
            ),
=======

              const SizedBox(height: 24),

              // ===== PENDING LIST =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.assignment, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Pengajuan Terbaru',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: navigate to full list page
                    },
                    child: const Text('Lihat Semua'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              ListView.separated(
                itemCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return PendingBorrowCard(
                    borrowerName: 'Anggota ${index + 1}',
                    itemName: 'Kamera DSLR',
                    date: '12 Jan 2026',
                    onApprove: () {
                      // TODO: approve API
                    },
                    onReject: () {
                      // TODO: reject API
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
>>>>>>> 3cc1ba4657e706f9edf463ce18742d2946696483
    );
  }
}
