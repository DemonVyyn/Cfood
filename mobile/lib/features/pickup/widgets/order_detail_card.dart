
import 'package:flutter/material.dart';

import '../../../models/food_model.dart';

class OrderDetailCard extends StatelessWidget {
  final FoodModel food;
  final int quantity;
  final Map<String, dynamic> order;

  const OrderDetailCard({
    super.key,
    required this.food,
    required this.quantity,
    required this.order,
  });

  String _formatRupiah(num value) {
    final number = value.round().toString();
    final formatted = number.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]}.',
    );
    return 'Rp$formatted';
  }

  @override
  Widget build(BuildContext context) {
    final total = order['total_harga'] is num
        ? (order['total_harga'] as num).round()
        : int.tryParse('${order['total_harga']}') ??
            food.hargaDiskon.round() * quantity;

    final orderId = order['id']?.toString() ?? '-';
    final status = order['order_status']?.toString() ?? 'menunggu_pembayaran';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Rincian Surplus Makanan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('$quantity x ${food.nama}'),
              subtitle: Text(food.namaToko),
              trailing: Text(_formatRupiah(food.hargaDiskon)),
            ),
            const Divider(),
            Row(
              children: [
                const Text('ID Pesanan'),
                const Spacer(),
                Text('#$orderId'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Status'),
                const Spacer(),
                Flexible(
                  child: Text(
                    status.replaceAll('_', ' '),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  _formatRupiah(total),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
