import 'package:flutter/material.dart';

class MerchantInfoDialog
    extends StatelessWidget {
  const MerchantInfoDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Panduan Penjualan CFood',
      ),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
                '1. Tambahkan produk surplus'),

            SizedBox(height: 8),

            Text(
                '2. Tentukan harga diskon'),

            SizedBox(height: 8),

            Text(
                '3. Customer melakukan pemesanan'),

            SizedBox(height: 8),

            Text(
                '4. Customer melakukan pembayaran'),

            SizedBox(height: 8),

            Text(
                '5. Sistem membuat QR Pickup'),

            SizedBox(height: 8),

            Text(
                '6. Customer datang ke toko'),

            SizedBox(height: 8),

            Text(
                '7. Scan QR Pickup'),

            SizedBox(height: 8),

            Text(
                '8. Pesanan selesai'),

            SizedBox(height: 8),

            Text(
                '9. Makanan berhasil diselamatkan dari food waste'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            'Tutup',
          ),
        ),
      ],
    );
  }
}