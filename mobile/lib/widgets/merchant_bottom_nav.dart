import 'package:flutter/material.dart';

class MerchantBottomNav
    extends StatelessWidget {
  final int currentIndex;

  const MerchantBottomNav({
    super.key,
    required this.currentIndex,
  });

  void _navigate(
    BuildContext context,
    int index,
  ) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(
          context,
          '/merchant',
        );
        break;

      case 1:
        Navigator.pushReplacementNamed(
          context,
          '/merchant-products',
        );
        break;

      case 2:
        Navigator.pushReplacementNamed(
          context,
          '/merchant-orders',
        );
        break;

      case 3:
        Navigator.pushReplacementNamed(
          context,
          '/merchant-store',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,

      type: BottomNavigationBarType.fixed,

      selectedItemColor:
          const Color(0xFF166534),

      onTap: (index) =>
          _navigate(
            context,
            index,
          ),

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fastfood),
          label: 'Produk',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Toko',
        ),
      ],
    );
  }
}