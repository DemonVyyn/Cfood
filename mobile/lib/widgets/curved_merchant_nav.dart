import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

/// Curved navigation bar used for the merchant (mitra) side of the app.
/// It mirrors the previous `MerchantBottomNav` icons (dashboard, produk, pesanan, toko).
class CurvedMerchantNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CurvedMerchantNav({Key? key, required this.currentIndex, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      // Keep the same transparent background as the customer navigation bar.
      backgroundColor: const Color.fromARGB(0, 177, 162, 162),
      color: const Color.fromARGB(255, 20, 222, 50),
      buttonBackgroundColor: const Color.fromARGB(255, 61, 226, 61),
      animationDuration: const Duration(milliseconds: 300),
      items: const [
        // Dashboard
        SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard, size: 24),
              SizedBox(height: 4),
              Text(
                'Dashboard',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Produk
        SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.fastfood, size: 24),
              SizedBox(height: 4),
              Text(
                'Produk',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Pesanan
        SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, size: 24),
              SizedBox(height: 4),
              Text(
                'Pesanan',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        // Toko
        SizedBox(
          width: 60,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.store, size: 24),
              SizedBox(height: 4),
              Text(
                'Toko',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
      onTap: (index) {
        if (onTap != null) {
          onTap!(index);
        }
      },
    );
  }
}
