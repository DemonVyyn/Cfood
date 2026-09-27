import 'package:flutter/material.dart';

class StoreInfoCard
    extends StatelessWidget {
  const StoreInfoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          children: const [
            ListTile(
              leading:
                  Icon(Icons.location_on),
              title: Text(
                'Alamat Toko',
              ),
              subtitle: Text(
                'Jakarta Selatan',
              ),
            ),

            Divider(),

            ListTile(
              leading: Icon(Icons.phone),
              title: Text(
                'Nomor Telepon',
              ),
              subtitle: Text(
                '08123456789',
              ),
            ),
          ],
        ),
      ),
    );
  }
}