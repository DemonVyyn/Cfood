import 'package:flutter/material.dart';

import 'widgets/notification_card.dart';
import '../../../widgets/curved_bottom_nav.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          NotificationCard(
            title: "Pesanan Siap Diambil",
            message:
                "Pesanan Anda sudah siap diambil di Kemang Artisan Bakery.",
            time: "5 menit lalu",
          ),

          NotificationCard(
            title: "Hemat Food Waste",
            message: "Anda berhasil menyelamatkan 1.4kg makanan hari ini.",
            time: "1 jam lalu",
          ),
        ],
      ),
      // Bottom navigation is now handled by HomeShell (SPA).
    );
  }
}
