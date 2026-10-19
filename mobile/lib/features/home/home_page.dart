import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/food_provider.dart';
import 'widgets/home_header.dart';
import 'widgets/search_section.dart';
import 'widgets/category_section.dart';
import 'widgets/surplus_food_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_requested) {
      _requested = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<FoodProvider>().loadFoods();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Consumer<FoodProvider>(
          builder: (context, foodProvider, child) {
            final foods = foodProvider.filteredFoods;

            return RefreshIndicator(
              color: const Color(0xFF0CB52A),
              onRefresh: foodProvider.loadFoods,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  const HomeHeader(),
                  const SearchSection(),
                  const SizedBox(height: 20),
                  const CategorySection(),
                  const SizedBox(height: 20),

                  // Flash Deals header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Ambil Sebelum Habis!',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    height: 24 / 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
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

                  // Loading state
                  if (foodProvider.isLoading && foodProvider.foods.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF0CB52A),
                        ),
                      ),
                    )

                  // Empty state
                  else if (foods.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.fastfood_outlined,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Makanan tidak ditemukan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            foodProvider.foods.isEmpty
                                ? 'Belum ada makanan yang tersedia.'
                                : 'Coba gunakan kata kunci atau kategori lain.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (!foodProvider.isLoading)
                            TextButton.icon(
                              onPressed: foodProvider.loadFoods,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Muat Ulang'),
                            ),
                        ],
                      ),
                    )

                  // Food cards from API
                  else
                    ...foods.map(
                      (food) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: SurplusFoodCard(food: food),
                      ),
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}