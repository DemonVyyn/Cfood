import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/surplus_categories.dart';
import '../../category/all_categories_page.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  /// Home hanya menampilkan 5 kategori.
  static const int _visibleCount = 5;

  @override
  Widget build(BuildContext context) {
    final categories =
        surplusCategories.take(_visibleCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Kategori Surplus',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  height: 24 / 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const AllCategoriesPage(),
                    ),
                  );
                },
                child: Text(
                  'Lihat Semua',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 16 / 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Baris kategori: lebar tiap item merata & responsif,
        // jarak antar-item konsisten (setara spaceBetween).
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < categories.length; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child:
                      _CategoryItem(category: categories[i]),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final SurplusCategory category;

  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: filter surplus berdasarkan kategori
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.outlineVariant
                    .withValues(alpha: 0.30),
              ),
            ),
            child: Icon(
              category.icon,
              size: 30,
              color: AppColors.primaryContainer,
            ),
          ),

          const SizedBox(height: 6),

          // Label ikut mengecil kalau layar sempit,
          // jadi tidak pernah terpotong.
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              category.label,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                height: 1.2,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
