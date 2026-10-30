import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/storage/storage_service.dart';
import '../../../models/merchant_order_model.dart';
import '../../../services/order_service.dart';
import 'widgets/order_history_card.dart';

// Status yang dianggap sebagai "pesanan dikonfirmasi oleh mitra".
// Di backend: menunggu_pembayaran -> (mitra verifikasi) siap_diambil
// -> (mitra konfirmasi pickup) selesai.
const List<String> _confirmedStatuses = [
  'siap_diambil',
  'diproses',
];

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() =>
      _OrderHistoryPageState();
}

class _OrderHistoryPageState
    extends State<OrderHistoryPage> {
  List<MerchantOrderModel> _orders = [];
  bool _isLoading = false;
  final Set<int> _acknowledged = {};
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _initAcknowledged();
    // Polling agar popup muncul otomatis saat mitra
    // mengonfirmasi, tanpa harus refresh manual.
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _loadOrders(showPopup: true),
    );
  }

  Future<void> _initAcknowledged() async {
    final ids = await StorageService
        .getAcknowledgedOrders();
    if (!mounted) return;
    setState(
      () => _acknowledged.addAll(ids),
    );
    await _loadOrders(showPopup: true);
  }

  Future<void> _loadOrders({
    bool showPopup = true,
  }) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final raw = await OrderService().getOrders();
      final orders = raw
          .map<MerchantOrderModel>(
            (e) => MerchantOrderModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();

      if (!mounted) return;
      setState(() => _orders = orders);

      if (showPopup) _checkConfirmedPopups(orders);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal memuat riwayat pesanan: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _checkConfirmedPopups(
    List<MerchantOrderModel> orders,
  ) {
    final newlyConfirmed = orders.where(
      (o) =>
          _confirmedStatuses.contains(o.status) &&
          !_acknowledged.contains(o.id),
    );

    if (newlyConfirmed.isEmpty) return;

    for (final o in newlyConfirmed) {
      _acknowledged.add(o.id);
    }
    StorageService.saveAcknowledgedOrders(
      _acknowledged.toList(),
    );

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            SizedBox(width: 8),
            Text('Pesanan Dikonfirmasi'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Pesanan berikut telah dikonfirmasi '
              'oleh mitra dan siap diambil:',
            ),
            const SizedBox(height: 10),
            ...newlyConfirmed.map(
              (o) => Padding(
                padding:
                    const EdgeInsets.only(bottom: 8),
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        _orderTitle(o),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        o.storeName.isNotEmpty
                            ? o.storeName
                            : 'Toko',
                      ),
                      if (o.pickupCode.isNotEmpty)
                        Text(
                          'Kode pengambilan: '
                          '${o.pickupCode}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'menunggu_pembayaran':
      case 'menunggu':
        return 'Menunggu Pembayaran';
      case 'diproses':
        return 'Diproses';
      case 'siap_diambil':
        return 'Siap Diambil';
      case 'selesai':
        return 'Selesai';
      case 'dibatalkan':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  String _orderTitle(MerchantOrderModel order) {
    if (order.categoryName.trim().isNotEmpty) {
      return _capitalize(order.categoryName.trim());
    }
    if (order.productName.trim().isNotEmpty) {
      return order.productName;
    }
    return 'Pesanan #${order.id}';
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            _loadOrders(showPopup: true),
        child: _isLoading && _orders.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _orders.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada riwayat pesanan.',
                    ),
                  )
                : ListView(
                    padding:
                        const EdgeInsets.all(16),
                    children: _orders
                        .map(
                          (o) => OrderHistoryCard(
                            title: _orderTitle(o),
                            store: o.storeName
                                    .isNotEmpty
                                ? o.storeName
                                : '-',
                            price:
                                'Rp ${o.totalPrice.round()}',
                            status: _statusLabel(o.status),
                          ),
                        )
                        .toList(),
                  ),
      ),
    );
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
