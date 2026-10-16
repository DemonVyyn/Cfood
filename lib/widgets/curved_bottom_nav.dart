// lib/widgets/curved_bottom_nav.dart

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CurvedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CurvedBottomNav({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  void _navigate(
    BuildContext context,
    int index,
  ) {
    // Sama seperti AppBottomNav
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
        break;

      case 1:
        Navigator.pushReplacementNamed(
          context,
          '/history',
        );
        break;

      case 2:
        Navigator.pushReplacementNamed(
          context,
          '/notification',
        );
        break;

      case 3:
        Navigator.pushReplacementNamed(
          context,
          '/profile',
        );
        break;
    }
  }

  Widget _buildItem(
    IconData icon,
    String label,
  ) {
    return SizedBox(
      width: 65,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      height: 65,
      backgroundColor: Colors.transparent,
      color: const Color(0xFF14DE32),
      buttonBackgroundColor: const Color(0xFF3DE23D),
      animationDuration: const Duration(milliseconds: 300),

      items: [
        _buildItem(Icons.home, 'Beranda'),
        _buildItem(Icons.receipt_long, 'Pesanan'),
        _buildItem(Icons.notifications, 'Notifikasi'),
        _buildItem(Icons.person, 'Profil'),
      ],

      onTap: (index) {
        if (onTap != null) {
          // Digunakan oleh HomeShell
          onTap!(index);
          return;
        }

        // Sama seperti AppBottomNav
        _navigate(context, index);
      },
    );
  }
}