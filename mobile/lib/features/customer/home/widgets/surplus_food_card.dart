import 'package:flutter/material.dart';

import '../../../../models/food_model.dart';
import '../../../food/food_detail_page.dart';

class SurplusFoodCard extends StatelessWidget {
  final FoodModel food;

  const SurplusFoodCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (food.isExpired) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Produk sudah expired'),
            ),
          );
          return;
        }

        if (food.stok <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Stok makanan sudah habis'),
            ),
          );
          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodDetailPage(
              food: food,
            ),
          ),
        );
      },
      child: Card(
        color: food.isExpired ? Colors.red.shade50 : Colors.white,
        margin: const EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _buildFoodImage(),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: food.isExpired
                          ? Colors.red
                          : food.stok > 0
                              ? Colors.green
                              : Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      food.isExpired
                          ? 'EXPIRED'
                          : food.stok > 0
                              ? 'TERSEDIA'
                              : 'STOK HABIS',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),

                if (food.persenDiskon > 0)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'HEMAT ${food.persenDiskon}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: food.isExpired
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Row(
                    children: [
                      const Icon(
                        Icons.storefront,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          food.namaToko.isNotEmpty
                              ? food.namaToko
                              : 'Mitra CheaFood',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (food.kategori.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      'Kategori: ${food.kategori}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],

                  if (food.expiredDate.isNotEmpty) ...[
                    const SizedBox(height: 5),
                    Text(
                      'Expired: ${food.expiredDate}',
                      style: TextStyle(
                        color: food.isExpired
                            ? Colors.red
                            : Colors.grey.shade700,
                        fontSize: 12,
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          _formatPrice(food.hargaDiskon),
                          style: TextStyle(
                            color: food.isExpired
                                ? Colors.red
                                : Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      if (food.hargaOriginal > food.hargaDiskon)
                        Flexible(
                          child: Text(
                            _formatPrice(food.hargaOriginal),
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),

                      const Spacer(),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: food.stok > 0
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Stok ${food.stok}',
                          style: TextStyle(
                            color: food.stok > 0
                                ? Colors.green.shade900
                                : Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (food.isExpired) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Produk ini sudah melewati tanggal kedaluwarsa.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodImage() {
    if (food.foto.isEmpty) {
      return _imagePlaceholder();
    }

    return Image.network(
      food.foto,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _imagePlaceholder();
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.fastfood,
          size: 60,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _formatPrice(num price) {
    final value = price.round().toString();

    return 'Rp ${value.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]}.',
    )}';
  }
}
