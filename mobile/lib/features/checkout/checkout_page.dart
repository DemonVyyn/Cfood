import 'package:flutter/material.dart';

import 'widgets/checkout_header.dart';
import 'widgets/pickup_location_card.dart';
import 'widgets/order_summary_card.dart';
import 'widgets/payment_method_card.dart';
import 'widgets/checkout_bottom_bar.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: const [
              CheckoutHeader(),

              PickupLocationCard(),

              OrderSummaryCard(),

              PaymentMethodCard(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const CheckoutBottomBar(),
    );
  }
}