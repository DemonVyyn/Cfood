
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _taglineOpacity;

  static const Color _primaryColor = Color(0xFF1B5E3B);
  static const Color _accentColor = Color(0xFFA8D5B5);
  static const Color _backgroundColor = Color(0xFFF7F9F4);

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.0,
          0.55,
          curve: Curves.elasticOut,
        ),
      ),
    );

    _logoOpacity = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.0,
        0.35,
        curve: Curves.easeIn,
      ),
    );

    _titleOpacity = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.35,
        0.75,
        curve: Curves.easeIn,
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(
          0.35,
          0.8,
          curve: Curves.easeOutBack,
        ),
      ),
    );

    _taglineOpacity = CurvedAnimation(
      parent: _mainController,
      curve: const Interval(
        0.65,
        1.0,
        curve: Curves.easeIn,
      ),
    );

    _mainController.forward();

    _navigateToNextPage();
  }

  // Navigasi setelah animasi Splash Screen selesai.
  Future<void> _navigateToNextPage() async {
    // Splash Screen hanya berjalan selama 7 detik.
    await Future.delayed(const Duration(seconds: 5));

    if (!mounted) return;

    // Memeriksa status onboarding secara lokal.
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    final onboardingCompleted =
        prefs.getBool('onboarding_completed') ?? false;

    if (!onboardingCompleted) {
      Navigator.pushReplacementNamed(context, '/onboarding');
      return;
    }

    // Setelah onboarding, langsung menuju halaman login.
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _mainController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Stack(
        children: [
          // DEKORASI BACKGROUND
          Positioned(
            top: -100,
            right: -90,
            child: _buildCircle(
              size: 280,
              color: _accentColor.withValues(alpha: 0.25),
            ),
          ),

          Positioned(
            bottom: -120,
            left: -100,
            child: _buildCircle(
              size: 320,
              color: _primaryColor.withValues(alpha: 0.08),
            ),
          ),

          Positioned(
            top: 170,
            left: -45,
            child: _buildCircle(
              size: 110,
              color: _accentColor.withValues(alpha: 0.2),
            ),
          ),

          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // AREA LOGO DAN IKON MELAYANG
                  SizedBox(
                    width: 280,
                    height: 280,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran berdenyut.
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final scale =
                                1 + (_pulseController.value * 0.12);

                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 210,
                                height: 210,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _accentColor.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _accentColor.withValues(
                              alpha: 0.25,
                            ),
                          ),
                        ),

                        // LOGO CFood
                        FadeTransition(
                          opacity: _logoOpacity,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: Container(
                              width: 145,
                              height: 145,
                              decoration: BoxDecoration(
                                color: _primaryColor,
                                borderRadius: BorderRadius.circular(42),
                                boxShadow: [
                                  BoxShadow(
                                    color: _primaryColor.withValues(
                                      alpha: 0.25,
                                    ),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.restaurant_rounded,
                                color: Colors.white,
                                size: 76,
                              ),
                            ),
                          ),
                        ),

                        // IKON MAKANAN MELAYANG
                        _buildFloatingIcon(
                          icon: Icons.fastfood_rounded,
                          top: 15,
                          left: 45,
                          delay: 0,
                        ),

                        _buildFloatingIcon(
                          icon: Icons.local_pizza_rounded,
                          top: 45,
                          right: 20,
                          delay: 1,
                        ),

                        _buildFloatingIcon(
                          icon: Icons.eco_rounded,
                          bottom: 35,
                          left: 15,
                          delay: 2,
                        ),

                        _buildFloatingIcon(
                          icon: Icons.restaurant_menu_rounded,
                          bottom: 10,
                          right: 40,
                          delay: 3,
                        ),

                        _buildFloatingIcon(
                          icon: Icons.favorite_rounded,
                          top: 105,
                          right: 0,
                          delay: 4,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // JUDUL DAN TAGLINE
                  FadeTransition(
                    opacity: _titleOpacity,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Column(
                        children: [
                          const Text(
                            'CFood',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: _primaryColor,
                              letterSpacing: -1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          FadeTransition(
                            opacity: _taglineOpacity,
                            child: const Text(
                              'Makanan Berlebih, Harga Lebih Hemat',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF718078),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  // ANIMASI LOADING
                  AnimatedBuilder(
                    animation: _floatingController,
                    builder: (context, child) {
                      final opacity = 0.35 +
                          (0.65 *
                              math.sin(
                                _floatingController.value *
                                    math.pi *
                                    2,
                              ).abs());

                      return SizedBox(
                        width: 45,
                        height: 45,
                        child: CircularProgressIndicator(
                          value: null,
                          strokeWidth: 3,
                          color: _primaryColor.withValues(
                            alpha: opacity,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Mempersiapkan pengalaman terbaik...',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF929A94),
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Spacer(),

                  // FOOTER
                  const Padding(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Text(
                      'MENGURANGI FOOD WASTE, MENYELAMATKAN MAKANAN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Color(0x991B5E3B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET DEKORASI LINGKARAN
  Widget _buildCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  // WIDGET IKON MELAYANG
  Widget _buildFloatingIcon({
    required IconData icon,
    double? top,
    double? bottom,
    double? left,
    double? right,
    required int delay,
  }) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        final movement = math.sin(
          (_floatingController.value * 2 * math.pi) +
              delay.toDouble(),
        );

        return Positioned(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          child: Transform.translate(
            offset: Offset(0, movement * 9),
            child: Transform.rotate(
              angle: movement * 0.08,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withValues(alpha: 0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: _primaryColor,
                  size: 25,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
