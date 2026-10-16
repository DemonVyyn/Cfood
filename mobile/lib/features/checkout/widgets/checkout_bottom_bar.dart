import 'package:flutter/material.dart';

class CheckoutBottomBar extends StatelessWidget {
  const CheckoutBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: const BoxDecoration(
        color: Colors.white,
      ),

      child: SafeArea(
        child: SizedBox(
          height: 55,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Pesanan berhasil dibuat",
                  ),
                ),
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFF0F8F67),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
              ),
            ),

            child: const Text(
              "Konfirmasi Pesanan",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}