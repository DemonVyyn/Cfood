import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Color(0xFF166534),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              "Cari bakery, resto, atau cafe terdekat...",
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),

          const Icon(
            Icons.tune,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}