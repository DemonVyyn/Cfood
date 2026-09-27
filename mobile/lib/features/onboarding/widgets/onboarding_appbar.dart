import 'package:flutter/material.dart';

class OnboardingAppBar
    extends StatelessWidget {
  const OnboardingAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on,
            color:
                Color(0xFF166534),
          ),
          const SizedBox(width: 4),
          const Text('Batam'),

          const Spacer(),

          const Text(
            'CFood',
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
              color:
                  Color(0xFF166534),
            ),
          ),

          const Spacer(),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
    );
  }
}