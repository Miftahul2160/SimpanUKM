import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/presentation/pages/user/borrow_requestpage.dart';
import 'package:simpanukm_uas_pam/presentation/pages/user/dashboard_userpage.dart';
import 'package:simpanukm_uas_pam/presentation/pages/user/user_borrowhistory.dart';
import 'package:simpanukm_uas_pam/presentation/pages/user/user_profilepage.dart';

class UserNavigationPage extends StatefulWidget {
  final int userId;
  final Map<String, dynamic>? userData;

  const UserNavigationPage({
    super.key,
    required this.userId,
    this.userData,
  });

  @override
  State<UserNavigationPage> createState() => _UserNavigationPageState();
}

class _UserNavigationPageState extends State<UserNavigationPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardUserPage(userId: widget.userId),
      BorrowRequestPage(userId: widget.userId),
      UserBorrowHistoryPage(userId: widget.userId),
      UserProfilePage(user: widget.userData),
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
            icon: Icon(Icons.inventory),
            label: 'Pinjam',
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
