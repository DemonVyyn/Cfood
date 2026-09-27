import 'package:flutter/material.dart';

class ImpactCard extends StatelessWidget {
  const ImpactCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF166534),
            Color(0xFF0F4A25),
          ],
        ),
        borderRadius:
            BorderRadius.circular(28),
      ),

      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            "Dampak Komunitasmu",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          SizedBox(height: 20),

          Text(
            "1,248 kg",
            style: TextStyle(
              fontSize: 42,
              fontWeight:
                  FontWeight.bold,
              color: Colors.white,
            ),
          ),

          Text(
            "Makanan Terselamatkan",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              Text(
                "3.1 ton CO2e",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Text(
                "142 Pohon 🌳",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}