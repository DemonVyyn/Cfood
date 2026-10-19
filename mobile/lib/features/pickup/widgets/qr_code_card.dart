
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeCard extends StatelessWidget {
  final String pickupCode;

  const QrCodeCard({
    super.key,
    required this.pickupCode,
  });

  @override
  Widget build(BuildContext context) {
    final hasCode = pickupCode.trim().isNotEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Voucher Pengambilan Surplus'),
            const SizedBox(height: 20),
            Container(
              width: 220,
              height: 220,
              alignment: Alignment.center,
              color: Colors.white,
              child: hasCode
                  ? QrImageView(
                      data: pickupCode,
                      version: QrVersions.auto,
                      size: 200,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.M,
                    )
                  : const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
            ),
            const SizedBox(height: 16),
            SelectableText(
              hasCode ? pickupCode : 'Kode pengambilan tidak tersedia',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tunjukkan QR ini kepada Mitra saat mengambil pesanan.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
