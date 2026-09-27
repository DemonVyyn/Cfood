import 'package:flutter/material.dart';

import '../../../data/dummy_foods.dart';
import '../../checkout/checkout_page.dart';

class OrderBottomBar extends StatelessWidget {
  final DummyFood food;

  const OrderBottomBar({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(16),

      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black12,
          ),
        ],
      ),

      child: Row(
        children: [
          Expanded(
            child: Text(
              'Rp ${food.discountPrice}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const CheckoutPage(),
                ),
              );
            },
            child: const Text(
              "Pesan Sekarang",
            ),
          ),
        ],
      ),
    );
  }
}