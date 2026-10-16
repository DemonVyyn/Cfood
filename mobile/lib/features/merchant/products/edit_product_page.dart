import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/merchant_product_model.dart';
import '../../../providers/merchant_product_provider.dart';

import '../../../core/utils/currency_input_formatter.dart';
import 'package:intl/intl.dart';

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

   final rupiah = NumberFormat(
  '#,###',
  'id_ID',
);

hargaOriginalController.text =
    rupiah
        .format(
          result.originalPrice.toInt(),
        )
        .replaceAll(
          ',',
          '.',
        );

hargaDiskonController.text =
    rupiah
        .format(
          result.discountPrice.toInt(),
        )
        .replaceAll(
          ',',
          '.',
        );

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
    hargaOriginalController.text
        .replaceAll('.', ''),

hargaDiskon:
    hargaDiskonController.text
        .replaceAll('.', ''),
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
    padding: const EdgeInsets.only(
      bottom: 14,
    ),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      maxLines: maxLines,
      keyboardType: numberOnly
          ? TextInputType.number
          : TextInputType.text,
      inputFormatters: numberOnly
          ? [
              FilteringTextInputFormatter
                  .digitsOnly,
              CurrencyInputFormatter(),
            ]
          : null,
      decoration: InputDecoration(
        labelText: label,

prefixText:
    label.contains('Harga')
        ? 'Rp '
        : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          borderSide: BorderSide(
            color:
                Colors.grey.shade300,
          ),
        ),
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
  backgroundColor: const Color(0xFFF5F7FA),

  appBar: AppBar(
    elevation: 0,
    backgroundColor: Colors.green,
    foregroundColor: Colors.white,
    centerTitle: true,
    title: const Text(
      'Edit Produk',
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  body: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(24),
            boxShadow: [
  BoxShadow(
    color: Colors.black.withValues(
      alpha: 0.05,
    ),
    blurRadius: 20,
    offset: const Offset(
      0,
      6,
    ),
  ),
],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "Informasi Produk",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 20,
              ),

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
            ],
          ),
        ),

        const SizedBox(
          height: 24,
        ),

        SizedBox(
          width: double.infinity,
          height: 58,
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.save,
            ),
            label: const Text(
              'Update Produk',
              style: TextStyle(
                fontSize: 16,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.green,
              foregroundColor:
                  Colors.white,
              elevation: 0,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
            ),
            onPressed:
                updateProduct,
          ),
        ),

        const SizedBox(
          height: 20,
        ),
      ],
    ),
  ),
    );
  }
}