import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/presentation/widgets/pending_card.dart';
import 'package:simpanukm_uas_pam/presentation/widgets/statistic_card.dart';

class DashboardAdminPage extends StatefulWidget {
  const DashboardAdminPage({super.key});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin UKM'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: panggil API refresh
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Statistik =====
              const Text(
                'Ringkasan Inventaris',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [
                  StatisticCard(
                    title: 'Total Barang',
                    value: '120',
                    icon: Icons.inventory_2,
                  ),
                  StatisticCard(
                    title: 'Barang Dipinjam',
                    value: '25',
                    icon: Icons.assignment_returned,
                  ),
                  StatisticCard(
                    title: 'Barang Tersedia',
                    value: '95',
                    icon: Icons.check_circle,
                  ),
                  StatisticCard(
                    title: 'Pengajuan Pending',
                    value: '5',
                    icon: Icons.pending_actions,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ===== Pengajuan Terbaru =====
              const Text(
                'Pengajuan Peminjaman',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              ListView.separated(
                itemCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
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
    );
  }
}
