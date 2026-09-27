import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/merchant_provider.dart';
import '../../widgets/merchant_bottom_nav.dart';

import 'widgets/merchant_header.dart';
import 'widgets/summary_card.dart';
import 'widgets/pickup_order_card.dart';
import 'widgets/stock_item_card.dart';
import 'widgets/merchant_action_button.dart';

class MerchantDashboardPage
    extends StatefulWidget {
  const MerchantDashboardPage({
    super.key,
  });

  @override
  State<MerchantDashboardPage>
      createState() =>
          _MerchantDashboardPageState();
}

class _MerchantDashboardPageState
    extends State<MerchantDashboardPage> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_loaded) {
      _loaded = true;

      Future.microtask(() {
        context
            .read<MerchantProvider>()
            .loadDashboard();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<MerchantProvider>();

    final data =
        provider.dashboard;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FA),

      body: SafeArea(
        child: provider.isLoading &&
                data == null
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : data == null
                ? Center(
                    child: Text(
                      provider.error ??
                          'Data dashboard tidak tersedia',
                    ),
                  )
                : SingleChildScrollView(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        MerchantHeader(
                          storeName:
                              data.storeName,
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        const Text(
                          "Ringkasan Hari Ini",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        GridView.count(
                          crossAxisCount:
                              2,
                          shrinkWrap:
                              true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          crossAxisSpacing:
                              12,
                          mainAxisSpacing:
                              12,
                          childAspectRatio:
                              1.35,
                          children: [
                            SummaryCard(
                              title:
                                  "Produk Surplus Aktif",
                              value:
                                  "${data.activeProducts}",
                            ),
                            SummaryCard(
                              title:
                                  "Pesanan Menunggu",
                              value:
                                  "${data.waitingOrders}",
                            ),
                            SummaryCard(
                              title:
                                  "Penjualan Hari Ini",
                              value:
                                  "Rp ${data.todaySales.toStringAsFixed(0)}",
                            ),
                            const SummaryCard(
                              title:
                                  "Makanan Terselamatkan",
                              value:
                                  "-",
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        const MerchantActionButton(),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            const Text(
                              "Pesanan Masuk",
                              style:
                                  TextStyle(
                                fontSize:
                                    18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () {
                                Navigator
                                    .pushNamed(
                                  context,
                                  '/merchant-orders',
                                );
                              },
                              child:
                                  const Text(
                                "Lihat Semua",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        PickupOrderCard( 
                          orders: data.latestOrders,
                ),

                        const SizedBox(
                          height: 20,
                        ),

                        const Text(
                          "Stok Surplus Hari Ini",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),

                        StockItemCard(
                          stocks: data.stocks,
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
      ),

      bottomNavigationBar:
          const MerchantBottomNav(
        currentIndex: 0,
      ),
    );
  }
}