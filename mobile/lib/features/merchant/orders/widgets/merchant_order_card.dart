import 'package:flutter/material.dart';

class MerchantOrderCard extends StatelessWidget {
  final String orderId;
  final String customerName;
  final String productName;
  final String pickupTime;
  final String status;
  final int totalPrice;

  const MerchantOrderCard({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.productName,
    required this.pickupTime,
    required this.status,
    required this.totalPrice,
  });

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case 'menunggu':
        return Colors.orange;

      case 'siap diambil':
        return Colors.blue;

      case 'selesai':
        return Colors.green;

      case 'dibatalkan':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  orderId,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      _statusColor()
                          .withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color:
                        _statusColor(),
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.person,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  customerName,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.fastfood,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  productName,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(
                Icons.schedule,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(width: 8),

              Text(
                pickupTime,
              ),
            ],
          ),

          const Divider(
            height: 24,
          ),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Rp ${totalPrice.toString()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                    color: Color(
                      0xFF1B5E20,
                    ),
                  ),
                ),
              ),

              ElevatedButton.icon(
                onPressed: () {},
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                    0xFF1B5E20,
                  ),
                  foregroundColor:
                      Colors.white,
                ),
                icon: const Icon(
                  Icons.qr_code_scanner,
                  size: 18,
                ),
                label: const Text(
                  "Verifikasi",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}