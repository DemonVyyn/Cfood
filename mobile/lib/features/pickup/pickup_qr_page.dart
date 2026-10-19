
import 'package:flutter/material.dart';

import '../../../models/food_model.dart';
import '../../../widgets/curved_bottom_nav.dart';
import 'widgets/pickup_status_card.dart';
import 'widgets/qr_code_card.dart';
import 'widgets/pickup_schedule_card.dart';
import 'widgets/merchant_location_card.dart';
import 'widgets/order_detail_card.dart';
import 'widgets/pickup_instruction_card.dart';

class PickupQrPage extends StatelessWidget {
  final Map<String, dynamic> order;
  final FoodModel food;
  final int quantity;

  const PickupQrPage({
    super.key,
    required this.order,
    required this.food,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        title: const Text('Tiket Pengambilan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const PickupStatusCard(),
            const SizedBox(height: 16),
            QrCodeCard(
              pickupCode: order['kode_pengambilan']?.toString() ?? '',
            ),
            const SizedBox(height: 16),
            const PickupScheduleCard(),
            const SizedBox(height: 16),
            const MerchantLocationCard(),
            const SizedBox(height: 16),
            OrderDetailCard(
              food: food,
              quantity: quantity,
              order: order,
            ),
            const SizedBox(height: 16),
            const PickupInstructionCard(),
          ],
        ),
      ),
      bottomNavigationBar: const CurvedBottomNav(
        currentIndex: 0,
      ),
    );
  }
}
