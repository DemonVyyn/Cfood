import 'package:flutter/material.dart';

class PickupInfo extends StatelessWidget {
  const PickupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          const Text(
            "Detail Pengambilan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          const Row(
            children: [
              Icon(Icons.location_on),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Jl. Kemang Raya No.14 Jakarta Selatan",
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Row(
            children: [
              Icon(Icons.access_time),
              SizedBox(width: 8),
              Text(
                "Hari ini, 19:30 - 21:00 WIB",
              ),
            ],
          ),
        ],
      ),
    );
  }
}