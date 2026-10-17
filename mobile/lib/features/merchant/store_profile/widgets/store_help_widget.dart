import 'package:flutter/material.dart';

class StoreHelpWidget extends StatelessWidget {
  final VoidCallback onHelpTap;
  final VoidCallback onCustomerServiceTap;
  final Future<void> Function() onLogout;

  const StoreHelpWidget({
    super.key,
    required this.onHelpTap,
    required this.onCustomerServiceTap,
    required this.onLogout,
  });

  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color textColor = Color(0xFF263126);
  static const String appVersion = '1.0.0';

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Keluar dari Akun?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar dari akun Mitra CheaFood?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.grey.shade100,
        ),
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
          const Text(
            'Bantuan & Pengaturan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 14),

          _buildMenuItem(
            icon: Icons.help_outline_rounded,
            title: 'Pusat Bantuan Mitra',
            subtitle: 'Panduan menggunakan CheaFood',
            onTap: onHelpTap,
          ),

          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          _buildMenuItem(
            icon: Icons.support_agent_rounded,
            title: 'Customer Service',
            subtitle: 'Hubungi tim bantuan CheaFood',
            onTap: onCustomerServiceTap,
          ),

          Divider(
            height: 1,
            color: Colors.grey.shade200,
          ),

          _buildMenuItem(
            icon: Icons.logout_rounded,
            title: 'Logout',
            subtitle: 'Keluar dari akun Mitra',
            iconColor: Colors.red,
            titleColor: Colors.red,
            onTap: () => _confirmLogout(context),
          ),

          const SizedBox(height: 20),

          Center(
            child: Column(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F9E9),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: darkGreen,
                    size: 25,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'CheaFood Mitra',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Versi $appVersion',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mengurangi food waste bersama',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = darkGreen,
    Color titleColor = textColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 0,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 23,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: Colors.grey.shade400,
      ),
      onTap: onTap,
    );
  }
}
