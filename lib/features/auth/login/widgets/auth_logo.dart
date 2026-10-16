import 'package:flutter/material.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF166534),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.eco,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mealio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF166534),
              ),
            ),
            Text(
              'RESCUE SURPLUS FOOD',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}