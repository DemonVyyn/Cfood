import 'package:flutter/material.dart';

class PickupScheduleCard extends StatelessWidget {
  const PickupScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.green.shade100,
          child: const Icon(
            Icons.access_time,
            color: Colors.green,
          ),
        ),
        title: const Text(
          "Jadwal Pengambilan",
        ),
        subtitle: const Text(
          "Hari ini pukul 19:30 - 21:00 WIB",
        ),
      ),
    );
  }
}