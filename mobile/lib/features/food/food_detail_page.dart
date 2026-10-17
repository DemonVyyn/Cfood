import 'package:flutter/material.dart';

import '../../models/food_model.dart';

import 'widgets/food_detail_header.dart';
import 'widgets/food_store_card.dart';
import 'widgets/food_info_card.dart';
import 'widgets/food_bottom_bar.dart';
import 'widgets/food_badge.dart';
import '../../widgets/curved_bottom_nav.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodModel food;

  const FoodDetailPage({
    super.key,
    required this.food,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          food.isExpired
              ? Colors.grey
              : const Color(0xff166534),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                FoodDetailHeader(food: food),

                Transform.translate(
                  offset: const Offset(0, -20),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              FoodBadge(
                                text: "Stok ${food.stok}",
                                color: Colors.orange,
                              ),

                              const SizedBox(width: 8),

                              const FoodBadge(
                                text: "🌿 Hemat",
                                color: Colors.green,
                              ),

                              const Spacer(),

                              const FoodBadge(
                                text: "CFood",
                                color: Colors.green,
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          FoodStoreCard(food: food),

                          const SizedBox(height: 24),

                          FoodInfoCard(food: food),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          FoodBottomBar(food: food),
        ],
      ),
      bottomNavigationBar:
          const CurvedBottomNav(
        currentIndex: 0,
      )
    );
  }
}