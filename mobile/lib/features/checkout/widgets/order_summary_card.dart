import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "Ringkasan Pesanan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(10),
                child: Image.network(
                  "https://images.unsplash.com/photo-1509440159596-0249088772ff",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Artisanal Sourdough Box",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Kemang Artisan Bakery",
                    ),
                  ],
                ),
              ),
            ],
          ),

          const Divider(height: 30),

          _buildPriceRow(
            "Harga Awal",
            "Rp 85.000",
          ),

          const SizedBox(height: 8),

          _buildPriceRow(
            "Diskon Food Rescue",
            "- Rp 57.000",
            valueColor: Colors.red,
          ),

          const Divider(height: 30),

          _buildPriceRow(
            "Total",
            "Rp 28.000",
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String title,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(title),

        Text(
          value,
          style: TextStyle(
            fontWeight:
                isBold
                    ? FontWeight.bold
                    : FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}