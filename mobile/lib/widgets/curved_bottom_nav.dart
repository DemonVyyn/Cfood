// lib/widgets/curved_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CurvedBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap; // optional callback

  const CurvedBottomNav({
    Key? key,
    required this.currentIndex,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: const Color.fromARGB(0, 177, 162, 162),
      color: const Color.fromARGB(255, 20, 222, 50),
      buttonBackgroundColor: const Color.fromARGB(255, 61, 226, 61),
      animationDuration: const Duration(milliseconds: 300),

      // ---- ITEM‑ITEM DENGAN LEBAR SERAGAM ----
      items: const [
        // Home
        SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, size: 24),
              SizedBox(height: 4),
              Text('Beranda', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Pesanan (History)
        SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, size: 24),
              SizedBox(height: 4),
              Text('Pesanan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Notifikasi
        SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications, size: 24),
              SizedBox(height: 4),
              Text('Notifikasi', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        // Profil
        SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person, size: 24),
              SizedBox(height: 4),
              Text('Profil', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),),
            ],
          ),
        ),
      ],
      // -------------------------------------------------
      onTap: (index) {
        if (onTap != null) {
          onTap!(index);
        } else {
          // fallback navigation when not used inside HomeShell
          switch (index) {
            case 0: Navigator.pushNamed(context, '/homeShell'); break;
            case 1: Navigator.pushNamed(context, '/history'); break;
            case 2: Navigator.pushNamed(context, '/notification'); break;
            case 3: Navigator.pushNamed(context, '/profile'); break;
          }
        }
      },
    );
  }
}