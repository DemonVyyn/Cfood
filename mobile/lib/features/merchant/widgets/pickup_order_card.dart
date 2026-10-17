import 'package:flutter/material.dart';

class PickupOrderCard extends StatelessWidget {
  final List<dynamic> orders;

  const PickupOrderCard({
    super.key,
    required this.orders,
  });

  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color textColor = Color(0xFF263126);

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: darkGreen,
                size: 26,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Belum ada pesanan',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final order = orders.first;

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F9E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: darkGreen,
                ),
              ),
              title: Text(
                order['customer']?['nama'] ?? '-',
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    const Icon(
                      Icons.qr_code_rounded,
                      size: 14,
                      color: darkGreen,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order['kode_pengambilan'] ?? '-',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Text(
                'Rp ${order['total_harga']}',
                style: const TextStyle(
                  color: darkGreen,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}