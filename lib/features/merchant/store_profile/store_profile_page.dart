import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import 'widgets/store_header.dart';
import 'widgets/store_info_card.dart';
import 'widgets/store_help_widget.dart';

class StoreProfilePage extends StatelessWidget {
  const StoreProfilePage({super.key});

  static const Color backgroundColor = Color(0xFFF7F9F7);
  static const Color textColor = Color(0xFF263126);

  Future<void> _logout(BuildContext context) async {
    try {
      await context.read<AuthProvider>().logout();

      if (!context.mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        (route) => false,
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Logout gagal. Silakan coba kembali.',
          ),
        ),
      );
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.help_outline_rounded,
                color: Color(0xFF0CB52A),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text('Pusat Bantuan Mitra'),
              ),
            ],
          ),
          content: const Text(
            'Di sini Mitra dapat memperoleh panduan '
            'pengelolaan produk, stok makanan, pesanan, '
            'dan proses verifikasi pengambilan makanan.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Mengerti',
                style: TextStyle(
                  color: Color(0xFF0CB52A),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCustomerServiceDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.support_agent_rounded,
                color: Color(0xFF0CB52A),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text('Customer Service'),
              ),
            ],
          ),
          content: const Text(
            'Kontak resmi Customer Service belum '
            'dikonfigurasi. Nomor WhatsApp atau alamat '
            'email CS dapat ditambahkan setelah '
            'informasi kontak resmi tersedia.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Tutup',
                style: TextStyle(
                  color: Color(0xFF0CB52A),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Profil Toko',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          const StoreHeader(),
          const SizedBox(height: 20),
          const StoreInfoCard(),
          const SizedBox(height: 20),
          StoreHelpWidget(
            onHelpTap: () => _showHelpDialog(context),
            onCustomerServiceTap: () {
              _showCustomerServiceDialog(context);
            },
            onLogout: () => _logout(context),
          ),
        ],
      ),
    );
  }
}
