import 'package:flutter/material.dart';

class DashboardUserPage extends StatefulWidget {
  const DashboardUserPage({super.key});

  @override
  State<DashboardUserPage> createState() => _DashboardUserPageState();
}

class _DashboardUserPageState extends State<DashboardUserPage> {
  int indexMenu = 0;

  final List<String> titles = [
    'Daftar Barang',
    'Peminjaman',
    'Pengembalian',
    'Riwayat',
    'Profil',
  ];

  final List<IconData> icons = [
    Icons.inventory,
    Icons.assignment,
    Icons.assignment_return,
    Icons.history,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SimpanUKM - ${titles[indexMenu]}'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(titles[indexMenu], style: const TextStyle(fontSize: 22)),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // ← INI KUNCINYA
        currentIndex: indexMenu,
        onTap: (value) {
          setState(() {
            indexMenu = value;
          });
        },
        items: List.generate(
          titles.length,
          (i) =>
              BottomNavigationBarItem(icon: Icon(icons[i]), label: titles[i]),
        ),
      ),
    );
  }
}
