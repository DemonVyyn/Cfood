import 'package:flutter/material.dart';

import '../../../data/dummy_foods.dart';
import '../../food/food_detail_page.dart';

class SurplusFoodCard extends StatelessWidget {
  final DummyFood food;

  const SurplusFoodCard({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FoodDetailPage(food: food),
          ),
        );
      },

      child: Card(
        margin: const EdgeInsets.all(12),

        child: Column(
          children: [
            Image.network(
              food.image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Text(food.name),

                  const SizedBox(height: 5),

                  Text(food.store),

                  const SizedBox(height: 10),

                  Text(
                    "Rp ${food.discountPrice}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}