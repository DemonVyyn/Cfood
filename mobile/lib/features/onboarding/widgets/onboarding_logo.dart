import 'package:flutter/material.dart';

class OnboardingLogo
    extends StatelessWidget {
  const OnboardingLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: BoxDecoration(
        color:
            const Color(0xFF166534),
        borderRadius:
            BorderRadius.circular(
          28,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color:
                Colors.black12,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        Icons.eco,
        size: 60,
        color: Colors.white,
      ),
    );
  }
}