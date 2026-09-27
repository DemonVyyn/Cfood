import 'package:flutter/material.dart';

class PickupInstructionCard
    extends StatelessWidget {
  const PickupInstructionCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info,
              color: Colors.green,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                "Tunjukkan kode QR kepada kasir saat mengambil pesanan. Bawa tas belanja sendiri untuk mendukung gerakan ramah lingkungan.",
                style: TextStyle(
                  color:
                      Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}