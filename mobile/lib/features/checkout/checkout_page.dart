import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/food_model.dart';
import 'widgets/pay_notice_banner.dart';
import 'widgets/pickup_location_card.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/payment_summary_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/checkout_bottom_bar.dart';

/// Halaman Checkout - Konfirmasi Pesanan.
/// Menggunakan FoodModel dari API, bukan DummyFood.
class CheckoutPage extends StatelessWidget {
  final FoodModel food;
  final int quantity;

  const CheckoutPage({
    super.key,
    required this.food,
    this.quantity = 1,
  });

  @override
  Widget build(BuildContext context) {
    final item = food;
    final total = item.hargaDiskon.round() * quantity;

    final topPadding = MediaQuery.of(context).padding.top;
    const headerContentHeight = 56.0;
    const bottomBarHeight = 132.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // Konten checkout yang dapat di-scroll.
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              16,
              topPadding + headerContentHeight + 16,
              16,
              bottomBarHeight + 24,
            ),
            child: Column(
              children: [
                const PayNoticeBanner(),
                const SizedBox(height: 16),

                PickupLocationCard(
                  food: item,
                ),
                const SizedBox(height: 16),

                OrderSummaryCard(
                  food: item,
                  quantity: quantity,
                ),
                const SizedBox(height: 16),

                PaymentSummaryCard(
                  food: item,
                  quantity: quantity,
                ),
                const SizedBox(height: 16),

                const PaymentMethodCard(),
              ],
            ),
          ),

          // Header overlay.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildHeader(context, topPadding),
          ),

          // Bottom bar overlay.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CheckoutBottomBar(
              total: total,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double topPadding) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        16,
        topPadding + 8,
        16,
        8,
      ),
      child: Row(
        children: [
          // Tombol kembali.
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Judul dan subtitle.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Konfirmasi Pesanan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    height: 24 / 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.45,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Langkah terakhir penyelamatan pangan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Ikon eco.
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withValues(
                alpha: 0.4,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.eco,
              size: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
