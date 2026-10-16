import 'package:flutter/material.dart';

class RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: Colors.grey.shade300,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues( alpha: 0.05,),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),

        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,

              decoration: BoxDecoration(
                color: const Color( 0xFF146C2E, ).withValues( alpha: .1,),
                borderRadius: BorderRadius.circular(16),
              ),

              child: Icon(
                icon,
                size: 35,
                color: const Color(0xFF146C2E),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Color(0xFF146C2E),
            ),
          ],
        ),
      ),
    );
  }
}