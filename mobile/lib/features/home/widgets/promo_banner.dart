import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFFDDF4DC),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFB7E5B5),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF166534),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.percent,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "SURPLUS SPESIAL",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.bold,
                    color: Color(0xFF166534),
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Hemat hingga 70% Hari Ini!",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Selamatkan surplus lezat sebelum malam tiba.",
                ),
              ],
            ),
          ),

          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Color(0xFF166534),
            ),
          ),
        ],
      ),
    );
  }
}