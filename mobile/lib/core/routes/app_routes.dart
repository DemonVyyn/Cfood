
import 'package:flutter/material.dart';

import '../../features/auth/role_selection_page.dart';
import '../../features/auth/auth_flow_page.dart';

import '../../features/customer/home/home_page.dart';
import '../../features/customer/profile/profile_page.dart';
import '../../features/customer/order_history/order_history_page.dart';
import '../../features/customer/notification/notification_page.dart';

import '../../features/merchant/merchant_shell_page.dart';
import '../../features/merchant/products/product_list_page.dart';
import '../../features/merchant/products/add_product_page.dart';
import '../../features/merchant/products/edit_product_page.dart';
import '../../features/merchant/orders/order_list_page.dart';
import '../../features/merchant/qr_scan/scan_qr_page.dart';
import '../../features/merchant/store_profile/store_profile_page.dart';
import '../../features/merchant/notification/merchant_notification_page.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    // Autentikasi dan pemilihan role
    '/role': (_) => const RoleSelectionPage(),
    '/login': (_) => const AuthFlowPage(initialIsLogin: true),
    '/register': (_) => const AuthFlowPage(initialIsLogin: false),

    // Customer
    '/home': (_) => const HomePage(),
    '/profile': (_) => const ProfilePage(),
    '/history': (_) => const OrderHistoryPage(),
    '/notification': (_) => const NotificationPage(),

    // Merchant: halaman induk
    '/merchant': (_) => const MerchantShellPage(),

    // Merchant: produk
    '/merchant-products': (_) => const ProductListPage(),
    '/merchant-add-product': (_) => const AddProductPage(),

    // Merchant: pesanan
    '/merchant-orders': (_) => const OrderListPage(),

    // Merchant: QR dan toko
    '/merchant-scan': (_) => const ScanQrPage(),
    '/merchant-store': (_) => const StoreProfilePage(),

    // Merchant: notifikasi
    '/merchant-notifications': (_) =>
      const MerchantNotificationPage(),
  };

  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case '/merchant-edit-product':
        final productId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => EditProductPage(
            productId: productId,
          ),
        );
    }

    return null;
  }
}
