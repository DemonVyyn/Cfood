import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final int totalFoods;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.totalFoods,
  });

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
                color:
                    Color(0xff166534),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      "Lokasi Pengambilan",
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            Colors.grey,
                      ),
                    ),
                    Text(
                      "Batam, Kepulauan Riau",
                      style: TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      "Halo, $userName 🌿",
                      style:
                          const TextStyle(
                        fontSize: 34,
                        fontWeight:
                            FontWeight
                                .bold,
                        color: Color(
                          0xff166534,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      "Ada $totalFoods makanan surplus siap diselamatkan hari ini.",
                    ),
                  ],
                ),
              ),

              const CircleAvatar(
                radius: 24,
                child: Icon(
                  Icons.person,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}