import 'package:flutter/material.dart';

class SurplusCategory {
  final String label;
  final IconData icon;

  const SurplusCategory({
    required this.label,
    required this.icon,
  });
}

/// Master daftar kategori surplus.
///
/// - Home hanya menampilkan 5 teratas (`take(5)`).
/// - Halaman "Lihat Semua" menampilkan seluruh daftar ini, jadi kalau
///   nanti ada kategori baru, cukup tambahkan di sini.
const surplusCategories = <SurplusCategory>[
  SurplusCategory(label: 'Bakery', icon: Icons.bakery_dining),
  SurplusCategory(label: 'Restoran', icon: Icons.restaurant),
  SurplusCategory(label: 'Cafe', icon: Icons.local_cafe),
  SurplusCategory(label: 'Hotel Buffet', icon: Icons.ramen_dining),
  SurplusCategory(label: 'Supermarket', icon: Icons.storefront),
];
