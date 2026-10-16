import 'package:flutter/material.dart';

class PickupOrderCard
    extends StatelessWidget {
  final List<dynamic> orders;

  const PickupOrderCard({
    super.key,
    required this.orders,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Belum ada pesanan',
          ),
        ),
      );
    }

    final order = orders.first;

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        
        child: Column(
          
          children: [
          
            ListTile(
              contentPadding:
                  EdgeInsets.zero,

              title: Text(
                order['customer']
                        ?['nama'] ??
                    '-',
              ),

              subtitle: Text(
                order['kode_pengambilan'] ??
                    '-',
              ),

              trailing: Text(
                "Rp ${order['total_harga']}",
              ),
            ),
          ],
        ),
      ),
    );
  }
}