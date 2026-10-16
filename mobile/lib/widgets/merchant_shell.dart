import 'package:flutter/material.dart';
import '../features/merchant/merchant_dashboard_page.dart';
import '../features/merchant/products/product_list_page.dart';
import '../features/merchant/orders/order_list_page.dart';
import '../features/merchant/store_profile/store_profile_page.dart';
import 'curved_merchant_nav.dart';

/// Shell for the merchant side of the app.
///
/// It keeps the navigation bar static and only swaps the page content when the
/// user taps a navigation item, mimicking a single‑page‑application experience.
class MerchantShell extends StatefulWidget {
  final int initialIndex;

  const MerchantShell({super.key, this.initialIndex = 0});

  @override
  State<MerchantShell> createState() => _MerchantShellState();
}

class _MerchantShellState extends State<MerchantShell> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  // The merchant pages are instantiated once so their state is preserved.
  final List<Widget> _pages = const [
    MerchantDashboardPage(),
    ProductListPage(),
    OrderListPage(),
    StoreProfilePage(),
  ];

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: CurvedMerchantNav(
        currentIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
