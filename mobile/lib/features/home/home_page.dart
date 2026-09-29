import 'package:flutter/material.dart';
import '../../data/dummy_foods.dart';
import '../../widgets/curved_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/search_section.dart';
import 'widgets/impact_card.dart';
import 'widgets/promo_banner.dart';
import 'widgets/category_section.dart';
import 'widgets/surplus_food_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HomeHeader(),

              const SizedBox(height: 16),

              const SearchSection(),

              const SizedBox(height: 16),

              const ImpactCard(),

              const SizedBox(height: 16),

              const PromoBanner(),

              const SizedBox(height: 16),

              const CategorySection(),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      'Ambil Sebelum Habis!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dummyFoods.length,
                itemBuilder: (context, index) {
                  return SurplusFoodCard(food: dummyFoods[index]);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      // Bottom navigation is now handled by HomeShell (SPA).
    );
  }
}
