import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/merchant_product_model.dart';
import '../../../providers/merchant_product_provider.dart';
import '../../../providers/merchant_provider.dart';
import '../../../widgets/merchant_bottom_nav.dart';

import '../../../providers/location_provider.dart';

import 'widgets/product_card.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({
    super.key,
  });

  @override
  State<ProductListPage> createState() =>
      _ProductListPageState();
      
}

class _ProductListPageState
    extends State<ProductListPage> {

      Future<void> _loadInitialData() async {
  final productProvider =
      context.read<MerchantProductProvider>();

  final merchantProvider =
      context.read<MerchantProvider>();

  await productProvider.loadProducts();

  if (!mounted) {
    return;
  }

  await merchantProvider.loadDashboard();
}
  bool loaded = false;

  String selectedFilter = 'semua';


 @override
void didChangeDependencies() {
  super.didChangeDependencies();

  if (!loaded) {
    loaded = true;

   Future.microtask(() async {
  await _loadInitialData();
});
  }
}

 Future<void> refreshData() async {
  final productProvider =
      context.read<MerchantProductProvider>();

  final merchantProvider =
      context.read<MerchantProvider>();

  await productProvider.loadProducts();

  if (!mounted) {
    return;
  }

  await merchantProvider.refreshDashboard();
}

  @override
  Widget build(
    BuildContext context,
  ) {
    final productProvider =
        context.watch<
            MerchantProductProvider>();

    final locationProvider =
    context.watch<
        LocationProvider>();

    final merchantProvider =
        context.watch<
            MerchantProvider>();

    final storeName =
        merchantProvider
                .dashboard
                ?.storeName ??
            'Toko Mitra';

    final allProducts =
        productProvider.products;

    final activeProducts =
        allProducts
            .where(
              (e) =>
                  e.stock > 0,
            )
            .toList();

    final soldOutProducts =
        allProducts
            .where(
              (e) =>
                  e.stock <= 0,
            )
            .toList();

    List<MerchantProductModel>
        filteredProducts;

    switch (selectedFilter) {
      case 'aktif':
        filteredProducts =
            activeProducts;
        break;

      case 'habis':
        filteredProducts =
            soldOutProducts;
        break;

      default:
        filteredProducts =
            allProducts;
    }

    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF5F7FA,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding:
                  const EdgeInsets.all(
                16,
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.green,
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                    child: const Icon(
                      Icons.store,
                      color:
                          Colors.white,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                storeName,
                                maxLines: 1,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    8,
                                vertical:
                                    2,
                              ),
                              decoration:
                                  BoxDecoration(
                                color: Colors
                                    .grey
                                    .shade200,
                                borderRadius:
                                    BorderRadius.circular(
                                  20,
                                ),
                              ),
                              child:
                                  const Text(
                                'MITRA',
                                style:
                                    TextStyle(
                                  fontSize:
                                      11,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 4,
                        ),

                        Row(
  children: [
    const Icon(
      Icons.location_on,
      size: 16,
      color: Colors.red,
    ),
    const SizedBox(
      width: 4,
    ),
    Expanded(
      child: Text(
  locationProvider.locationName,
  maxLines: 1,
  overflow:
      TextOverflow.ellipsis,
  style: const TextStyle(
    color: Colors.grey,
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
            ),

            Expanded(
              child:
                  RefreshIndicator(
                onRefresh:
                    refreshData,
                child: ListView(
                  padding:
                      const EdgeInsets.all(
                    16,
                  ),
                  children: [
                    const Text(
                      'Kelola Produk Surplus',
                      style:
                          TextStyle(
                        fontSize:
                            28,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    const SizedBox(
                      height: 6,
                    ),

                    const Text(
                      'Selamatkan porsi makanan berlebih & kurangi limbah organik',
                      style:
                          TextStyle(
                        color:
                            Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    SizedBox(
                      height: 42,
                      child: ListView(
                        scrollDirection:
                            Axis.horizontal,
                        children: [
                          _buildFilterChip(
                            'Semua (${allProducts.length})',
                            selectedFilter ==
                                'semua',
                            () {
                              setState(() {
                                selectedFilter =
                                    'semua';
                              });
                            },
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          _buildFilterChip(
                            'Aktif (${activeProducts.length})',
                            selectedFilter ==
                                'aktif',
                            () {
                              setState(() {
                                selectedFilter =
                                    'aktif';
                              });
                            },
                          ),

                          const SizedBox(
                            width: 8,
                          ),

                          _buildFilterChip(
                            'Habis (${soldOutProducts.length})',
                            selectedFilter ==
                                'habis',
                            () {
                              setState(() {
                                selectedFilter =
                                    'habis';
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                        border:
                            Border.all(
                          color: Colors
                              .green
                              .shade100,
                        ),
                      ),
                      child:
                          const Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                Color(
                              0xFF8BEA84,
                            ),
                            child:
                                Icon(
                              Icons
                                  .lightbulb,
                              color:
                                  Colors.green,
                            ),
                          ),

                          SizedBox(
                            width: 12,
                          ),

                          Expanded(
                            child:
                                Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  'Tips Penjualan Surplus',
                                  style:
                                      TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    color:
                                        Colors.green,
                                  ),
                                ),

                                SizedBox(
                                  height:
                                      4,
                                ),

                                Text(
                                  'Update stok 1 jam sebelum jam tutup toko untuk meningkatkan konversi penyelamatan makanan hingga 80%.',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    if (filteredProducts
                        .isEmpty)
                      const Padding(
                        padding:
                            EdgeInsets.only(
                          top: 40,
                        ),
                        child:
                            Center(
                          child: Text(
                            'Tidak ada produk',
                          ),
                        ),
                      )
                    else
                      ...filteredProducts.map(
                        (
                          product,
                        ) =>
                            ProductCard(
                          product:
                              product,
                        ),
                      ),

                    const SizedBox(
                      height: 120,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation
              .centerFloat,

      floatingActionButton:
          Container(
        width:
            MediaQuery.of(
                  context,
                ).size.width *
                0.88,
        height: 68,
        decoration:
            BoxDecoration(
          color: Colors.green,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withValues(
              alpha: 0.35,
            ),
              blurRadius: 14,
            ),
          ],
        ),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/merchant-add-product',
            );
          },
          child: const Row(
            children: [
              SizedBox(
                width: 18,
              ),

              CircleAvatar(
                backgroundColor:
                    Colors.white24,
                child: Icon(
                  Icons.add,
                  color:
                      Colors.white,
                ),
              ),

              Expanded(
                child: Center(
                  child: Text(
                    '+ Tambah Produk Surplus Baru',
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontWeight:
                          FontWeight.bold,
                      fontSize:
                          18,
                    ),
                  ),
                ),
              ),

              Padding(
                padding:
                    EdgeInsets.only(
                  right: 18,
                ),
                child: Icon(
                  Icons.chevron_right,
                  color:
                      Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar:
          const MerchantBottomNav(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildFilterChip(
    String text,
    bool selected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration:
            BoxDecoration(
          color: selected
              ? Colors.green
              : Colors.white,
          borderRadius:
              BorderRadius.circular(
            30,
          ),
          border: Border.all(
            color: selected
                ? Colors.green
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.black87,
            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }
}