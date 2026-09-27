import 'package:flutter/material.dart';

class MerchantOrderCard
    extends StatelessWidget {
  const MerchantOrderCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.green.shade100,
          child: const Icon(
            Icons.shopping_bag,
            color: Colors.green,
          ),
        ),

        title: const Text(
          'Dimas Pratama',
        ),

        subtitle: const Text(
          'Mystery Bakery Box',
        ),

        trailing: ElevatedButton(
          onPressed: () {},
          child: const Text(
            'Lihat',
          ),
        ),
      ),
    );
  }
}