import 'package:flutter/material.dart';
import 'package:simpanukm_uas_pam/data/services/authen_service.dart';
import 'package:simpanukm_uas_pam/presentation/pages/login_page.dart';

class AdminProfilePage extends StatefulWidget {
  final Map<String, dynamic>? admin;
  const AdminProfilePage({super.key, this.admin});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  bool _isLoading = false;

  Future<void> _logout() async {
    setState(() => _isLoading = true);
    try {
      final success = await AuthService.logout();
      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logout gagal")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminName = widget.admin?['name'] ?? 'Admin';
    final adminEmail = widget.admin?['email'] ?? '-';

    return Scaffold(
      appBar: AppBar(title: const Text("Profil Admin")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    adminName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    adminEmail,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Text(
                    "Admin",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: _logout,
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}


