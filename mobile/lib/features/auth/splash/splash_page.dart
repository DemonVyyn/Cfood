import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() =>
      _SplashPageState();
}

class _SplashPageState
    extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    checkAuth();
  }

  Future<void> checkAuth() async {
    final auth =
        Provider.of<AuthProvider>(
      context,
      listen: false,
    );

    final loggedIn =
        await auth.checkLogin();

    if (!mounted) return;

    if (loggedIn) {
      if (auth.user?.role ==
          'mitra') {
        Navigator.pushReplacementNamed(
          context,
          '/merchant',
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
        child: CircularProgressIndicator(),
      ),
    );
  }
}