import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/merchant_product_provider.dart';

class ProductCard extends StatelessWidget {
  final int id;

  final String name;

  final int stock;

  final double price;

  final String status;

  final String? photo;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
    required this.status,
    required this.photo,
  });

  Color get statusColor {
    switch (status) {
      case 'aktif':
        return Colors.green;

      case 'habis':
        return Colors.orange;

      case 'expired':
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 14,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                  child: photo != null &&
                          photo!.isNotEmpty
                      ? Image.network(
                          photo!,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 75,
                          height: 75,
                          color:
                              Colors.green.shade50,
                          child: const Icon(
                            Icons.fastfood,
                            color: Colors.green,
                            size: 32,
                          ),
                        ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 2,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        "Rp ${price.toStringAsFixed(0)}",
                        style:
                            const TextStyle(
                          color:
                              Colors.green,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(
                        height: 6,
                      ),

                      Text(
                        "Stok : $stock",
                        style:
                            const TextStyle(
                          color:
                              Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor
                        .withValues(
                      alpha: 0.15,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      30,
                    ),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      color:
                          statusColor,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon:
                        const Icon(Icons.edit),
                    label:
                        const Text("Edit"),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/merchant-edit-product',
                        arguments: id,
                      );
                    },
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child:
                      ElevatedButton.icon(
                    icon: const Icon(
                      Icons.delete,
                    ),
                    label: const Text(
                      "Hapus",
                    ),
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.red,
                      foregroundColor:
                          Colors.white,
                    ),
                    onPressed: () async {
                      final provider =
                          context.read<
                              MerchantProductProvider>();

                      final messenger =
                          ScaffoldMessenger.of(
                        context,
                      );

                      final confirm =
                          await showDialog<bool>(
                        context:
                            context,
                        builder:
                            (context) =>
                                AlertDialog(
                          title:
                              const Text(
                            'Hapus Produk',
                          ),
                          content:
                              const Text(
                            'Yakin ingin menghapus produk ini?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  false,
                                );
                              },
                              child:
                                  const Text(
                                'Batal',
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                  true,
                                );
                              },
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.red,
                              ),
                              child:
                                  const Text(
                                'Hapus',
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) {
                        return;
                      }

                      await provider
                          .deleteProduct(
                        id,
                      );

                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Produk berhasil dihapus',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}