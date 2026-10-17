import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/merchant_product_model.dart';
import '../../../providers/merchant_product_provider.dart';
import '../../../providers/merchant_provider.dart';
import '../../../providers/location_provider.dart';
import 'widgets/product_card.dart';

const Color _primaryGreen = Color(0xFF0CB52A);
const Color _backgroundColor = Color(0xFFF5F8F6);
const Color _expiredRed = Color(0xFFD92D20);

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool loaded = false;
  String selectedFilter = 'semua';

  Future<void> _loadInitialData() async {
    final productProvider = context.read<MerchantProductProvider>();
    final merchantProvider = context.read<MerchantProvider>();

    await productProvider.loadProducts();

    if (!mounted) return;

    await merchantProvider.loadDashboard();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!loaded) {
      loaded = true;
      Future.microtask(_loadInitialData);
    }
  }

  Future<void> refreshData() async {
    final productProvider = context.read<MerchantProductProvider>();
    final merchantProvider = context.read<MerchantProvider>();

    await productProvider.loadProducts();

    if (!mounted) return;

    await merchantProvider.refreshDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<MerchantProductProvider>();
    final locationProvider = context.watch<LocationProvider>();
    final merchantProvider = context.watch<MerchantProvider>();

    final storeName =
        merchantProvider.dashboard?.storeName ?? 'Toko Mitra';

    final allProducts = productProvider.products;
    final now = DateTime.now();

    // Produk yang masih memiliki stok.
    final activeProducts =
        allProducts.where((product) => product.stock > 0).toList();

    // Produk yang stoknya habis.
    final soldOutProducts =
        allProducts.where((product) => product.stock <= 0).toList();

    // Produk yang tanggal kedaluwarsanya sudah lewat.
    final expiredProducts = allProducts.where((product) {
      final expiredDate = DateTime.tryParse(product.expiredAt);

      return expiredDate != null && expiredDate.isBefore(now);
    }).toList();

    final List<MerchantProductModel> filteredProducts;

    switch (selectedFilter) {
      case 'aktif':
        filteredProducts = activeProducts;
        break;
      case 'habis':
        filteredProducts = soldOutProducts;
        break;
      case 'expired':
        filteredProducts = expiredProducts;
        break;
      default:
        filteredProducts = allProducts;
    }

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildStoreHeader(
              storeName: storeName,
              locationName: locationProvider.locationName,
            ),
            Expanded(
              child: RefreshIndicator(
                color: _primaryGreen,
                onRefresh: refreshData,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 120),
                  children: [
                    const Text(
                      'Kelola Produk Surplus',
                      style: TextStyle(
                        fontSize: 25,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF17251D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selamatkan makanan berlebih dan kurangi limbah organik.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Filter produk berdasarkan status.
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: 'Semua Produk',
                            count: allProducts.length,
                            value: 'semua',
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Produk Aktif',
                            count: activeProducts.length,
                            value: 'aktif',
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Habis',
                            count: soldOutProducts.length,
                            value: 'habis',
                          ),
                          const SizedBox(width: 8),
                          _buildFilterChip(
                            label: 'Expired',
                            count: expiredProducts.length,
                            value: 'expired',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildTipsCard(),
                    const SizedBox(height: 22),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Daftar Produk',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF17251D),
                            ),
                          ),
                        ),
                        Text(
                          '${filteredProducts.length} produk',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    if (filteredProducts.isEmpty)
                      _buildEmptyState()
                    else
                      ...filteredProducts.map(
                        (product) => ProductCard(product: product),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/merchant-add-product');
            },
            icon: const Icon(Icons.add_rounded, size: 24),
            label: const Text(
              'Tambah Produk Surplus',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryGreen,
              foregroundColor: Colors.white,
              elevation: 5,
              shadowColor: _primaryGreen.withValues(alpha: 0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreHeader({
    required String storeName,
    required String locationName,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE4F5E9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: _primaryGreen,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        storeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF17251D),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5F5E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'MITRA',
                        style: TextStyle(
                          fontSize: 9,
                          color: _primaryGreen,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: _primaryGreen,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        locationName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required int count,
    required String value,
  }) {
    final selected = selectedFilter == value;

    return InkWell(
      onTap: () {
        setState(() => selectedFilter = value);
      },
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: selected ? _primaryGreen : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? _primaryGreen : const Color(0xFFE1E8E3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : const Color(0xFF47534B),
              ),
            ),
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withValues(alpha: 0.2)
                    : const Color(0xFFF0F4F1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : _primaryGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF7ED),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFD5EEDB)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.lightbulb_outline_rounded,
              color: _primaryGreen,
              size: 23,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Penjualan Surplus',
                  style: TextStyle(
                    color: _primaryGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Perbarui stok dan harga produk secara berkala agar makanan surplus lebih mudah diselamatkan.',
                  style: TextStyle(
                    color: Color(0xFF496353),
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;

    switch (selectedFilter) {
      case 'aktif':
        message = 'Belum ada produk dengan stok tersedia.';
        break;
      case 'habis':
        message = 'Belum ada produk yang stoknya habis.';
        break;
      case 'expired':
        message = 'Belum ada produk yang kedaluwarsa.';
        break;
      default:
        message = 'Produk yang tersedia akan ditampilkan di sini.';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 36,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE7EDE8)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7ED),
              shape: BoxShape.circle,
            ),
            child: Icon(
              selectedFilter == 'expired'
                  ? Icons.warning_amber_rounded
                  : Icons.inventory_2_outlined,
              size: 30,
              color: selectedFilter == 'expired'
                  ? _expiredRed
                  : _primaryGreen,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Tidak ada produk',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: Color(0xFF17251D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}