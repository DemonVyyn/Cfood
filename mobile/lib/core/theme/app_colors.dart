import 'package:flutter/material.dart';

/// Material-Eco design tokens extracted from the Stitch screen
/// "CFood - Customer Home" (Mealio Food Surplus Platform).
abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF00450D);
  static const Color primaryContainer = Color(0xFF1B5E20);
  static const Color onPrimaryContainer = Color(0xFF90D689);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color primaryFixed = Color(0xFFACF4A4);
  static const Color primaryFixedDim = Color(0xFF91D78A);

  /// Hijau aksen untuk tombol CTA — sama dengan warna
  /// CurvedNavigationBar di home shell (#14DE32).
  static const Color ctaGreen = Color(0xFF14DE32);

  // Secondary
  static const Color secondary = Color(0xFF006E1C);
  static const Color secondaryContainer = Color(0xFF91F78E);
  static const Color onSecondaryContainer = Color(0xFF00731E);
  static const Color secondaryFixed = Color(0xFF94F990);
  static const Color secondaryFixedDim = Color(0xFF78DC77);

  // Tertiary
  static const Color tertiary = Color(0xFF174321);

  // Surfaces
  static const Color surface = Color(0xFFFCF9F8);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF6F3F2);
  static const Color surfaceContainer = Color(0xFFF0EDED);
  static const Color surfaceContainerHigh = Color(0xFFEAE7E7);
  static const Color surfaceContainerHighest = Color(0xFFE5E2E1);

  // Outline
  static const Color outline = Color(0xFF717A6D);
  static const Color outlineVariant = Color(0xFFC0C9BB);

  // On-colors
  static const Color onSurface = Color(0xFF1B1C1C);
  static const Color onSurfaceVariant = Color(0xFF41493E);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Inverse
  static const Color inverseSurface = Color(0xFF303030);
  static const Color inverseOnSurface = Color(0xFFF3F0EF);
}
