import 'package:flutter/material.dart';

class MerchantNotificationPage
    extends StatelessWidget {
  const MerchantNotificationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Notifikasi'),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading:
                Icon(Icons.shopping_bag),
            title: Text(
              'Pesanan Baru',
            ),
            subtitle: Text(
              'Ada pesanan baru yang masuk',
            ),
          ),

          Divider(),

          ListTile(
            leading:
                Icon(Icons.warning),
            title: Text(
              'Stok Hampir Habis',
            ),
            subtitle: Text(
              'Nasi Goreng tinggal 2 porsi',
            ),
          ),

          Divider(),

          ListTile(
            leading:
                Icon(Icons.restaurant),
            title: Text(
              'Produk Expired Hari Ini',
            ),
            subtitle: Text(
              'Roti Coklat expired pukul 22:00',
            ),
          ),

          Divider(),

          ListTile(
            leading:
                Icon(Icons.check_circle),
            title: Text(
              'Pickup Berhasil',
            ),
            subtitle: Text(
              'Pesanan #123 selesai',
            ),
          ),
        ],
      ),
    );
  }
}