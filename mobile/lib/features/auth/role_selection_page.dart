import 'package:flutter/material.dart';
import 'role/widgets/role_card.dart';
import 'role/widgets/role_header.dart';
import '../../core/storage/role_manager.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              const SizedBox(height: 40),

              const RoleHeader(),

              const SizedBox(height: 60),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoleCard(
                      title: 'Customer',
                      subtitle:
                          'Cari makanan berlebih dengan harga lebih hemat.',
                      icon: Icons.shopping_bag_outlined,
                      onTap: () {
  RoleManager.currentRole =
      'customer';

  Navigator.pushNamed(
    context,
    '/login',
  );
},
                    ),

                    const SizedBox(height: 24),

                    RoleCard(
                      title: 'Mitra',
                      subtitle:
                          'Jual makanan berlebih dan bantu kurangi food waste.',
                      icon: Icons.storefront_outlined,
                      onTap: () {
  RoleManager.currentRole =
      'mitra';

  Navigator.pushNamed(
    context,
    '/login',
  );
},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}