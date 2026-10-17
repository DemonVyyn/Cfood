import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/merchant_provider.dart';
import '../edit_store_profile_page.dart';

class StoreInfoCard extends StatelessWidget {
  const StoreInfoCard({super.key});

  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color textColor = Color(0xFF263126);

  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantProvider>(
      builder: (context, provider, child) {
        final dashboard = provider.dashboard;

        final storeName = dashboard?.storeName.trim() ?? '';

        return Container(
          padding: const EdgeInsets.all(18),
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
                  const Expanded(
                    child: Text(
                      'Informasi Toko',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () async {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const EditStoreProfilePage(),
                        ),
                      );

                      if (updated == true && context.mounted) {
                        await context
                            .read<MerchantProvider>()
                            .refreshDashboard();
                      }
                    },
                    icon: const Icon(Icons.edit_outlined, size: 17),
                    label: const Text('Edit'),
                    style: TextButton.styleFrom(
                      foregroundColor: darkGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _buildInfoItem(
                icon: Icons.store_outlined,
                title: 'Nama Toko',
                subtitle: storeName.isNotEmpty
                    ? storeName
                    : 'Nama toko belum tersedia',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ),
              _buildInfoItem(
                icon: Icons.location_on_outlined,
                title: 'Alamat Toko',
                subtitle: 'Data alamat perlu disediakan oleh API mitra',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
              ),
              _buildInfoItem(
                icon: Icons.phone_outlined,
                title: 'Nomor Telepon',
                subtitle: 'Data telepon perlu disediakan oleh API mitra',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFE7F9E9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const SizedBox.shrink().buildIconPlaceholder(icon),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension on SizedBox {
  Widget buildIconPlaceholder(IconData icon) {
    return Icon(
      icon,
      color: StoreInfoCard.darkGreen,
      size: 23,
    );
  }
}