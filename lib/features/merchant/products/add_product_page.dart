import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../providers/merchant_product_provider.dart';
import '../../../core/utils/currency_input_formatter.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  static const Color primaryGreen = Color(0xFF14DE32);
  static const Color darkGreen = Color(0xFF0CB52A);
  static const Color backgroundColor = Color(0xFFF7F9F7);
  static const Color textColor = Color(0xFF263126);

  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final kategoriController = TextEditingController();
  final hargaOriginalController = TextEditingController();
  final hargaDiskonController = TextEditingController();
  final stokController = TextEditingController();
  final expiredController = TextEditingController();

  File? selectedImage;
  bool isSaving = false;

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
    try {
      final picker = ImagePicker();

      final image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (!mounted || image == null) return;

      setState(() {
        selectedImage = File(image.path);
      });
    } catch (e) {
      if (!mounted) return;
      _showMessage('Gagal memilih foto: $e', isError: true);
    }
  }

  Future<void> pickExpiredDate() async {
    final now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 5),
      helpText: 'Pilih Tanggal Kedaluwarsa',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: textColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted || date == null) return;

    expiredController.text =
        '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')} 23:59:59';

    setState(() {});
  }

  int _parseCurrency(String value) {
    return int.tryParse(value.replaceAll('.', '').trim()) ?? 0;
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? Colors.red.shade700 : darkGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  Future<void> saveProduct() async {
    if (isSaving) return;

    if (namaController.text.trim().isEmpty ||
        hargaOriginalController.text.trim().isEmpty ||
        hargaDiskonController.text.trim().isEmpty ||
        stokController.text.trim().isEmpty ||
        expiredController.text.trim().isEmpty) {
      _showMessage('Lengkapi data produk terlebih dahulu.', isError: true);
      return;
    }

    final hargaOriginal = _parseCurrency(hargaOriginalController.text);
    final hargaDiskon = _parseCurrency(hargaDiskonController.text);
    final stok = int.tryParse(stokController.text.trim());

    if (hargaOriginal <= 0 || hargaDiskon <= 0) {
      _showMessage('Harga produk harus lebih dari Rp 0.', isError: true);
      return;
    }

    if (hargaDiskon >= hargaOriginal) {
      _showMessage(
        'Harga diskon harus lebih rendah dari harga asli.',
        isError: true,
      );
      return;
    }

    if (stok == null || stok < 0) {
      _showMessage('Stok produk tidak valid.', isError: true);
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await context.read<MerchantProductProvider>().createProduct(
            nama: namaController.text.trim(),
            deskripsi: deskripsiController.text.trim(),
            kategori: kategoriController.text.trim(),
            hargaOriginal: hargaOriginal.toString(),
            hargaDiskon: hargaDiskon.toString(),
            stok: stok.toString(),
            expired: expiredController.text.trim(),
            image: selectedImage,
          );

      if (!mounted) return;

      _showMessage('Produk berhasil ditambahkan.');

      // Mengirim hasil true agar halaman sebelumnya dapat memperbarui daftar.
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showMessage('Gagal menambahkan produk: $e', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool numberOnly = false,
    bool isCurrency = false,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    String? hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        maxLines: maxLines,
        keyboardType: numberOnly
            ? TextInputType.number
            : maxLines > 1
                ? TextInputType.multiline
                : TextInputType.text,
        inputFormatters: numberOnly
            ? isCurrency
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ]
                : [FilteringTextInputFormatter.digitsOnly]
            : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          prefixText: isCurrency ? 'Rp ' : null,
          suffixIcon: readOnly
              ? const Icon(
                  Icons.calendar_month_outlined,
                  color: darkGreen,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E8E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE1E8E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: darkGreen,
              width: 1.6,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: primaryGreen.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, color: darkGreen, size: 21),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: textColor,
        centerTitle: false,
        title: const Text(
          'Tambah Produk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: const Color(0xFFE8EDE8),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header mengikuti tema ProductListPage.
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryGreen, darkGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: primaryGreen.withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tambah Produk Baru',
                            style: TextStyle(
                              fontSize: 21,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            'Lengkapi informasi produk agar pelanggan '
                            'dapat menemukan penawaran tokomu.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.add_box_outlined,
                      size: 48,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Informasi produk.
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE8EDE8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.035),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(
                      'Informasi Produk',
                      Icons.inventory_2_outlined,
                    ),
                    const SizedBox(height: 20),

                    // Pemilihan foto.
                    const Text(
                      'Foto Produk',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: pickImage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        height: 190,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F9F7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selectedImage == null
                                ? const Color(0xFFCAD9CA)
                                : primaryGreen,
                            width: selectedImage == null ? 1 : 1.5,
                          ),
                        ),
                        child: selectedImage == null
                            ? const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_photo_alternate_outlined,
                                    size: 48,
                                    color: darkGreen,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Pilih Foto Produk',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Ketuk untuk memilih dari galeri',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF758075),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        Icons.edit_outlined,
                                        color: Colors.white,
                                        size: 19,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 22),
                    _buildField(
                      'Nama Produk',
                      namaController,
                      hintText: 'Contoh: Roti Cokelat',
                    ),
                    _buildField(
                      'Deskripsi',
                      deskripsiController,
                      maxLines: 4,
                      hintText: 'Jelaskan kondisi dan isi produk',
                    ),
                    _buildField(
                      'Kategori',
                      kategoriController,
                      hintText: 'Contoh: Roti, Makanan, Minuman',
                    ),

                    const SizedBox(height: 4),
                    _buildSectionTitle(
                      'Harga dan Stok',
                      Icons.sell_outlined,
                    ),
                    const SizedBox(height: 18),
                    _buildField(
                      'Harga Asli',
                      hargaOriginalController,
                      numberOnly: true,
                      isCurrency: true,
                      hintText: '0',
                    ),
                    _buildField(
                      'Harga Diskon',
                      hargaDiskonController,
                      numberOnly: true,
                      isCurrency: true,
                      hintText: '0',
                    ),
                    _buildField(
                      'Stok',
                      stokController,
                      numberOnly: true,
                      hintText: 'Jumlah produk tersedia',
                    ),

                    const SizedBox(height: 4),
                    _buildSectionTitle(
                      'Masa Berlaku',
                      Icons.event_available_outlined,
                    ),
                    const SizedBox(height: 18),
                    _buildField(
                      'Tanggal Expired',
                      expiredController,
                      readOnly: true,
                      onTap: pickExpiredDate,
                      hintText: 'Pilih tanggal kedaluwarsa',
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF9F0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: darkGreen,
                            size: 19,
                          ),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Pilih tanggal kedaluwarsa yang sesuai '
                              'dengan kondisi produk.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF426447),
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: isSaving ? null : saveProduct,
                  icon: isSaving
                      ? const SizedBox(
                          width: 19,
                          height: 19,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    isSaving ? 'Menyimpan...' : 'Simpan Produk',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    disabledBackgroundColor: Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pastikan informasi produk sudah benar sebelum disimpan.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF758075),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
