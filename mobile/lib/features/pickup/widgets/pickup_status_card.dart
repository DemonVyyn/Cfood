import 'package:flutter/material.dart';

class PickupStatusCard extends StatelessWidget {
  const PickupStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green.shade700,
            child: const Icon(
              Icons.store,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "STATUS PESANAN",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Siap Diambil di Outlet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}