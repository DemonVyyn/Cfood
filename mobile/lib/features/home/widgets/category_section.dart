import 'package:flutter/material.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      "Bakery",
      "Restoran",
      "Cafe",
      "Hotel",
      "Supermarket",
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,

        itemBuilder: (context, index) {
          return Container(
            margin:
                const EdgeInsets.symmetric(
              horizontal: 8,
            ),

            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: Center(
              child: Text(
                categories[index],
              ),
            ),
          );
        },
      ),
    );
  }
}