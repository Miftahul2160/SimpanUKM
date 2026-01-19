import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/presentation/pages/admin/borrow_aprovepage.dart';
import 'package:simpanukm_uas_pam/presentation/pages/admin/borrow_historypage.dart';
import 'package:simpanukm_uas_pam/presentation/pages/admin/dashboard_adminpage.dart';
import 'package:simpanukm_uas_pam/presentation/pages/admin/item_manajemenpage.dart';
import 'package:simpanukm_uas_pam/presentation/pages/admin/admin_profilepage.dart';

class AdminNavigationPage extends StatefulWidget {
  final Map<String, dynamic>? adminData;

  const AdminNavigationPage({super.key, this.adminData});

  @override
  State<AdminNavigationPage> createState() => _AdminNavigationPageState();
}

class _AdminNavigationPageState extends State<AdminNavigationPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const DashboardAdminPage(),
      const ItemManagementPage(),
      const BorrowApprovePage(),
      const BorrowHistoryPage(),
      AdminProfilePage(admin: widget.adminData),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Barang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Approval',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
