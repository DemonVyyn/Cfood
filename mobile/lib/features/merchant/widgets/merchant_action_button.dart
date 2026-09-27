import 'package:flutter/material.dart';

class MerchantActionButton extends StatelessWidget {
  const MerchantActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text(
              'Scan QR Pickup Pelanggan',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.green.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () {},
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text(
              'Tambah Produk Surplus Baru',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor:
                  Colors.green.shade800,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}