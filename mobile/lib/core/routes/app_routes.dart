import 'package:flutter/material.dart';

import '../../features/auth/login_page.dart';
import '../../features/auth/register_page.dart';
import '../../features/auth/role_selection_page.dart';

import '../../widgets/home_shell.dart';

import '../../features/customer/profile/profile_page.dart';
import '../../features/customer/order_history/order_history_page.dart';
import '../../features/customer/notification/notification_page.dart';

import '../../features/pickup/pickup_qr_page.dart';

import '../../features/merchant/products/add_product_page.dart';
import '../../features/merchant/products/edit_product_page.dart';

import '../../features/merchant/qr_scan/scan_qr_page.dart';
import '../../features/merchant/notification/merchant_notification_page.dart';
import '../../widgets/merchant_shell.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/role': (_) => const RoleSelectionPage(),

    '/login': (_) => const LoginPage(),

    '/register': (_) => const RegisterPage(),

    '/home': (_) => const HomeShell(),

    '/profile': (_) => const ProfilePage(),

    '/history': (_) => const OrderHistoryPage(),

    '/notification': (_) =>
        const NotificationPage(),

    '/pickup': (_) =>
        const PickupQrPage(),

    '/merchant': (_) => const MerchantShell(),

    '/merchant-products': (_) => const MerchantShell(initialIndex: 1),

    '/merchant-add-product': (_) =>
        const AddProductPage(),

    '/merchant-orders': (_) => const MerchantShell(initialIndex: 2),

    '/merchant-scan': (_) =>
        const ScanQrPage(),

    '/merchant-store': (_) => const MerchantShell(initialIndex: 3),

    '/merchant-notifications': (_) =>
        const MerchantNotificationPage(),
  };

  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings,
  ) {
    switch (settings.name) {
      case '/merchant-edit-product':
        final productId =
            settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) =>
              EditProductPage(
            productId: productId,
          ),
        );
    }

    return null;
  }
}