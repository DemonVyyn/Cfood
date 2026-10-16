import 'package:flutter/material.dart';

class OrderHistoryCard
    extends StatelessWidget {
  final String title;
  final String store;
  final String price;
  final String status;

  const OrderHistoryCard({
    super.key,
    required this.title,
    required this.store,
    required this.price,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(store),
        trailing: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(price),
            Text(
              status,
              style: const TextStyle(
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}