
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.restaurant_rounded,
      title: 'Makanan Enak,\nHarga Lebih Hemat',
      description:
          'Temukan makanan berlebih dari restoran dan mitra pilihan dengan harga yang lebih terjangkau.',
      color: const Color(0xFFE8F3E9),
    ),
    _OnboardingData(
      icon: Icons.discount_rounded,
      title: 'Nikmati Diskon\nSetiap Hari',
      description:
          'Dapatkan berbagai pilihan makanan dengan potongan harga menarik sebelum persediaan habis.',
      color: const Color(0xFFFFF1DB),
    ),
    _OnboardingData(
      icon: Icons.eco_rounded,
      title: 'Bersama Kurangi\nFood Waste',
      description:
          'Setiap makanan yang kamu selamatkan adalah langkah kecil untuk lingkungan yang lebih baik.',
      color: const Color(0xFFE5F0EA),
    ),
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  void _nextPage() {
    if (_currentPage == _pages.length - 1) {
      _finishOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBF8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.restaurant_rounded,
                    color: Color(0xFF1B5E3B),
                    size: 27,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'CFood',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1B5E3B),
                    ),
                  ),
                  const Spacer(),
                  if (!isLastPage)
                    TextButton(
                      onPressed: _finishOnboarding,
                      child: const Text(
                        'Lewati',
                        style: TextStyle(
                          color: Color(0xFF7B887F),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Onboarding pages
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration
                        Container(
                          width: 270,
                          height: 270,
                          decoration: BoxDecoration(
                            color: page.color,
                            borderRadius: BorderRadius.circular(135),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 205,
                                height: 205,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(
                                    alpha: 0.65,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(105),
                                ),
                              ),
                              Icon(
                                page.icon,
                                size: 105,
                                color: const Color(0xFF1B5E3B),
                              ),
                              Positioned(
                                right: 35,
                                top: 45,
                                child: Icon(
                                  Icons.auto_awesome_rounded,
                                  size: 32,
                                  color: const Color(0xFFE5A33B),
                                ),
                              ),
                              Positioned(
                                left: 35,
                                bottom: 48,
                                child: Icon(
                                  Icons.eco_rounded,
                                  size: 30,
                                  color: const Color(0xFF6DAB78),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // Title
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 29,
                            height: 1.25,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1D3528),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Description
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.7,
                            color: Color(0xFF7B887F),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom navigation
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 12, 30, 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) {
                        final isActive = _currentPage == index;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          width: isActive ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF1B5E3B)
                                : const Color(0xFFDCE5DC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E3B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLastPage
                                ? 'Mulai Sekarang'
                                : 'Lanjutkan',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
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

class _OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
