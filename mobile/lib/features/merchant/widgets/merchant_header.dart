import 'package:flutter/material.dart';
import '../dialogs/merchant_info_dialog.dart';

class MerchantHeader extends StatelessWidget {
  final String storeName;
  final String location;
  final int notificationCount;

  const MerchantHeader({
    super.key,
    required this.storeName,
    required this.location,
    this.notificationCount = 0,
  });

  static const Color primaryGreen = Color(0xFF14DE32);
  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color textColor = Color(0xFF263126);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [primaryGreen, darkGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MITRA CFood',
                  style: TextStyle(
                    fontSize: 12,
                    color: darkGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  storeName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 15,
                      color: darkGreen,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location.isEmpty
                            ? 'Mengambil lokasi...'
                            : location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Stack(
            children: [
              IconButton(
                tooltip: 'Notifikasi',
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/merchant-notifications',
                  );
                },
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: textColor,
                ),
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 7,
                  top: 6,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        notificationCount > 99
                            ? '99+'
                            : notificationCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: 'Informasi aplikasi',
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const MerchantInfoDialog(),
              );
            },
            icon: const Icon(
              Icons.info_outline_rounded,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}