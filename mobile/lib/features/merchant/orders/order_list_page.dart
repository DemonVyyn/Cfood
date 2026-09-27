import 'package:flutter/material.dart';
import '../../../widgets/merchant_bottom_nav.dart';

import 'widgets/merchant_order_card.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Pesanan',
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: const [
          MerchantOrderCard(
            orderId: "#CF10234",
            customerName: "Avnes Pratama",
            productName:
                "Artisanal Croissant Box",
            pickupTime:
                "Hari ini • 18:00",
            status:
                "Siap Diambil",
            totalPrice: 28000,
          ),

          MerchantOrderCard(
            orderId: "#CF10235",
            customerName: "Dimas",
            productName:
                "Japanese Bento",
            pickupTime:
                "Hari ini • 19:00",
            status:
                "Menunggu",
            totalPrice: 45000,
          ),

          MerchantOrderCard(
            orderId: "#CF10236",
            customerName: "Raisya",
            productName:
                "Gourmet Pasta",
            pickupTime:
                "Besok • 12:00",
            status:
                "Selesai",
            totalPrice: 35000,
          ),
        ],
      ),
      bottomNavigationBar:
    const MerchantBottomNav(
  currentIndex: 2,
),
    );
  }
}