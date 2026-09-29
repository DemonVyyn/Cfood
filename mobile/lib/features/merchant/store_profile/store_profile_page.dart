import 'package:flutter/material.dart';

import 'widgets/store_header.dart';
import 'widgets/store_info_card.dart';

class StoreProfilePage extends StatelessWidget {
  const StoreProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Toko')),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: const [StoreHeader(), SizedBox(height: 20), StoreInfoCard()],
      ),
    );
  }
}
