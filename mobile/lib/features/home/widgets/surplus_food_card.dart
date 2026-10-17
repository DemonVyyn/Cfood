import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/dummy_foods.dart';
import '../../food/food_detail_page.dart';

class SurplusFoodCard extends StatelessWidget {
  final DummyFood food;

  const SurplusFoodCard({
    super.key,
    required this.food,
  });

  String get _formattedOriginalPrice =>
      'Rp ${food.originalPrice.toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+$)'),
            (m) => '${m[1]}.',
          )}';

  String get _formattedDiscountPrice =>
      'Rp ${food.discountPrice.toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+$)'),
            (m) => '${m[1]}.',
          )}';

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodDetailPage(food: food),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isUrgent = food.boxesLeft <= 3;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food image with badges
            Stack(
              children: [
                Image.network(
                  food.image,
                  height: 176,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 176,
                    width: double.infinity,
                    color: AppColors.surfaceContainerHigh,
                    child: const Icon(
                      Icons.fastfood,
                      size: 40,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),

                // Urgent badge
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? AppColors.error
                          : AppColors.secondary,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      'Tersisa ${food.boxesLeft} Box',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        height: 14 / 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),
                ),

                // Discount badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 2,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Text(
                      'Hemat ${food.discountPercent}%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10,
                        height: 14 / 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),

                // Distance chip
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.inverseSurface
                          .withValues(alpha: 0.80),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.near_me,
                          size: 13,
                          color: AppColors.inverseOnSurface,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          food.distance,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            height: 14 / 10,
                            color: AppColors.inverseOnSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store name + rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          food.store,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            height: 16 / 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.primaryContainer,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            food.rating.toString(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              height: 16 / 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // Food name
                  Text(
                    food.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      height: 24 / 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Pickup time chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule,
                          size: 15,
                          color: AppColors.primaryContainer,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Ambil: ${food.pickupTime}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            height: 16 / 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Price row + CTA
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.surfaceContainer,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Prices
                        Flexible(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                _formattedOriginalPrice,
                                maxLines: 1,
                                style: GoogleFonts
                                    .plusJakartaSans(
                                  fontSize: 12,
                                  height: 16 / 12,
                                  color: AppColors.outline,
                                  decoration:
                                      TextDecoration
                                          .lineThrough,
                                  decorationColor:
                                      AppColors.outline,
                                ),
                              ),
                              Text(
                                _formattedDiscountPrice,
                                maxLines: 1,
                                style: GoogleFonts
                                    .plusJakartaSans(
                                  fontSize: 18,
                                  height: 24 / 18,
                                  fontWeight:
                                      FontWeight.w800,
                                  color: AppColors
                                      .primaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Grab-now CTA (satu-satunya pemicu buka detail)
                        GestureDetector(
                          onTap: () => _openDetail(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.ctaGreen,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: 0.04),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Ambil Sekarang',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    height: 20 / 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.shopping_bag,
                                  size: 18,
                                  color: AppColors.onPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
