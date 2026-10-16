import 'package:flutter/material.dart';

class OnboardingContent
    extends StatelessWidget {
  const OnboardingContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Column(
        children: [
          const Text(
            'CFood',
            style: TextStyle(
              fontSize: 38,
              fontWeight:
                  FontWeight.bold,
              color:
                  Color(0xFF166534),
            ),
          ),

          const Text(
            'PBL SEMESTER 3',
            style: TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 40),

          Text(
            'Selamatkan Makanan, Kurangi Food Waste bersama komunitas peduli lingkungan urban.',
            textAlign:
                TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}