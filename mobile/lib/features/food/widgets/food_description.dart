import 'package:flutter/material.dart';

class FoodDescription extends StatelessWidget {
  final String foodName;

  const FoodDescription({
    super.key,
    required this.foodName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            "Deskripsi Makanan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "$foodName merupakan makanan surplus berkualitas yang masih layak dikonsumsi dan diselamatkan dari food waste.",
          ),

          const SizedBox(height: 16),

          Container(
            padding:
                const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color:
                  Colors.green.shade50,
              borderRadius:
                  BorderRadius.circular(12),
            ),

            child: const Text(
              "Dengan membeli makanan ini, Anda ikut mengurangi limbah makanan dan mendukung keberlanjutan lingkungan.",
            ),
          ),
        ],
      ),
    );
  }
}