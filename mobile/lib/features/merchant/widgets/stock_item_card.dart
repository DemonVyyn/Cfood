import 'package:flutter/material.dart';

class StockItemCard
    extends StatelessWidget {
  final List<dynamic> stocks;

  const StockItemCard({
    super.key,
    required this.stocks,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),
            
        child: Column(
          children: stocks.map(
            (item) {
              return ListTile(
                leading:
                    const Icon(
                  Icons.fastfood,
                ),

                title: Text(
                  item['nama'] ?? '-',
                ),

                subtitle: Text(
                  "Stok : ${item['stok']}",
                ),

                trailing: Text(
                  "Rp ${item['harga_diskon']}",
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

}