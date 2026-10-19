
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/food_model.dart';
import 'checkout_card.dart';

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 3.0;
        const dashSpace = 2.0;
        final count =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => Container(
              width: dashWidth,
              height: 1,
              color: AppColors.outlineVariant.withValues(alpha: 0.6),
            ),
          ),
        );
      },
    );
  }
}

class PaymentSummaryCard extends StatelessWidget {
  final FoodModel food;
  final int quantity;

  const PaymentSummaryCard({
    super.key,
    required this.food,
    this.quantity = 1,
  });

  String _formatPrice(num price) {
    final value = price.round().toString();
    final formatted = value.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final totalNormal = food.hargaOriginal * quantity;
    final totalDiskon = food.hargaDiskon * quantity;
    final potongan = totalNormal - totalDiskon;

    return CheckoutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Ringkasan Pembayaran',
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
          const SizedBox(height: 12),
          Column(
            children: [
              _summaryRow(
                label: 'Total Harga Normal',
                value: _formatPrice(totalNormal),
                valueWeight: FontWeight.w500,
              ),
              const SizedBox(height: 8),
              _summaryRow(
                label: 'Potongan Surplus Food',
                labelColor: AppColors.primary,
                showOfferIcon: true,
                value: '-${_formatPrice(potongan)}',
                valueColor: AppColors.primary,
              ),
              const SizedBox(height: 8),
              _summaryRow(
                label: 'Biaya Layanan',
                badge: 'Gratis Hari Ini',
                value: 'Rp 0',
                valueColor: AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _DashedDivider(),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Bayar di Outlet',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      'Bayar saat kamu ambil pesanan',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        height: 16 / 11,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatPrice(totalDiskon),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  height: 28 / 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryContainer,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    Color labelColor = AppColors.onSurfaceVariant,
    Color valueColor = AppColors.onSurface,
    FontWeight valueWeight = FontWeight.w700,
    bool showOfferIcon = false,
    String? badge,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    height: 20 / 14,
                    color: labelColor,
                  ),
                ),
              ),
              if (showOfferIcon) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.local_offer,
                  size: 14,
                  color: AppColors.primary,
                ),
              ],
              if (badge != null) ...[
                const SizedBox(width: 4),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      badge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        height: 20 / 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            height: 20 / 14,
            fontWeight: valueWeight,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
