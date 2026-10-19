
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/food_provider.dart';
import 'providers/location_provider.dart';
import 'providers/profile_photo_provider.dart';

import 'features/auth/auth_flow_page.dart';
import 'features/auth/role_selection_page.dart';
import 'features/auth/splash/splash_page.dart';

import 'features/customer/profile/profile_page.dart';
import 'features/customer/order_history/order_history_page.dart';
import 'features/customer/notification/notification_page.dart';


import 'features/merchant/products/product_list_page.dart';
import 'features/merchant/products/add_product_page.dart';
import 'features/merchant/products/edit_product_page.dart';
import 'features/merchant/orders/order_list_page.dart';
import 'features/merchant/qr_scan/scan_qr_page.dart';
import 'features/merchant/store_profile/store_profile_page.dart';
import 'features/merchant/notification/merchant_notification_page.dart';

import 'widgets/home_shell.dart'; // HomeShell dengan curved bottom navigation bar
import 'widgets/merchant_shell.dart'; // MerchantShell dengan curved navigation mitra

import 'providers/merchant_provider.dart';
import 'providers/merchant_product_provider.dart';
import 'providers/merchant_order_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Muat foto profil tersimpan sebelum app dijalankan supaya
  // foto tetap muncul setelah logout/login atau app dibuka kembali.
  final profilePhotoProvider = ProfilePhotoProvider();
  await profilePhotoProvider.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => MerchantProvider()),
        ChangeNotifierProvider(create: (_) => MerchantProductProvider()),
        ChangeNotifierProvider.value(value: profilePhotoProvider),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => MerchantOrderProvider()),
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
      title: 'CheaFood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF166534),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF9F7),
        useMaterial3: true,
      ),
      routes: {
        '/role': (_) => const RoleSelectionPage(),
        '/login': (_) => const AuthFlowPage(initialIsLogin: true),
        '/register': (_) => const AuthFlowPage(initialIsLogin: false),

        // HomeShell memuat bottom navigation (pola SPA).
        '/home': (_) => const HomeShell(),

        '/profile': (_) => const ProfilePage(),
        '/history': (_) => const OrderHistoryPage(),
        '/notification': (_) => const NotificationPage(),


        '/merchant': (_) => const MerchantShell(),

        '/merchant-products': (_) => const ProductListPage(),

        '/merchant-add-product': (_) => const AddProductPage(),

        '/merchant-edit-product': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments;

          final productId = args is int ? args : 0;

          return EditProductPage(
            productId: productId,
          );
        },

        '/merchant-orders': (_) => const OrderListPage(),

        '/merchant-scan': (_) => const ScanQrPage(),

        '/merchant-store': (_) => const StoreProfilePage(),

        '/merchant-notifications': (_) =>
            const MerchantNotificationPage(),
      },
      home: const SplashPage(),
    );
  }
}
