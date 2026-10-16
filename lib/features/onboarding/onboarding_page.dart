
import 'package:flutter/material.dart';

import 'widgets/onboarding_appbar.dart';
import 'widgets/onboarding_button.dart';
import 'widgets/onboarding_content.dart';
import 'widgets/onboarding_logo.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  static const Color backgroundColor = Color(0xFFFAF9F7);
  static const Color primaryGreen = Color(0xFF166534);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/role',
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const OnboardingAppBar(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OnboardingLogo(),
                      SizedBox(height: 30),
                      OnboardingContent(),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OnboardingButton(
                      onTap: _continue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _continue,
                    style: TextButton.styleFrom(
                      foregroundColor: primaryGreen,
                    ),
                    child: const Text(
                      'Lewati',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
