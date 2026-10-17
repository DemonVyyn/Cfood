
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/food_provider.dart';
import 'providers/location_provider.dart';
import 'providers/merchant_provider.dart';
import 'providers/merchant_product_provider.dart';
import 'providers/merchant_order_provider.dart';

import 'features/auth/splash/splash_page.dart';
import 'core/routes/app_routes.dart';

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
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MerchantOrderProvider(),
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
      title: 'CFood',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF166534),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF9F7),
        useMaterial3: true,
      ),
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      home: const SplashPage(),
    );
  }
}
