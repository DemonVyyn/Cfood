import 'package:flutter/material.dart';

import 'widgets/order_history_card.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Pesanan")),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: const [
          OrderHistoryCard(
            title: "Surprise Mystery Box",
            store: "Kemang Artisan Bakery",
            price: "Rp28.000",
            status: "Selesai",
          ),
        ],
      ),
      // Bottom navigation is now handled by HomeShell (SPA).
    );
  }
}
