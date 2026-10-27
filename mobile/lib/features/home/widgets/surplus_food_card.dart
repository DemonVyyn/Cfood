import 'package:flutter/material.dart';
import '../../../models/food_model.dart';
import '../../checkout/checkout_page.dart';
import '../../../core/constants/app_constants.dart';

class SurplusFoodCard extends StatelessWidget {
  final FoodModel food;

  const SurplusFoodCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUnavailable = food.isExpired || food.stok <= 0;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            food.foto.startsWith('http')
                ? food.foto
                : '${AppConstants.imageBaseUrl}/${food.foto}',
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox(
                height: 150,
                child: Center(
                  child: Icon(Icons.image_not_supported, size: 40),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food.nama,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(food.namaToko),
                const SizedBox(height: 8),
                Text(
                  'Rp ${food.hargaDiskon.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0CB52A),
                  ),
                ),
                if (food.hargaOriginal > food.hargaDiskon)
                  Text(
                    'Rp ${food.hargaOriginal.toStringAsFixed(0)}',
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                if (food.persenDiskon > 0)
                  Text('Diskon ${food.persenDiskon}%'),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUnavailable
                          ? Colors.grey
                          : const Color(0xFF0CB52A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                      isUnavailable
                          ? (food.isExpired
                              ? 'Kedaluwarsa'
                              : 'Stok Habis')
                          : 'Ambil Sekarang',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
