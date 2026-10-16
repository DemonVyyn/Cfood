import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/food_provider.dart';
import 'surplus_food_card.dart';

class FoodListSection extends StatelessWidget {
  const FoodListSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<FoodProvider>();

    if (provider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (provider.foods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Text(
            'Belum ada produk surplus',
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: provider.foods.length,
      itemBuilder: (context, index) {
        return SurplusFoodCard(
          food: provider.filteredFoods[index],
        );
      },
    );
  }
}