import 'package:flutter/material.dart';

import '../../widgets/merchant_bottom_nav.dart';

import 'merchant_dashboard_page.dart';
import 'products/product_list_page.dart';
import 'orders/order_list_page.dart';
import 'store_profile/store_profile_page.dart';

class MerchantShellPage extends StatefulWidget {
  const MerchantShellPage({super.key});

  @override
  State<MerchantShellPage> createState() =>
      _MerchantShellPageState();
}

class _MerchantShellPageState
    extends State<MerchantShellPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = const [
      MerchantDashboardPage(),
      ProductListPage(),
      OrderListPage(),
      StoreProfilePage(),
    ];
  }

  void _onTabTapped(int index) {
    if (index < 0 || index >= _pages.length) return;
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: MerchantBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
