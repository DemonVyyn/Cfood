import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../data/dummy_foods.dart';
import 'widgets/home_header.dart';
import 'widgets/search_section.dart';
import 'widgets/category_section.dart';
import 'widgets/surplus_food_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),

              const SearchSection(),

              const SizedBox(height: 20),

              const CategorySection(),

              const SizedBox(height: 20),

              // Flash deals header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Pulsing live indicator
                        Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          'Ambil Sebelum Habis!',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            height: 24 / 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),

                    // Flash deals badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.errorContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Flash Deals 🔥',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          height: 14 / 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Surplus food cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: dummyFoods.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SurplusFoodCard(food: dummyFoods[index]),
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // Bottom navigation is now handled by HomeShell (SPA).
    );
  }
}
