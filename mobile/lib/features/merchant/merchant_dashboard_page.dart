import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/location_provider.dart';
import '../../providers/merchant_provider.dart';
import 'widgets/merchant_action_button.dart';
import 'widgets/merchant_header.dart';
import 'widgets/pickup_order_card.dart';
import 'widgets/stock_item_card.dart';

class MerchantDashboardPage extends StatefulWidget {
  const MerchantDashboardPage({super.key});

  @override
  State<MerchantDashboardPage> createState() => _MerchantDashboardPageState();
}

class _MerchantDashboardPageState extends State<MerchantDashboardPage> {
  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color backgroundColor = Color(0xFFF7F9F7);
  static const Color textColor = Color(0xFF263126);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      await context.read<MerchantProvider>().loadDashboard();
    });
  }

  Future<void> refreshDashboard() async {
    await context.read<MerchantProvider>().refreshDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MerchantProvider>();
    final data = provider.dashboard;
    final locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: provider.isLoading && data == null
            ? const Center(child: CircularProgressIndicator(color: darkGreen))
            : data == null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_off_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        provider.error ?? 'Data dashboard tidak tersedia',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: textColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              )
            : RefreshIndicator(
                color: darkGreen,
                onRefresh: refreshDashboard,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MerchantHeader(
                        storeName: data.storeName,
                        location: locationProvider.locationName,
                        notificationCount: 3,
                      ),

                      const SizedBox(height: 24),

                      const Text(
                        'Ringkasan Hari Ini',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Pantau aktivitas dan performa tokomu.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 18),

                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              mainAxisExtent:
                                  150, // tinggi tetap, cukup untuk semua konten
                            ),
                        children: [
                          _buildStatCard(
                            title: 'Produk Aktif',
                            value: '${data.activeProducts}',
                            icon: Icons.fastfood_rounded,
                            color: darkGreen,
                          ),
                          _buildStatCard(
                            title: 'Pesanan Menunggu',
                            value: '${data.waitingOrders}',
                            icon: Icons.receipt_long_rounded,
                            color: Colors.orange,
                          ),
                          _buildStatCard(
                            title: 'Penjualan Hari Ini',
                            value: 'Rp ${data.todaySales.toStringAsFixed(0)}',
                            icon: Icons.payments_rounded,
                            color: Colors.blue,
                          ),
                          _buildStatCard(
                            title: 'Food Saved',
                            value: '${data.activeProducts}',
                            icon: Icons.eco_rounded,
                            color: Colors.teal,
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      const MerchantActionButton(),

                      const SizedBox(height: 28),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Pesanan Masuk',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/merchant-orders');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: darkGreen,
                            ),
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      PickupOrderCard(orders: data.latestOrders),

                      const SizedBox(height: 28),

                      const Text(
                        'Stok Surplus Hari Ini',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),

                      const SizedBox(height: 12),

                      StockItemCard(stocks: data.stocks),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 23),
          ),

          const SizedBox(height: 12),

          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
