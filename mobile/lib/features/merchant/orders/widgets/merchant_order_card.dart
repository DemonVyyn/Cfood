import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MerchantOrderCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String productName;
  final String pickupTime;
  final String status;
  final int totalPrice;
  final String paymentStatus;
  final bool isVerifying;
  final VoidCallback onVerifyPayment;

  const MerchantOrderCard({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.productName,
    required this.pickupTime,
    required this.status,
    required this.totalPrice,
    required this.paymentStatus,
    required this.isVerifying,
    required this.onVerifyPayment,
  });

  static const Color primaryGreen = Color(0xFF14DE32);
  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color textColor = Color(0xFF263126);

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_');
  }

  String get _normalizedStatus => _normalize(status);

  String get _normalizedPaymentStatus => _normalize(paymentStatus);

  bool get _isWaitingForPayment {
    return _normalizedStatus == 'menunggu_pembayaran' ||
        _normalizedStatus == 'menunggu';
  }

  bool get _isPaymentPending {
    return _normalizedPaymentStatus == 'pending' ||
        _normalizedPaymentStatus == 'menunggu';
  }

  bool get _canVerifyPayment {
    return _isWaitingForPayment && _isPaymentPending;
  }

  Color _statusColor() {
    switch (_normalizedStatus) {
      case 'menunggu':
      case 'menunggu_pembayaran':
        return Colors.orange;

      case 'dibayar':
      case 'diproses':
      case 'siap_diambil':
        return Colors.blue;

      case 'selesai':
        return darkGreen;

      case 'dibatalkan':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String _statusLabel() {
    switch (_normalizedStatus) {
      case 'menunggu':
      case 'menunggu_pembayaran':
        return 'Menunggu Pembayaran';

      case 'dibayar':
        return 'Sudah Dibayar';

      case 'diproses':
        return 'Diproses';

      case 'siap_diambil':
        return 'Siap Diambil';

      case 'selesai':
        return 'Selesai';

      case 'dibatalkan':
        return 'Dibatalkan';

      default:
        return status.isEmpty ? 'Tidak Diketahui' : status;
    }
  }

  String _paymentStatusLabel() {
    switch (_normalizedPaymentStatus) {
      case 'pending':
      case 'menunggu':
        return 'Belum Diverifikasi';

      case 'paid':
        return 'Sudah Dibayar';

      case 'failed':
        return 'Pembayaran Gagal';

      case 'refunded':
        return 'Dana Dikembalikan';

      default:
        return paymentStatus.isEmpty
            ? 'Status pembayaran tidak tersedia'
            : paymentStatus;
    }
  }

  String _formatRupiah(int amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  orderId,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _statusLabel(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            icon: Icons.person_outline,
            label: 'Pelanggan',
            value: customerName,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.fastfood_outlined,
            label: 'Produk',
            value: productName,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icon: Icons.schedule_outlined,
            label: 'Waktu Pengambilan',
            value: pickupTime,
          ),
          const SizedBox(height: 16),

          // Status pembayaran.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                _normalizedPaymentStatus == 'paid'
                    ? Icons.check_circle_outline
                    : Icons.payments_outlined,
                size: 20,
                color: _normalizedPaymentStatus == 'paid'
                    ? darkGreen
                    : Colors.orange,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pembayaran Tunai',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _paymentStatusLabel(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _normalizedPaymentStatus == 'paid'
                            ? darkGreen
                            : Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 14),

          // Total harga dan tombol aksi.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Pesanan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatRupiah(totalPrice),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkGreen,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (_canVerifyPayment)
                Flexible(
                  child: ElevatedButton.icon(
                    onPressed: isVerifying ? null : onVerifyPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade400,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: isVerifying
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.verified_outlined,
                            size: 18,
                          ),
                    label: Text(
                      isVerifying ? 'Memproses' : 'Verifikasi',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              else if (_normalizedPaymentStatus == 'paid' &&
                  _normalizedStatus == 'siap_diambil')
                _buildStatusBadge(
                  label: 'Siap Diambil',
                  color: Colors.blue,
                )
              else if (_normalizedStatus == 'selesai')
                _buildStatusBadge(
                  label: 'Selesai',
                  color: darkGreen,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge({
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: darkGreen,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value.isEmpty ? '-' : value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
