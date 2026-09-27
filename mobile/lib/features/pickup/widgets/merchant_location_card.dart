import 'package:flutter/material.dart';

class MerchantLocationCard
    extends StatelessWidget {
  const MerchantLocationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              "Kemang Artisan Bakery",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Jl. Kemang Raya No.14, Jakarta Selatan",
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.navigation,
                ),
                label: const Text(
                  "Buka Peta",
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.green,
                  foregroundColor:
                      Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}