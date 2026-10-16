import 'package:flutter/material.dart';

import '../../data/dummy_foods.dart';

class FoodDetailPage extends StatefulWidget {
  final DummyFood food;

  const FoodDetailPage({
    super.key,
    required this.food,
  });

  @override
  State<FoodDetailPage> createState() =>
      _FoodDetailPageState();
}

class _FoodDetailPageState
    extends State<FoodDetailPage> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final food = widget.food;

    return Scaffold(
      backgroundColor: const Color(
        0xffF5F6F7,
      ),

      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // IMAGE
                Stack(
                  children: [
                    Image.network(
                      food.image,
                      width: double.infinity,
                      height: 320,
                      fit: BoxFit.cover,
                    ),

                    SafeArea(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),
                        child: Row(
                          children: [
                            _circleButton(
                              Icons.arrow_back,
                              () {
                                Navigator.pop(
                                  context,
                                );
                              },
                            ),

                            const Spacer(),

                            _circleButton(
                              Icons.share,
                              () {},
                            ),

                            const SizedBox(
                              width: 12,
                            ),

                            _circleButton(
                              Icons.bookmark_border,
                              () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Transform.translate(
                  offset: const Offset(
                    0,
                    -20,
                  ),
                  child: Container(
                    width: double.infinity,

                    decoration:
                        const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(
                        top: Radius.circular(
                          28,
                        ),
                      ),
                    ),

                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        20,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          // BADGES
                          Row(
                            children: [
                              badge(
                                "Batas Konsumsi: 3 Hari",
                                const Color.fromARGB(255, 237, 19, 4),
                              ),

                              const SizedBox(
                                width: 8,
                              ),

                              badge(
                                "🌿 Hemat 67%",
                                Colors.green,
                              ),

                              const Spacer(),

                              badge(
                                "♻️ 1.4 kg CO₂",
                                Colors.green,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          // MERCHANT
                          Container(
                            padding:
                                const EdgeInsets
                                    .all(
                              16,
                            ),
                            decoration:
                                BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                18,
                              ),
                              border:
                                  Border.all(
                                color: Colors
                                    .grey
                                    .shade200,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      Colors
                                          .green
                                          .shade100,
                                  child:
                                      const Icon(
                                    Icons
                                        .bakery_dining,
                                    color: Color(
                                      0xff166534,
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  width: 14,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                    children: [
                                      Text(
                                        food.store,
                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,
                                          fontSize:
                                              20,
                                        ),
                                      ),

                                      const SizedBox(
                                        height:
                                            4,
                                      ),

                                      Text(
                                        "⭐ ${food.rating} • 420+ ulasan",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          Text(
                            food.name,
                            style:
                                const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),

                          const SizedBox(
                            height: 12,
                          ),

                          Row(
                            children: [
                              Text(
                                "Rp ${food.discountPrice}",
                                style:
                                    const TextStyle(
                                  fontSize:
                                      34,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  color: Color(
                                    0xff166534,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 10,
                              ),

                              Text(
                                "Rp ${food.originalPrice}",
                                style:
                                    const TextStyle(
                                  decoration:
                                      TextDecoration
                                          .lineThrough,
                                  color:
                                      Colors
                                          .grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 24,
                          ),

                          // PICKUP CARD
                          buildCard(
                            title:
                                "Detail Pengambilan",
                            child: Column(
                              children: [
                                rowInfo(
                                  Icons.location_on,
                                  "Jl. Kemang Raya No.14",
                                ),
                                const SizedBox(
                                  height:
                                      12,
                                ),
                                rowInfo(
                                  Icons.schedule,
                                  "Hari ini, 19:30 - 21:00 WIB",
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          buildCard(
                            title:
                                "Deskripsi Makanan",
                            child: Text(
                              "Paket kejutan berisi aneka croissant butter, artisan sourdough segar dan pastry premium yang tidak terjual namun masih layak konsumsi.",
                              style:
                                  const TextStyle(
                                height:
                                    1.6,
                              ),
                            ),
                          ),

                          const SizedBox(
                            height:
                                120,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // BOTTOM BAR
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding:
                  const EdgeInsets.all(
                16,
              ),
              decoration:
                  const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    color:
                        Colors.black12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .grey.shade100,
                      borderRadius:
                          BorderRadius
                              .circular(
                        14,
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_cart,
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: SizedBox(
                      height: 55,
                      child:
                          ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/checkout',
                          );
                        },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xff166534,
                          ),
                        ),
                        child:
                            const Text(
                          "Pesan Sekarang",
                          style:
                              TextStyle(
                            color: Colors
                                .white,
                            fontWeight:
                                FontWeight
                                    .bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration:
            const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon),
      ),
    );
  }

  Widget badge(
    String text,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(
          30,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .start,
        children: [
          Text(
            title,
            style:
                const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          child,
        ],
      ),
    );
  }

  Widget rowInfo(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(
            0xff166534,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    );
  }
}