import 'package:flutter/material.dart';

class MerchantActionButton extends StatelessWidget {
  const MerchantActionButton({super.key});

  static const Color primaryGreen = Color(0xFF14DE32);
  static const Color darkGreen = Color(0xFF0CB52A);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.qr_code_scanner_rounded),
            label: const Text('Scan QR Pickup Pelanggan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: darkGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/merchant-scan-qr');
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text('Tambah Produk Surplus Baru'),
            style: OutlinedButton.styleFrom(
              foregroundColor: darkGreen,
              backgroundColor: Colors.white,
              side: const BorderSide(color: primaryGreen, width: 1.3),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/merchant-add-product');
            },
          ),
        ),
      ],
    );
  }
}