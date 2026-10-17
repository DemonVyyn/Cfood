import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/dummy_foods.dart';
import 'checkout_card.dart';
import 'eco_bag_toggle.dart';

/// Kartu rincian pesanan (item, toggle eco, instruksi).
class OrderSummaryCard extends StatelessWidget {
  final DummyFood food;
  final int quantity;

  const OrderSummaryCard({
    super.key,
    required this.food,
    this.quantity = 1,
  });

  String _formatPrice(int price) =>
      'Rp ${price.toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+$)'),
            (m) => '${m[1]}.',
          )}';

  String _formatShortPrice(int value) {
    if (value >= 1000) {
      final rb = value / 1000;
      final text = rb == rb.roundToDouble()
          ? rb.toInt().toString()
          : rb.toStringAsFixed(1);
      return 'Rp ${text}rb';
    }
    return 'Rp $value';
  }

  @override
  Widget build(BuildContext context) {
    final totalNormal = food.originalPrice * quantity;
    final totalDiskon = food.discountPrice * quantity;
    final hemat = totalNormal - totalDiskon;

    return CheckoutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: ikon + judul + badge jumlah
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.surfaceContainer),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Rincian Pesanan',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Badge jumlah item
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer
                        .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$quantity Item Box',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      height: 14 / 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Item row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar produk + badge SURPLUS
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      food.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 80,
                        height: 80,
                        color: AppColors.surfaceContainerHigh,
                        child: const Icon(
                          Icons.fastfood,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 4,
                    bottom: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SURPLUS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          height: 13.5 / 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // Info produk + harga
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pastry & Sourdough Pilihan Chef',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        height: 16 / 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Baris harga (Wrap agar turun baris di layar sempit)
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          _formatPrice(totalDiskon),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            height: 24 / 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryContainer,
                          ),
                        ),
                        Text(
                          _formatPrice(totalNormal),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            height: 16 / 12,
                            color: AppColors.outline,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: AppColors.outline,
                          ),
                        ),
                        // Badge hemat
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Hemat ${_formatShortPrice(hemat)}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              height: 14 / 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Toggle eco-friendly
          const EcoBagToggle(),

          const SizedBox(height: 12),

          // Instructions field
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.outline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Isi boks acak sesuai surplus segar harian dari panggangan sore. Dijamin higienis & layak konsumsi 100%.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 16 / 12,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
