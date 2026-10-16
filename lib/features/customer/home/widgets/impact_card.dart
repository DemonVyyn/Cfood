import 'package:flutter/material.dart';

import 'stat_item.dart';

class ImpactCard extends StatelessWidget {
  final int totalProducts;
  final int totalStock;

  const ImpactCard({
    super.key,
    required this.totalProducts,
    required this.totalStock,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xff166534),
            Color(0xff0f4a25),
          ],
        ),
        borderRadius:
            BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "Dampak Komunitas",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "$totalProducts",
            style: const TextStyle(
              fontSize: 42,
              fontWeight:
                  FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Text(
            "Produk Surplus Aktif",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              StatItem(
                value:
                    "$totalStock pcs",
                label: "Stok",
              ),
              StatItem(
                value:
                    "$totalProducts Mitra",
                label: "Tersedia",
              ),
            ],
          ),
        ],
      ),
    );
  }
}