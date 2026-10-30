import 'package:flutter/material.dart';

import '../../../models/merchant_order_model.dart';
import '../../../services/order_service.dart';
import 'widgets/notification_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() =>
      _NotificationPageState();
}

class _NotificationPageState
    extends State<NotificationPage> {
  List<MerchantOrderModel> _orders = [];
  bool _loading = false;
  bool _onlyUnread = false;
  final Set<int> _readIds = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final raw = await OrderService().getOrders();
      _orders = raw
          .map<MerchantOrderModel>(
            (e) => MerchantOrderModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
      _orders.sort(
        (a, b) => (b.createdAt ?? DateTime(2000))
            .compareTo(a.createdAt ?? DateTime(2000)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal memuat notifikasi: $e',
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<MerchantOrderModel> get _visibleOrders =>
      _orders.where((o) {
        if (!_onlyUnread) return true;
        return _isUnread(o);
      }).toList();

  bool _isUnread(MerchantOrderModel o) {
    if (_readIds.contains(o.id)) return false;
    return const [
      'menunggu_pembayaran',
      'menunggu',
      'diproses',
      'siap_diambil',
    ].contains(o.status);
  }

  int get _unreadCount =>
      _orders.where(_isUnread).length;

  @override
  Widget build(BuildContext context) {
    final visible = _visibleOrders;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: () => setState(
                () => _readIds.addAll(
                  _orders.map((o) => o.id),
                ),
              ),
              child: const Text('Tandai dibaca'),
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading && _orders.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : visible.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding:
                        const EdgeInsets.all(16),
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 8),
                      ...visible.map(
                        (o) => Dismissible(
                          key: ValueKey(
                            'notif_${o.id}_${o.status}',
                          ),
                          direction:
                              DismissDirection.endToStart,
                          background:
                              _buildDismissBackground(),
                          onDismissed: (_) => setState(
                            () => _orders.removeWhere(
                              (x) => x.id == o.id,
                            ),
                          ),
                          child: NotificationCard(
                            title: _titleFor(o),
                            message: _messageFor(o),
                            time: _relativeTime(o.createdAt),
                            icon: _iconFor(o),
                            iconColor: _colorFor(o),
                            isUnread: _isUnread(o),
                            onTap: () {
                              setState(
                                () => _readIds.add(o.id),
                              );
                              _showDetail(o);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          _unreadCount > 0
              ? '$_unreadCount belum dibaca'
              : 'Semua dibaca',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        FilterChip(
          label: const Text('Belum dibaca'),
          selected: _onlyUnread,
          onSelected: (v) =>
              setState(() => _onlyUnread = v),
          selectedColor: Colors.green.shade100,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _onlyUnread
                  ? 'Tidak ada notifikasi belum dibaca.'
                  : 'Belum ada notifikasi.',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.delete_outline,
        color: Colors.red,
      ),
    );
  }

  String _titleFor(MerchantOrderModel o) {
    switch (o.status) {
      case 'menunggu_pembayaran':
      case 'menunggu':
        return 'Menunggu Pembayaran';
      case 'diproses':
        return 'Pesanan Diproses';
      case 'siap_diambil':
        return 'Pesanan Siap Diambil';
      case 'selesai':
        return 'Pickup Berhasil';
      case 'dibatalkan':
        return 'Pesanan Dibatalkan';
      default:
        return 'Pesanan #${o.id}';
    }
  }

  String _messageFor(MerchantOrderModel o) {
    final store =
        o.storeName.isNotEmpty ? o.storeName : 'toko';
    final total = 'Rp ${o.totalPrice.round()}';
    switch (o.status) {
      case 'menunggu_pembayaran':
      case 'menunggu':
        return 'Pesanan di $store menunggu '
            'pembayaran tunai. Total $total.';
      case 'diproses':
        return 'Pesanan di $store sedang '
            'disiapkan oleh mitra.';
      case 'siap_diambil':
        return o.pickupCode.isNotEmpty
            ? 'Pesanan di $store sudah siap! '
                'Kode ambil: ${o.pickupCode}'
            : 'Pesanan di $store sudah siap diambil.';
      case 'selesai':
        return 'Terima kasih! Anda menyelamatkan '
            'makanan di $store.';
      case 'dibatalkan':
        return 'Pesanan di $store dibatalkan.';
      default:
        return 'Pesanan #${o.id} di $store.';
    }
  }

  IconData _iconFor(MerchantOrderModel o) {
    switch (o.status) {
      case 'menunggu_pembayaran':
      case 'menunggu':
        return Icons.payments_outlined;
      case 'diproses':
        return Icons.restaurant_menu;
      case 'siap_diambil':
        return Icons.check_circle_outline;
      case 'selesai':
        return Icons.eco_outlined;
      case 'dibatalkan':
        return Icons.cancel_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  Color _colorFor(MerchantOrderModel o) {
    switch (o.status) {
      case 'siap_diambil':
        return Colors.green;
      case 'menunggu_pembayaran':
      case 'menunggu':
        return Colors.orange;
      case 'dibatalkan':
        return Colors.red;
      case 'selesai':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }

  String _relativeTime(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    }
    return '${dt.day}/${dt.month}/${dt.year}';
  }

  void _showDetail(MerchantOrderModel o) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconFor(o), color: _colorFor(o)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    _titleFor(o),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow(
              'Toko',
              o.storeName.isNotEmpty
                  ? o.storeName
                  : '-',
            ),
            _detailRow('Status', _titleFor(o)),
            _detailRow(
              'Total',
              'Rp ${o.totalPrice.round()}',
            ),
            if (o.pickupCode.isNotEmpty)
              _detailRow('Kode Ambil', o.pickupCode),
            _detailRow(
              'Waktu',
              _relativeTime(o.createdAt),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
