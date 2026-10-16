import 'package:flutter/material.dart';

class PickupLocationCard extends StatelessWidget {
  const PickupLocationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.location_on,
            color: Color(0xFF0F8F67),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: const [
                Text(
                  "Lokasi Pengambilan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "Kemang Artisan Bakery\nJl. Kemang Raya No.12 Jakarta Selatan",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}