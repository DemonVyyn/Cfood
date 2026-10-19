import 'package:flutter/material.dart';

import '../../../models/food_model.dart';
import '../../checkout/checkout_page.dart';

class OrderBottomBar extends StatelessWidget {
  final FoodModel food;

  const OrderBottomBar({
    super.key,
    required this.food,
  });

  String _formatPrice(double price) {
    final value = price.round().toString();
    final formatted = value.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final bool isUnavailable = food.isExpired || food.stok <= 0;

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
              _formatPrice(food.hargaDiskon),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isUnavailable ? Colors.grey : Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isUnavailable
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CheckoutPage(
                          food: food,
                          quantity: 1,
                        ),
                      ),
                    );
                  },
            child: Text(
              food.isExpired
                  ? 'Kedaluwarsa'
                  : food.stok <= 0
                      ? 'Stok Habis'
                      : 'Pesan Sekarang',
            ),
          ),
        ],
      ),
    );
  }
}