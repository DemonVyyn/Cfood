import 'package:flutter/material.dart';

import '../../../models/food_model.dart';

class FoodBottomBar extends StatelessWidget {
  final FoodModel food;

  const FoodBottomBar({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Colors.black12,
            ),
          ],
        ),
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed:
                food.isExpired
                    ? null
                    : () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Checkout akan dibuat pada tahap berikutnya',
                            ),
                          ),
                        );
                      },
            child: Text(
              food.isExpired
                  ? 'Produk Expired'
                  : 'Pesan Sekarang',
            ),
          ),
        ),
      ),
    );
  }
}