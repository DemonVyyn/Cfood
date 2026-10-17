import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/food_provider.dart';
import '../../models/food_model.dart';
import '../../data/dummy_foods.dart';
import 'food_detail_page.dart';
import '../../widgets/curved_bottom_nav.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() =>
      _FoodPageState();
}

class _FoodPageState
    extends State<FoodPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) return;

      context
          .read<FoodProvider>()
          .loadFoods();
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Makanan Surplus',
        ),
      ),

      body: Consumer<FoodProvider>(
        builder: (
          context,
          provider,
          child,
        ) {
          if (provider.isLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (provider.foods.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada makanan tersedia',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadFoods();
            },
            child: ListView.builder(
              itemCount:
                  provider.foods.length,
              itemBuilder: (
                context,
                index,
              ) {
                final FoodModel food =
                    provider.foods[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  elevation: 2,

                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FoodDetailPage(
                            food: food.toDummyFood(),
                          ),
                        ),
                      );
                    },

                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.vertical(
                            top: Radius.circular(
                              12,
                            ),
                          ),
                          child: Image.network(
                            food.foto,
                            width:
                                double.infinity,
                            height: 180,
                            fit: BoxFit.cover,

                            errorBuilder:
                                (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Container(
                                height: 180,
                                color:
                                    Colors.grey
                                        .shade200,
                                child:
                                    const Center(
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Padding(
                          padding:
                              const EdgeInsets.all(
                            12,
                          ),

                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                food.nama,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      18,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                food.namaToko,
                                style:
                                    TextStyle(
                                  color: Colors
                                      .grey
                                      .shade600,
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                food.deskripsi,
                                maxLines: 2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                              ),

                              const SizedBox(
                                height: 10,
                              ),

                              Row(
                                children: [
                                  Text(
                                    'Rp ${food.hargaDiskon.toInt()}',
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors
                                              .green,
                                      fontWeight:
                                          FontWeight
                                              .bold,
                                      fontSize:
                                          18,
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 10,
                                  ),

                                  Text(
                                    'Rp ${food.hargaOriginal.toInt()}',
                                    style:
                                        const TextStyle(
                                      color:
                                          Colors
                                              .grey,
                                      decoration:
                                          TextDecoration
                                              .lineThrough,
                                    ),
                                  ),

                                  const Spacer(),

                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                      horizontal:
                                          10,
                                      vertical:
                                          4,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .green
                                          .shade100,
                                      borderRadius:
                                          BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Text(
                                      'Stok ${food.stok}',
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar:
          const CurvedBottomNav(
        currentIndex: 0,
      )
    );
  }
}