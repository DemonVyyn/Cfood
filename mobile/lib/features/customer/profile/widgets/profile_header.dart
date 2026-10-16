import 'package:flutter/material.dart';

class ProfileHeader
    extends StatelessWidget {
  const ProfileHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.all(20),

      child: const Column(
        children: [
          CircleAvatar(
            radius: 45,
            child: Icon(
              Icons.person,
              size: 45,
            ),
          ),

          SizedBox(height: 12),

          Text(
            "Avnes Pratama",
            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 18,
            ),
          ),

          Text(
            "tama@gmail.com",
          ),
        ],
      ),
    );
  }
}