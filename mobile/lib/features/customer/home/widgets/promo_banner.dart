import 'package:flutter/material.dart';

class PromoBanner extends StatelessWidget {
  final int highestDiscount;

  const PromoBanner({
    super.key,
    required this.highestDiscount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            const Color(0xffddf4dc),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              const Color(0xffb7e5b5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration:
                BoxDecoration(
              color: const Color(
                0xff166534,
              ),
              borderRadius:
                  BorderRadius
                      .circular(14),
            ),
            child: const Icon(
              Icons.percent,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                const Text(
                  "SURPLUS SPESIAL",
                  style: TextStyle(
                    fontSize: 11,
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
                  "Hemat hingga $highestDiscount%",
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight
                            .bold,
                    fontSize: 20,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                const Text(
                  "Selamatkan makanan surplus sebelum habis.",
                ),
              ],
            ),
          ),

          const CircleAvatar(
            backgroundColor:
                Colors.white,
            child: Icon(
              Icons.arrow_forward_ios,
              size: 18,
              color: Color(
                0xff166534,
              ),
            ),
          ),
        ],
      ),
    );
  }
}