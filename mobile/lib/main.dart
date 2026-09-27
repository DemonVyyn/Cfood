import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/food_provider.dart';

import 'features/home/home_page.dart';

import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/auth/role_selection_page.dart';

import 'features/auth/splash/splash_page.dart';


import 'features/customer/profile/profile_page.dart';
import 'features/customer/order_history/order_history_page.dart';
import 'features/customer/notification/notification_page.dart';

import 'features/pickup/pickup_qr_page.dart';

import 'features/merchant/merchant_dashboard_page.dart';

import 'features/merchant/products/product_list_page.dart';
import 'features/merchant/orders/order_list_page.dart';
import 'features/merchant/qr_scan/scan_qr_page.dart';
import 'features/merchant/store_profile/store_profile_page.dart';

import 'providers/merchant_provider.dart';
import 'providers/merchant_product_provider.dart';
import 'features/merchant/products/add_product_page.dart';
import 'features/merchant/products/edit_product_page.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FoodProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MerchantProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MerchantProductProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CheaFood',
      routes: {
  '/role': (_) => const RoleSelectionPage(),
  '/login': (_) => const LoginPage(),
  '/register': (_) => const RegisterPage(),

  '/home': (_) => const HomePage(),

  '/profile': (_) => const ProfilePage(),
  '/history': (_) => const OrderHistoryPage(),
  '/notification': (_) => const NotificationPage(),

  '/pickup': (_) => const PickupQrPage(),

  '/merchant': (_) => const MerchantDashboardPage(),

  '/merchant-products': (_) =>
      const ProductListPage(),

  '/merchant-add-product': (_) =>
    const AddProductPage(),

  '/merchant-edit-product': (context) {
  final productId =
      ModalRoute.of(context)!
          .settings
          .arguments as int;

  return EditProductPage(
    productId: productId,
  );
},

  '/merchant-orders': (_) =>
      const OrderListPage(),

  '/merchant-scan': (_) =>
      const ScanQrPage(),

  '/merchant-store': (_) =>
      const StoreProfilePage(),
},
      home: const SplashPage(),
    );
  }
}