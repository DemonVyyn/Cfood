import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/merchant_product_provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({
    super.key,
  });

  @override
  State<AddProductPage> createState() =>
      _AddProductPageState();
}

class _AddProductPageState
    extends State<AddProductPage> {
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

  File? selectedImage;

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

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final image =
        await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      setState(() {
        selectedImage =
            File(image.path);
      });
    }
  }

  Future<void>
      pickExpiredDate() async {
    final date =
        await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(
        DateTime.now().year + 5,
      ),
    );

    if (date != null) {
      expiredController.text =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} 23:59:59";
    }
  }

  Future<void> saveProduct() async {
    if (namaController.text
            .trim()
            .isEmpty ||
        hargaOriginalController
            .text
            .trim()
            .isEmpty ||
        hargaDiskonController
            .text
            .trim()
            .isEmpty ||
        stokController.text
            .trim()
            .isEmpty ||
        expiredController
            .text
            .trim()
            .isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Lengkapi data produk',
          ),
        ),
      );

      return;
    }

    try {
      await context
          .read<
              MerchantProductProvider>()
          .createProduct(
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
                expiredController
                    .text,
            image:
                selectedImage,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text(
            'Produk berhasil ditambahkan',
          ),
        ),
      );

      Navigator.pop(
        context,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Produk',
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
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 180,
                width:
                    double.infinity,
                decoration:
                    BoxDecoration(
                  border: Border.all(
                    color:
                        Colors.grey,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child:
                    selectedImage ==
                            null
                        ? const Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons
                                    .image,
                                size:
                                    50,
                              ),
                              SizedBox(
                                height:
                                    8,
                              ),
                              Text(
                                'Pilih Foto Produk',
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                            child:
                                Image.file(
                              selectedImage!,
                              fit: BoxFit
                                  .cover,
                            ),
                          ),
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
              onTap:
                  pickExpiredDate,
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width:
                  double.infinity,
              height: 50,
              child:
                  ElevatedButton(
                onPressed:
                    saveProduct,
                child:
                    const Text(
                  'Simpan Produk',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}