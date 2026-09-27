import 'package:flutter/material.dart';

class MerchantHeader
    extends StatelessWidget {
  final String storeName;

  const MerchantHeader({
    super.key,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor:
              Colors.green.shade700,
          child: const Icon(
            Icons.store,
            color: Colors.white,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "MITRA CFood",
              ),

              Text(
                storeName,
                style: const TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),

        const Switch(
          value: true,
          onChanged: null,
        ),
      ],
    );
  }
}