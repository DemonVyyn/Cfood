import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/food_provider.dart';

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
        title:
            const Text(
          'Makanan Surplus',
        ),
      ),
      body:
          Consumer<
            FoodProvider
          >(
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

          return ListView.builder(
            itemCount:
                provider.foods.length,
            itemBuilder: (
              context,
              index,
            ) {
              final food =
                  provider
                      .foods[index];

              return Card(
                margin:
                    const EdgeInsets.all(
                  10,
                ),
                child: ListTile(
                  title: Text(
                    food.nama,
                  ),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        food.namaToko,
                      ),

                      Text(
                        'Rp ${food.hargaDiskon.toInt()}',
                      ),

                      Text(
                        'Stok ${food.stok}',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}