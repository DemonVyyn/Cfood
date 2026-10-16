import 'package:flutter/material.dart';

import 'category_chip.dart';

class CategorySection extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String>? onSelected;

  const CategorySection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (_, index) {
          final category =
              categories[index];

          return CategoryChip(
            label: category,
            selected:
                category ==
                selectedCategory,
            onTap: () =>
                onSelected?.call(category),
          );
        },
      ),
    );
  }
}