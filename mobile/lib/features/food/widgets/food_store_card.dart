import 'package:flutter/material.dart';

import '../../../models/food_model.dart';

class FoodStoreCard extends StatelessWidget {
  final FoodModel food;

  const FoodStoreCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.green.shade100,
            child: const Icon(
              Icons.store,
              color: Color(0xff166534),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  food.namaToko,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Mitra CFood',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}