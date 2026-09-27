import 'package:flutter/material.dart';

class RoleHeader extends StatelessWidget {
  const RoleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,

          decoration: BoxDecoration(
            color: const Color(0xFF146C2E),
            borderRadius: BorderRadius.circular(24),
          ),

          child: const Icon(
            Icons.eco,
            color: Colors.white,
            size: 50,
          ),
        ),

        const SizedBox(height: 20),

        const Text(
          'CFood',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF146C2E),
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'Pilih Jenis Akun',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          'Masuk sebagai Customer atau Mitra',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}