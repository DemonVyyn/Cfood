// lib/widgets/home_shell.dart
import 'package:flutter/material.dart';
import '../features/home/home_page.dart';
import '../features/customer/order_history/order_history_page.dart';
import '../features/customer/notification/notification_page.dart';
import '../features/customer/profile/profile_page.dart';
import 'curved_bottom_nav.dart';

/// A shell widget that holds the four main pages of the app.
///
/// It uses an [IndexedStack] so that only the *content* changes when the
/// user taps the navigation bar, while the navigation bar itself stays
/// in place and its animation remains smooth – mimicking a SPA.
class HomeShell extends StatefulWidget {
  const HomeShell({Key? key}) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  // All pages are instantiated once, so their state (scroll position,
  // form data, etc.) is preserved while switching tabs.
  final List<Widget> _pages = const [
    HomePage(),
    OrderHistoryPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CurvedBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
