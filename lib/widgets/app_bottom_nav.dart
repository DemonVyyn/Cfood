import 'package:flutter/material.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({
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

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,

      type: BottomNavigationBarType.fixed,

      selectedItemColor:
          const Color(0xFF166534),

      unselectedItemColor:
          Colors.grey,

      onTap: (index) =>
          _navigate(
            context,
            index,
          ),

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long),
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}