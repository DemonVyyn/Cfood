import 'package:flutter/material.dart';

import 'widgets/pickup_status_card.dart';
import 'widgets/qr_code_card.dart';
import 'widgets/pickup_schedule_card.dart';
import 'widgets/merchant_location_card.dart';
import 'widgets/order_detail_card.dart';
import 'widgets/pickup_instruction_card.dart';

class PickupQrPage extends StatelessWidget {
  const PickupQrPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text("Tiket Pengambilan"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            PickupStatusCard(),
            SizedBox(height: 16),

            QrCodeCard(),
            SizedBox(height: 16),

            PickupScheduleCard(),
            SizedBox(height: 16),

            MerchantLocationCard(),
            SizedBox(height: 16),

            OrderDetailCard(),
            SizedBox(height: 16),

            PickupInstructionCard(),
          ],
        ),
      ),
    );
  }
}