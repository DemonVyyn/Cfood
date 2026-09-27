import 'package:flutter/material.dart';

class OrderDetailCard
    extends StatelessWidget {
  const OrderDetailCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Rincian Surplus Makanan",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const ListTile(
              contentPadding:
                  EdgeInsets.zero,
              title: Text(
                "1x Surprise Mystery Box",
              ),
              subtitle: Text(
                "Pastry artisan & sourdough",
              ),
            ),

            const Divider(),

            Row(
              children: const [
                Text("Total"),
                Spacer(),
                Text(
                  "Rp28.000",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
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