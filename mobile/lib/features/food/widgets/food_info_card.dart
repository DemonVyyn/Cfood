import 'package:flutter/material.dart';

import '../../../models/food_model.dart';

class FoodInfoCard extends StatelessWidget {
  final FoodModel food;

  const FoodInfoCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          food.nama,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Text(
              "Rp ${food.hargaDiskon.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Color(0xff166534),
              ),
            ),

            const SizedBox(width: 10),

            Text(
              "Rp ${food.hargaOriginal.toStringAsFixed(0)}",
              style: const TextStyle(
                decoration:
                    TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildCard(
          title: 'Detail Pengambilan',
          child: Column(
            children: [
              _rowInfo(
                Icons.store,
                food.namaToko,
              ),

              const SizedBox(height: 12),

              _rowInfo(
                Icons.inventory,
                "Stok tersedia: ${food.stok}",
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        _buildCard(
          title: 'Deskripsi Makanan',
          child: Text(
            food.deskripsi,
            style: const TextStyle(
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }

  Widget _rowInfo(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xff166534),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(text),
        ),
      ],
    );
  }
}