import 'package:flutter/material.dart';
import '../../../models/merchant_product_model.dart';

class StockItemCard extends StatelessWidget {
  final List<MerchantProductModel> stocks;

  const StockItemCard({
    super.key,
    required this.stocks,
  });

  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color textColor = Color(0xFF263126);

  @override
  Widget build(BuildContext context) {
    if (stocks.isEmpty) {
      return Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 38,
                color: darkGreen,
              ),
              SizedBox(height: 10),
              Text(
                'Belum ada produk surplus',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: stocks.map((item) {
          return Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: CircleAvatar(
                  radius: 23,
                  backgroundColor: const Color(0xFFE8F9E9),
                  child: const Icon(
                    Icons.fastfood_rounded,
                    color: darkGreen,
                  ),
                ),
                title: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stok: ${item.stock}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Expired: ${item.expiredFormatted}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Text(
                  'Rp ${item.discountPrice.toInt()}',
                  style: const TextStyle(
                    color: darkGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (item != stocks.last)
                Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: Colors.grey.shade200,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}