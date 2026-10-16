import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.green.shade100,
          child: const Icon(
            Icons.notifications,
            color: Colors.green,
          ),
        ),
        title: Text(title),
        subtitle: Text(message),
        trailing: Text(time),
      ),
    );
  }
}