import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/merchant_order_provider.dart';
import 'widgets/merchant_order_card.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  State<OrderListPage> createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage>
    with AutomaticKeepAliveClientMixin {
  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color backgroundColor = Color(0xFFF7F9F7);
  static const Color textColor = Color(0xFF263126);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<MerchantOrderProvider>().loadOrders();
    });
  }

  Future<void> _refreshOrders() async {
    await context.read<MerchantOrderProvider>().loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final provider = context.watch<MerchantOrderProvider>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Daftar Pesanan',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: darkGreen,
        onRefresh: _refreshOrders,
        child: _buildOrderContent(provider),
      ),
    );
  }

  Widget _buildOrderContent(MerchantOrderProvider provider) {
    if (provider.isLoading) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 220),
          Center(
            child: CircularProgressIndicator(
              color: darkGreen,
            ),
          ),
        ],
      );
    }

    if (provider.orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 130),
          Icon(
            Icons.receipt_long_outlined,
            size: 76,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 18),
          const Text(
            'Belum Ada Pesanan',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pesanan pelanggan akan muncul di halaman ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: provider.orders.length,
      itemBuilder: (context, index) {
        final order = provider.orders[index];

        return MerchantOrderCard(
          orderId: '#${order.id}',
          customerName: order.customerName,
          productName: order.productName,
          pickupTime: order.pickupTime,
          status: order.status,
          totalPrice: order.totalPrice.toInt(),
        );
      },
    );
  }
}
