import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF166534),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lokasi Pengambilan",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      "Kepulauan Riau, Batam",
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Halo, Tama! 🌿",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight:
                            FontWeight.bold,
                        color:
                            Color(0xFF166534),
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Ada 18 makanan surplus siap diselamatkan hari ini.",
                    ),
                  ],
                ),
              ),

              CircleAvatar(
                radius: 24,
                backgroundImage:
                    NetworkImage(
                  'https://i.pravatar.cc/150',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}