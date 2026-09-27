import 'package:flutter/material.dart';

import '../../../data/dummy_foods.dart';

class MerchantInfo extends StatelessWidget {
  final DummyFood food;

  const MerchantInfo({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,

      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Text(
            food.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.store,
                color: Colors.green,
              ),

              const SizedBox(width: 8),

              Text(
                food.store,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.star,
                color: Colors.orange,
              ),

              Text(
                food.rating.toString(),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Text(
                'Rp ${food.originalPrice}',
                style: const TextStyle(
                  decoration:
                      TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                'Rp ${food.discountPrice}',
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}