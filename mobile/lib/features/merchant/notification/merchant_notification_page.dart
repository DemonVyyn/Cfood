import 'package:flutter/material.dart';

class MerchantNotificationPage extends StatelessWidget {
  const MerchantNotificationPage({super.key});

  static const Color primaryGreen = Color(0xFF14DE32);
  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color backgroundColor = Color(0xFFF7F9F7);
  static const Color textColor = Color(0xFF263126);

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
          'Notifikasi',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _buildNotificationCard(
            icon: Icons.shopping_bag_rounded,
            iconColor: darkGreen,
            title: 'Pesanan Baru',
            message: 'Ada pesanan baru yang masuk',
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.warning_amber_rounded,
            iconColor: Colors.orange.shade700,
            title: 'Stok Hampir Habis',
            message: 'Nasi Goreng tinggal 2 porsi',
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.restaurant_rounded,
            iconColor: Colors.red.shade600,
            title: 'Produk Expired Hari Ini',
            message: 'Roti Coklat expired pukul 22:00',
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.check_circle_rounded,
            iconColor: darkGreen,
            title: 'Pickup Berhasil',
            message: 'Pesanan #123 selesai',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
