import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/food_provider.dart';
import '../../../widgets/curved_bottom_nav.dart';

import 'widgets/home_header.dart';
import 'widgets/search_section.dart';
import 'widgets/impact_card.dart';
import 'widgets/promo_banner.dart';
import 'widgets/category_section.dart';
import 'widgets/section_title.dart';
import 'widgets/food_list_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  bool loaded = false;

  String selectedCategory = 'Semua';

  final List<String> categories = const [
    'Semua',
    'Bakery',
    'Restoran',
    'Cafe',
    'Hotel',
    'Supermarket',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!loaded) {
      loaded = true;

      Future.microtask(() async {
        if (!mounted) return;

        await context
            .read<FoodProvider>()
            .loadFoods();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<FoodProvider>();

    final foods = provider.foods;

    final totalProducts =
        foods.length;

    final totalStock = foods.fold(
      0,
      (sum, food) => sum + food.stok,
    );

    int highestDiscount = 0;

    if (foods.isNotEmpty) {
      highestDiscount = foods
          .map((food) {
            if (food.hargaOriginal <= 0) {
              return 0;
            }

            return (((food.hargaOriginal -
                            food.hargaDiskon) /
                        food.hargaOriginal) *
                    100)
                .round();
          })
          .reduce(
            (a, b) => a > b ? a : b,
          );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FA),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await context
                .read<FoodProvider>()
                .loadFoods();
          },
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                HomeHeader(
                  userName: 'Tama',
                  totalFoods:
                      totalProducts,
                ),

                const SizedBox(
                  height: 16,
                ),

                const SearchSection(),

                const SizedBox(
                  height: 16,
                ),

                ImpactCard(
                  totalProducts:
                      totalProducts,
                  totalStock:
                      totalStock,
                ),

                const SizedBox(
                  height: 16,
                ),

                PromoBanner(
                  highestDiscount:
                      highestDiscount,
                ),

                const SizedBox(
                  height: 16,
                ),

                CategorySection(
                  categories:
                      categories,
                  selectedCategory:
                      selectedCategory,
                  onSelected:
                      (category) {
                    setState(() {
                      selectedCategory =
                          category;
                    });
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                const SectionTitle(
                  title:
                      'Ambil Sebelum Habis!',
                ),

                const SizedBox(
                  height: 12,
                ),

                const FoodListSection(),

                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar:
          const CurvedBottomNav(
        currentIndex: 0,
      ),
    );
  }
}