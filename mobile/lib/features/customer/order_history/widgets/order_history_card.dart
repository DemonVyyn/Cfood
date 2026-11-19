import 'package:flutter/material.dart';

class OrderHistoryCard
    extends StatelessWidget {
  final String title;
  final String store;
  final String price;
  final String status;
  final VoidCallback? onCancel;

  const OrderHistoryCard({
    super.key,
    required this.title,
    required this.store,
    required this.price,
    required this.status,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(store),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment:
              MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Text(price),
            Text(
              status,
              style: const TextStyle(
                color: Colors.green,
              ),
            ),
            if (onCancel != null)
              TextButton(
                onPressed: onCancel,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 24),
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Batalkan',
                  style: TextStyle(fontSize: 11),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
