import '../models/food_model.dart';

class DummyFood {
  final String image;
  final String name;
  final String store;
  final double rating;
  final int originalPrice;
  final int discountPrice;

  // Surplus flash-deal metadata (Stitch "Customer Home" design)
  final int boxesLeft;
  final int discountPercent;
  final String distance;
  final String pickupTime;

  // Food detail metadata (Stitch "Food Detail & Pickup" design)
  final String category;
  final int sold;
  final int totalStock;

  DummyFood({
    required this.image,
    required this.name,
    required this.store,
    required this.rating,
    required this.originalPrice,
    required this.discountPrice,
    this.boxesLeft = 3,
    this.discountPercent = 0,
    this.distance = '1.0 km',
    this.pickupTime = '19:30 - 21:00',
    this.category = '',
    this.sold = 17,
    this.totalStock = 20,
  });
}

/// Konversi data dari API ([FoodModel]) ke model UI ([DummyFood])
/// yang dipakai halaman detail makanan & checkout.
extension FoodModelMapper on FoodModel {
  DummyFood toDummyFood() {
    final original = hargaOriginal.toInt();
    final discount = hargaDiskon.toInt();
    final percent = original > 0
        ? (((original - discount) / original) * 100).round()
        : 0;

    return DummyFood(
      image: foto,
      name: nama,
      store: namaToko,
      rating: 0,
      originalPrice: original,
      discountPrice: discount,
      boxesLeft: stok,
      discountPercent: percent,
      category: kategori,
      sold: 0,
      totalStock: stok,
    );
  }
}

final dummyFoods = [
  DummyFood(
    image:
        'https://images.unsplash.com/photo-1509440159596-0249088772ff',
    name: 'Artisanal Sourdough & Croissant Box',
    store: 'Kemang Artisan Bakery',
    rating: 4.9,
    originalPrice: 85000,
    discountPrice: 28000,
    boxesLeft: 3,
    discountPercent: 67,
    distance: '1.2 km',
    pickupTime: '19:30 - 21:00',
    category: 'Pastry Prancis, Roti Gandum & Viennoiserie',
    sold: 17,
    totalStock: 20,
  ),
  DummyFood(
    image:
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c',
    name: 'Japanese Bento & Sushi Surplus Set',
    store: 'Sushi Tei Senopati',
    rating: 4.8,
    originalPrice: 110000,
    discountPrice: 45000,
    boxesLeft: 2,
    discountPercent: 59,
    distance: '0.8 km',
    pickupTime: '20:00 - 21:30',
    category: 'Jepang, Sushi & Bento',
    sold: 23,
    totalStock: 25,
  ),
  DummyFood(
    image:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
    name: 'Gourmet Pasta & Salad Mystery Box',
    store: 'Trattoria Cikini',
    rating: 4.7,
    originalPrice: 95000,
    discountPrice: 35000,
    boxesLeft: 5,
    discountPercent: 63,
    distance: '2.1 km',
    pickupTime: '20:30 - 22:00',
    category: 'Italia, Pasta & Salad',
    sold: 12,
    totalStock: 17,
  ),
];
