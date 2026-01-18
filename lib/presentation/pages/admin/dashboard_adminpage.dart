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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.primaryColor,
        title: const Text(
          'Dashboard Admin SimpanUKM',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Refresh dashboard data
            },
          )
        ],
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
              // ===== HEADER =====
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: const [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.admin_panel_settings,
                          color: Colors.white, size: 26),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Selamat datang, Admin SimpanUKM 👋\nKelola inventaris & peminjaman hari ini',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ===== STATISTIK =====
              Row(
                children: const [
                  Icon(Icons.bar_chart, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Ringkasan Inventaris',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
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
                    color: Colors.blue,
                  ),
                  StatisticCard(
                    title: 'Barang Dipinjam',
                    value: '25',
                    icon: Icons.assignment_returned,
                    color: Colors.orange,
                  ),
                  StatisticCard(
                    title: 'Barang Tersedia',
                    value: '95',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  StatisticCard(
                    title: 'Pengajuan Pending',
                    value: '5',
                    icon: Icons.pending_actions,
                    color: Colors.redAccent,
                  ),
                ],
              ),

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
    );
  }
}
