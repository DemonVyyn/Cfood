import 'dart:async';

import 'package:flutter/material.dart';

import 'onboarding_page.dart';

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

    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const OnboardingPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color:
                    const Color(0xFF166534),
                borderRadius:
                    BorderRadius.circular(
                  30,
                ),
              ),
              child: const Icon(
                Icons.eco,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'CFood',
              style: TextStyle(
                fontSize: 34,
                fontWeight:
                    FontWeight.bold,
                color:
                    Color(0xFF166534),
              ),
            ),
            const SizedBox(height: 8),
            const CircularProgressIndicator(
              color:
                  Color(0xFF166534),
            ),
          ],
        ),
      ),
    );
  }
}