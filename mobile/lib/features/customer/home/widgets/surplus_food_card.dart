import 'package:flutter/material.dart';

import '../../../../models/food_model.dart';
import '../../../../data/dummy_foods.dart';
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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(
            const SnackBar(
              content: Text(
                'Produk sudah expired',
              ),
            ),
          );

          return;
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FoodDetailPage(
              food: food.toDummyFood(),
            ),
          ),
        );
      },
      child: Card(
        color: food.isExpired
            ? Colors.red.shade50
            : Colors.white,
        margin:
            const EdgeInsets.all(12),
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  food.foto,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, _, _) =>
                          Container(
                    height: 180,
                    color: Colors
                        .grey.shade200,
                    child: const Icon(
                      Icons.fastfood,
                      size: 60,
                    ),
                  ),
                ),

                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          food.isExpired
                              ? Colors.red
                              : Colors.green,
                      borderRadius:
                          BorderRadius
                              .circular(
                        20,
                      ),
                    ),
                    child: Text(
                      food.isExpired
                          ? "EXPIRED"
                          : "TERSEDIA",
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding:
                  const EdgeInsets.all(
                12,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [
                  Text(
                    food.nama,
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 16,
                      color:
                          food.isExpired
                              ? Colors.red
                              : Colors.black,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    food.namaToko,
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    "Expired: ${food.expiredDate}",
                    style: TextStyle(
                      color:
                          food.isExpired
                              ? Colors.red
                              : Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Row(
                    children: [
                      Text(
                        "Rp ${food.hargaDiskon.toInt()}",
                        style:
                            TextStyle(
                          color:
                              food.isExpired
                                  ? Colors.red
                                  : Colors
                                      .green,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                        width: 8,
                      ),

                      Text(
                        "Rp ${food.hargaOriginal.toInt()}",
                        style:
                            const TextStyle(
                          decoration:
                              TextDecoration
                                  .lineThrough,
                          color:
                              Colors.grey,
                        ),
                      ),
                    ],
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