import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/merchant_product_provider.dart';

import '../../../core/utils/currency_input_formatter.dart';


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
                hargaOriginalController.text
            .replaceAll('.', ''),

            hargaDiskon:
                hargaDiskonController.text
            .replaceAll('.', ''),
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
  bool isCurrency = false,
  bool readOnly = false,
  VoidCallback? onTap,
  int maxLines = 1,
}) {
  return Padding(
    padding:
        const EdgeInsets.only(
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
          ? isCurrency
              ? [
                  FilteringTextInputFormatter
                      .digitsOnly,
                  CurrencyInputFormatter(),
                ]
              : [
                  FilteringTextInputFormatter
                      .digitsOnly,
                ]
          : null,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor:
            Colors.grey.shade50,
        prefixText:
            isCurrency
                ? 'Rp '
                : null,
        border:
            OutlineInputBorder(
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
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            16,
          ),
          borderSide:
              const BorderSide(
            color: Colors.green,
            width: 2,
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
  return Scaffold(
    backgroundColor:
        const Color(0xFFF5F7FA),

    appBar: AppBar(
      elevation: 0,
      backgroundColor:
          Colors.green,
      foregroundColor:
          Colors.white,
      centerTitle: true,
      title: const Text(
        'Tambah Produk',
        style: TextStyle(
          fontWeight:
              FontWeight.bold,
        ),
      ),
    ),

    body: SingleChildScrollView(
      padding:
          const EdgeInsets.all(
        20,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(
              20,
            ),
            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                24,
              ),
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
                  CrossAxisAlignment
                      .start,
              children: [
                const Text(
                  "Informasi Produk",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight
                            .bold,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 200,
                    width:
                        double.infinity,
                    decoration:
                        BoxDecoration(
                      color: Colors
                          .grey
                          .shade100,
                      borderRadius:
                          BorderRadius
                              .circular(
                        18,
                      ),
                      border:
                          Border.all(
                        color: Colors
                            .grey
                            .shade300,
                      ),
                    ),
                    child:
                        selectedImage ==
                                null
                            ? Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .image_outlined,
                                    size:
                                        60,
                                    color: Colors
                                        .grey
                                        .shade600,
                                  ),
                                  const SizedBox(
                                    height:
                                        12,
                                  ),
                                  const Text(
                                    'Pilih Foto Produk',
                                    style:
                                        TextStyle(
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                                child:
                                    Image.file(
                                  selectedImage!,
                                  fit:
                                      BoxFit.cover,
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
                  isCurrency: true,
                ),

                buildField(
                  'Harga Diskon',
                  hargaDiskonController,
                  numberOnly: true,
                  isCurrency: true,
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
              ],
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          SizedBox(
            width:
                double.infinity,
            height: 58,
            child:
                ElevatedButton.icon(
              icon: const Icon(
                Icons.save,
              ),
              label: const Text(
                'Simpan Produk',
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
                  saveProduct,
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