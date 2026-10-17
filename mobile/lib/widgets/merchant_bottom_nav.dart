import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MerchantBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MerchantBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

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
      animationDuration: const Duration(milliseconds: 350),
      animationCurve: Curves.easeInOutCubic,
      items: [
        _buildItem(Icons.dashboard, 'Dashboard'),
        _buildItem(Icons.fastfood, 'Produk'),
        _buildItem(Icons.receipt_long, 'Pesanan'),
        _buildItem(Icons.store, 'Toko'),
      ],
      onTap: onTap,
    );
  }
}
