import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/merchant_product_model.dart';
import '../../../providers/merchant_product_provider.dart';

class EditProductPage extends StatefulWidget {
  final int productId;

  const EditProductPage({
    super.key,
    required this.productId,
  });

  @override
  State<EditProductPage> createState() =>
      _EditProductPageState();
}

class _EditProductPageState
    extends State<EditProductPage> {
  final namaController =
      TextEditingController();

  final deskripsiController =
      TextEditingController();

  final kategoriController =
      TextEditingController();

  final hargaOriginalController =
      TextEditingController();

  final hargaDiskonController =
      TextEditingController();

  final stokController =
      TextEditingController();

  final expiredController =
      TextEditingController();

  bool loaded = false;

  MerchantProductModel? product;

  @override
  void initState() {
    super.initState();

    Future.microtask(
      loadProduct,
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    deskripsiController.dispose();
    kategoriController.dispose();
    hargaOriginalController.dispose();
    hargaDiskonController.dispose();
    stokController.dispose();
    expiredController.dispose();

    super.dispose();
  }

  Future<void> loadProduct() async {
    final provider =
        context.read<
            MerchantProductProvider>();

    final result =
        await provider.getProduct(
      widget.productId,
    );

    if (result == null) {
      return;
    }

    product = result;

    namaController.text =
        result.name;

    deskripsiController.text =
        result.description;

    kategoriController.text =
        result.kategori;

    hargaOriginalController.text =
        result.originalPrice
            .toInt()
            .toString();

    hargaDiskonController.text =
        result.discountPrice
            .toInt()
            .toString();

    stokController.text =
        result.stock.toString();

    try {
      final date =
          DateTime.parse(
        result.expiredAt,
      );

      expiredController.text =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} "
          "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}";
    } catch (e) {
      expiredController.text =
          result.expiredAt;
    }

    if (mounted) {
      setState(() {
        loaded = true;
      });
    }
  }

  Future<void> selectDate() async {
    final pickedDate =
        await showDatePicker(
      context: context,
      initialDate:
          DateTime.now(),
      firstDate:
          DateTime.now(),
      lastDate:
          DateTime(2100),
    );

    if (pickedDate == null) {
      return;
    }

    if (!mounted) return;

    final pickedTime =
        await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.now(),
    );

    if (pickedTime == null) {
      return;
    }

    final selectedDateTime =
        DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
      0,
    );

    expiredController.text =
        "${selectedDateTime.year}-${selectedDateTime.month.toString().padLeft(2, '0')}-${selectedDateTime.day.toString().padLeft(2, '0')} "
        "${selectedDateTime.hour.toString().padLeft(2, '0')}:${selectedDateTime.minute.toString().padLeft(2, '0')}:00";
  }

  Future<void> updateProduct() async {
    if (product == null) {
      return;
    }

    try {
      await context
          .read<
              MerchantProductProvider>()
          .updateProduct(
            id: product!.id,
            nama:
                namaController.text,
            deskripsi:
                deskripsiController
                    .text,
            kategori:
                kategoriController
                    .text,
            hargaOriginal:
                hargaOriginalController
                    .text,
            hargaDiskon:
                hargaDiskonController
                    .text,
            stok:
                stokController.text,
            expired:
                expiredController.text,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Produk berhasil diperbarui',
          ),
        ),
      );

      Navigator.pop(
        context,
        true,
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    bool numberOnly = false,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        keyboardType:
            numberOnly
                ? TextInputType.number
                : TextInputType.text,
        inputFormatters:
            numberOnly
                ? [
                    FilteringTextInputFormatter
                        .digitsOnly,
                  ]
                : null,
        decoration:
            InputDecoration(
          labelText: label,
          border:
              const OutlineInputBorder(),
          suffixIcon:
              label ==
                      'Tanggal Expired'
                  ? const Icon(
                      Icons
                          .calendar_month,
                    )
                  : null,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final provider =
        context.watch<
            MerchantProductProvider>();

    if (!loaded ||
        provider.isLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Produk',
        ),
      ),
      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          children: [
            buildField(
              'Nama Produk',
              namaController,
            ),

            buildField(
              'Deskripsi',
              deskripsiController,
              maxLines: 4,
            ),

            buildField(
              'Kategori',
              kategoriController,
            ),

            buildField(
              'Harga Asli',
              hargaOriginalController,
              numberOnly: true,
            ),

            buildField(
              'Harga Diskon',
              hargaDiskonController,
              numberOnly: true,
            ),

            buildField(
              'Stok',
              stokController,
              numberOnly: true,
            ),

            buildField(
              'Tanggal Expired',
              expiredController,
              readOnly: true,
              onTap: selectDate,
            ),

            const SizedBox(
              height: 24,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 52,
              child:
                  ElevatedButton.icon(
                icon: const Icon(
                  Icons.save,
                ),
                label: const Text(
                  'Update Produk',
                ),
                onPressed:
                    updateProduct,
              ),
            ),
          ],
        ),
      ),
    );
  }
}