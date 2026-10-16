import 'package:flutter/material.dart';

class StoreHeader
    extends StatelessWidget {
  const StoreHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 45,
          backgroundColor:
              Colors.green.shade100,
          child: const Icon(
            Icons.store,
            size: 40,
            color: Colors.green,
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Kemang Artisan Bakery',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}