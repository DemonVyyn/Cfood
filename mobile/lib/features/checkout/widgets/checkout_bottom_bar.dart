import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../pickup/pickup_qr_page.dart';

/// Sticky action bar: CTA konfirmasi + badge garansi.
class CheckoutBottomBar extends StatelessWidget {
  final int total;
  final VoidCallback? onConfirm;

  const CheckoutBottomBar({
    super.key,
    required this.total,
    this.onConfirm,
  });

  String get _formattedTotal =>
      'Rp ${total.toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+$)'),
            (m) => '${m[1]}.',
          )}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF002D0D).withValues(alpha: 0.09),
            blurRadius: 28,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Primary CTA
            GestureDetector(
              onTap: onConfirm ??
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PickupQrPage(),
                      ),
                    );
                  },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.ctaGreen,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.qr_code_2,
                            size: 22,
                            color: AppColors.onPrimary,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Konfirmasi & Dapatkan QR Pickup',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                height: 20 / 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Text(
                          _formattedTotal,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward,
                          size: 18,
                          color: AppColors.onPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Security / guarantees badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _guarantee(
                  icon: Icons.verified_user,
                  label: 'Garansi Kualitas Segar',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    '•',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      height: 16.5 / 11,
                      color: AppColors.outlineVariant,
                    ),
                  ),
                ),
                _guarantee(
                  icon: Icons.lock,
                  label: 'Reservasi Aman Instan',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _guarantee({
    required IconData icon,
    required String label,
  }) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.primary),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                height: 16.5 / 11,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
