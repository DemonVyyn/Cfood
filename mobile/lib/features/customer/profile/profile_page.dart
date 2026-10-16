import 'package:flutter/material.dart';

import 'widgets/profile_header.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/profile_stat_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ProfileHeader(),

          const SizedBox(height: 20),

          Row(
            children: const [
              Expanded(
                child: ProfileStatCard(
                  title: 'Pesanan',
                  value: '24',
                  icon: Icons.receipt_long,
                  color: Colors.green,
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: ProfileStatCard(
                  title: 'Food Saved',
                  value: '18',
                  icon: Icons.eco,
                  color: Colors.orange,
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: ProfileStatCard(
                  title: 'Review',
                  value: '12',
                  icon: Icons.star,
                  color: Colors.amber,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const ProfileMenuItem(
            icon: Icons.person_outline,
            title: "Edit Profil",
          ),

          const ProfileMenuItem(icon: Icons.history, title: "Riwayat Pesanan"),

          const ProfileMenuItem(
            icon: Icons.notifications_none,
            title: "Notifikasi",
          ),

          const ProfileMenuItem(
            icon: Icons.help_outline,
            title: "Pusat Bantuan",
          ),

          const ProfileMenuItem(
            icon: Icons.settings_outlined,
            title: "Pengaturan",
          ),

          const ProfileMenuItem(icon: Icons.logout, title: "Logout"),
        ],
      ),
      // Bottom navigation is now handled by HomeShell (SPA).
    );
  }
}
