import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/data/models/borrow.dart';
import 'package:simpanukm_uas_pam/data/services/borrow_service.dart';
import 'package:simpanukm_uas_pam/data/services/item_service.dart';
import 'package:simpanukm_uas_pam/presentation/widgets/statistic_card.dart';

class DashboardUserPage extends StatefulWidget {
  final int userId;

  const DashboardUserPage({super.key, required this.userId});

  @override
  State<DashboardUserPage> createState() => _DashboardUserPageState();
}

class _DashboardUserPageState extends State<DashboardUserPage> {
  final itemService = ItemService();
  final borrowService = BorrowService();

  Map<String, dynamic> summary = {};
  List<BorrowItem> activeBorrows = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final itemSummary = await itemService.getItemSummary();
      final borrows = await borrowService.getUserBorrows(widget.userId);

      setState(() {
        summary = {
          'total': itemSummary['total'] ?? 0,
          'available': itemSummary['available'] ?? 0,
        };
        activeBorrows = borrows
            .where((b) => b.status.toLowerCase() == "approved")
            .toList();
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
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Anggota")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadDashboard,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    "Ringkasan Barang",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                        title: "Tersedia",
                        value: summary['available']?.toString() ?? "0",
                        icon: Icons.check_circle,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Peminjaman Aktif",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  if (activeBorrows.isEmpty)
                    const Text("Tidak ada peminjaman aktif"),

                  ...activeBorrows.map((borrow) => Card(
                        child: ListTile(
                          title: Text("Item ${borrow.itemId}"),
                          subtitle: Text(
                              "Pinjam: ${borrow.borrowDate}\nKembali: ${borrow.returnDate}"),
                        ),
                      )),

                  const SizedBox(height: 24),

                  const Text(
                    "Menu",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, "/borrow_request");
                          },
                          icon: const Icon(Icons.add_box),
                          label: const Text("Pinjam Barang"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, "/history");
                          },
                          icon: const Icon(Icons.history),
                          label: const Text("Riwayat"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
