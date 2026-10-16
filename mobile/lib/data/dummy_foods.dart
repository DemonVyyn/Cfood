class DummyFood {
  final String image;
  final String name;
  final String store;
  final double rating;
  final int originalPrice;
  final int discountPrice;

  DummyFood({
    required this.image,
    required this.name,
    required this.store,
    required this.rating,
    required this.originalPrice,
    required this.discountPrice,
  });
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
  ),
  DummyFood(
    image:
        'https://images.unsplash.com/photo-1579871494447-9811cf80d66c',
    name: 'Japanese Bento & Sushi',
    store: 'Sushi Tei',
    rating: 4.8,
    originalPrice: 90000,
    discountPrice: 45000,
  ),
  DummyFood(
    image:
        'https://images.unsplash.com/photo-1512621776951-a57141f2eefd',
    name: 'Gourmet Pasta & Salad',
    store: 'Trattoria Cile',
    rating: 4.7,
    originalPrice: 75000,
    discountPrice: 35000,
  ),
];