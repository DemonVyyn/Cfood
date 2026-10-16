import 'package:flutter/material.dart';

class QrCodeCard extends StatelessWidget {
  const QrCodeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [
            const Text(
              "Voucher Pengambilan Surplus",
            ),

            const SizedBox(height: 20),

            Container(
              height: 220,
              width: 220,
              color: Colors.grey.shade200,

              child: const Icon(
                Icons.qr_code_2,
                size: 180,
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "MEO-9821",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}