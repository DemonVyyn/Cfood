import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/food_provider.dart';
import '../../models/food_model.dart';
import '../../widgets/curved_bottom_nav.dart';
import 'food_detail_page.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _loadFoods();
    });
  }

  Future<void> _loadFoods() async {
    try {
      await context.read<FoodProvider>().loadFoods();
    } catch (e) {
      debugPrint('Gagal memuat makanan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Makanan Surplus'),
      ),
      body: Consumer<FoodProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.foods.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.foods.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.restaurant,
                      size: 56,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Belum ada makanan tersedia',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _loadFoods,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Muat ulang'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadFoods,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 16,
              ),
              itemCount: provider.foods.length,
              itemBuilder: (context, index) {
                final FoodModel food = provider.foods[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FoodDetailPage(
                            food: food,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFoodImage(food),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.nama,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                food.namaToko.isNotEmpty
                                    ? food.namaToko
                                    : 'Mitra CheaFood',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                food.deskripsi,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      _formatPrice(food.hargaDiskon),
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (food.hargaOriginal >
                                      food.hargaDiskon)
                                    Flexible(
                                      child: Text(
                                        _formatPrice(
                                          food.hargaOriginal,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration
                                                  .lineThrough,
                                        ),
                                      ),
                                    ),
                                  const Spacer(),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: food.stok > 0
                                          ? Colors.green.shade100
                                          : Colors.red.shade100,
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      food.stok > 0
                                          ? 'Stok ${food.stok}'
                                          : 'Stok habis',
                                      style: TextStyle(
                                        color: food.stok > 0
                                            ? Colors.green.shade900
                                            : Colors.red.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (food.persenDiskon > 0) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Hemat ${food.persenDiskon}%',
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: const CurvedBottomNav(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildFoodImage(FoodModel food) {
    if (food.foto.isEmpty) {
      return _imagePlaceholder();
    }

    return Image.network(
      food.foto,
      width: double.infinity,
      height: 180,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _imagePlaceholder();
      },
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 180,
      color: Colors.grey.shade200,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  String _formatPrice(num price) {
    final value = price.round().toString();

    return 'Rp ${value.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]}.',
    )}';
  }
}
