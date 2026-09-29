import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/merchant_product_model.dart';
import '../../../../providers/merchant_product_provider.dart';

class ProductCard extends StatelessWidget {
  final MerchantProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  String formatRupiah(double value) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(value);
  }

  double get discountPercent {
    if (product.originalPrice <= 0) {
      return 0;
    }

    return ((product.originalPrice -
                product.discountPrice) /
            product.originalPrice) *
        100;
  }

  bool get isSoldOut {
    return product.stock <= 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
            alpha: 0.05,
            ),
            blurRadius: 15,
            offset: const Offset(
              0,
              4,
            ),
          ),
        ],
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                  child:
                      product.photo !=
                                  null &&
                              product
                                  .photo!
                                  .isNotEmpty
                          ? Image.network(
                              product.photo!,
                              height: 180,
                              width:
                                  double.infinity,
                              fit:
                                  BoxFit.cover,
                            )
                          : Container(
                              height: 180,
                              width:
                                  double.infinity,
                              color: Colors
                                  .green
                                  .shade50,
                              child:
                                  const Icon(
                                Icons.fastfood,
                                size: 70,
                                color:
                                    Colors.green,
                              ),
                            ),
                ),

                Positioned(
                  left: 12,
                  top: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.green,
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),
                    child: Text(
                      "Hemat ${discountPercent.toStringAsFixed(0)}%",
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                if (isSoldOut)
                  Positioned.fill(
                    child: Container(
                      decoration:
                          BoxDecoration(
                        color:
                            Colors.black54,
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                      child:
                          const Center(
                        child: Text(
                          "HABIS TERJUAL",
                          style:
                              TextStyle(
                            color:
                                Colors.white,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            Text(
              product.kategori
                  .toUpperCase(),
              style:
                  const TextStyle(
                color:
                    Colors.green,
                fontWeight:
                    FontWeight.bold,
                fontSize: 12,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              product.name,
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
                fontSize: 22,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            Text(
              product.description,
              maxLines: 2,
              overflow:
                  TextOverflow.ellipsis,
              style:
                  const TextStyle(
                color:
                    Colors.black54,
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  formatRupiah(
                    product.discountPrice,
                  ),
                  style:
                      const TextStyle(
                    color:
                        Colors.green,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 28,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  formatRupiah(
                    product.originalPrice,
                  ),
                  style:
                      const TextStyle(
                    decoration:
                        TextDecoration
                            .lineThrough,
                    color:
                        Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            const Divider(
              height: 30,
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          product.stock > 0
                              ? Colors
                                  .green
                                  .shade50
                              : Colors
                                  .red
                                  .shade50,
                      borderRadius:
                          BorderRadius.circular(
                        30,
                      ),
                    ),
                    child: Text(
                      product.stock > 0
                          ? "Stok ${product.stock}"
                          : "Stok Habis",
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        color:
                            product.stock >
                                    0
                                ? Colors
                                    .green
                                : Colors.red,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Container(
                  decoration:
                      BoxDecoration(
                    color: Colors
                        .green
                        .shade50,
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/merchant-edit-product',
                        arguments:
                            product.id,
                      );
                    },
                    icon:
                        const Icon(
                      Icons
                          .edit_outlined,
                      color:
                          Colors.green,
                    ),
                  ),
                ),

                const SizedBox(
                  width: 8,
                ),

                Container(
                  decoration:
                      BoxDecoration(
                    color:
                        Colors.red
                            .shade50,
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: IconButton(
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
    context: context,
    builder: (dialogContext) =>
        AlertDialog(
      title: const Text(
        'Hapus Produk',
      ),
      content: const Text(
        'Yakin ingin menghapus produk ini?',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(
              dialogContext,
            ).pop(false);
          },
          child: const Text(
            'Batal',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(
              dialogContext,
            ).pop(true);
          },
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                Colors.red,
            foregroundColor:
                Colors.white,
          ),
          child: const Text(
            'Hapus',
          ),
        ),
      ],
    ),
  );

  if (confirm != true) {
    return;
  }

  await provider.deleteProduct(
    product.id,
  );

  if (!context.mounted) {
    return;
  }

  messenger.showSnackBar(
    const SnackBar(
      content: Text(
        'Produk berhasil dihapus',
      ),
    ),
  );
},
                    icon:
                        const Icon(
                      Icons
                          .delete_outline,
                      color:
                          Colors.red,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            Row(
              children: [
                const Icon(
                  Icons.schedule,
                  size: 16,
                  color:
                      Colors.black54,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  "Expired ${product.expiredFormatted}",
                  style:
                      const TextStyle(
                    color:
                        Colors.black54,
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