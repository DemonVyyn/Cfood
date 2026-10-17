import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/location_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeApp();
    });
  }

  Future<void> initializeApp() async {
    final locationProvider =
        context.read<LocationProvider>();

    final auth =
        context.read<AuthProvider>();

    try {
      await locationProvider.startTracking();
    } catch (_) {}

    final loggedIn =
        await auth.checkLogin();

    if (!mounted) return;

    if (loggedIn) {
      final role = auth.user?.role;

      debugPrint(
        'AUTO LOGIN ROLE = $role',
      );

      if (role == 'mitra') {
        Navigator.pushReplacementNamed(
          context,
          '/merchant',
        );
      } else if (role == 'admin') {
        Navigator.pushReplacementNamed(
          context,
          '/admin',
        );
      } else {
        Navigator.pushReplacementNamed(
          context,
          '/home',
        );
      }
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/login',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(),
      ),
    );
  }
}