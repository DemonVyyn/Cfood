import 'package:flutter/material.dart';

import 'widgets/scan_overlay.dart';

class ScanQrPage
    extends StatelessWidget {
  const ScanQrPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.black,

      appBar: AppBar(
        title:
            const Text(
          'Scan QR Pickup',
        ),
      ),

      body: const Stack(
        children: [
          Center(
            child: Text(
              'Camera Preview',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          ScanOverlay(),
        ],
      ),
    );
  }
}