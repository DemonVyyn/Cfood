import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/currency_input_formatter.dart';
import '../../../models/merchant_product_model.dart';
import '../../../providers/merchant_product_provider.dart';

class EditProductPage extends StatefulWidget {
  final int productId;

  const EditProductPage({
    super.key,
    required this.productId,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  static const Color primaryGreen = Color(0xFF168348);
  static const Color backgroundColor = Color(0xFFF5F8F6);
  static const Color textColor = Color(0xFF202B24);
  static const Color secondaryTextColor = Color(0xFF78847C);

  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final kategoriController = TextEditingController();
  final hargaOriginalController = TextEditingController();
  final hargaDiskonController = TextEditingController();
  final stokController = TextEditingController();
  final expiredController = TextEditingController();

  bool loaded = false;
  bool isSaving = false;
  String? loadError;

  MerchantProductModel? product;

  @override
  void initState() {
    super.initState();
    Future.microtask(loadProduct);
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

  String formatDateTime(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}:00';
  }

  Future<void> loadProduct() async {
    try {
      final provider = context.read<MerchantProductProvider>();
      final result = await provider.getProduct(widget.productId);

      if (!mounted) return;

      if (result == null) {
        setState(() {
          loaded = true;
          loadError = 'Data produk tidak ditemukan.';
        });
        return;
      }

      product = result;

      namaController.text = result.name;
      deskripsiController.text = result.description;
      kategoriController.text = result.kategori;

      final rupiah = NumberFormat('#,###', 'id_ID');

      hargaOriginalController.text = rupiah
          .format(result.originalPrice.toInt())
          .replaceAll(',', '.');

      hargaDiskonController.text = rupiah
          .format(result.discountPrice.toInt())
          .replaceAll(',', '.');

      stokController.text = result.stock.toString();

      try {
        final date = DateTime.parse(result.expiredAt);
        expiredController.text = formatDateTime(date);
      } catch (_) {
        expiredController.text = result.expiredAt;
      }

      setState(() {
        loaded = true;
        loadError = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loaded = true;
        loadError = 'Gagal memuat produk. Silakan coba kembali.';
      });
    }
  }

  Future<void> selectDate() async {
    final now = DateTime.now();

    DateTime initialDate = now;
    try {
      final current = DateTime.parse(expiredController.text);
      initialDate = current.isBefore(now) ? now : current;
    } catch (_) {
      // Gunakan tanggal sekarang jika tanggal produk tidak dapat dibaca.
    }

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2100),
      helpText: 'Pilih tanggal kedaluwarsa',
      cancelText: 'BATAL',
      confirmText: 'PILIH',
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

    if (pickedDate == null || !mounted) return;

    TimeOfDay initialTime = TimeOfDay.now();
    try {
      final current = DateTime.parse(expiredController.text);
      initialTime = TimeOfDay.fromDateTime(current);
    } catch (_) {
      // Gunakan waktu sekarang jika waktu lama tidak tersedia.
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: 'Pilih waktu kedaluwarsa',
      cancelText: 'BATAL',
      confirmText: 'PILIH',
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

    if (pickedTime == null || !mounted) return;

    final selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      expiredController.text = formatDateTime(selectedDateTime);
    });
  }

  String cleanNumber(String value) {
    return value.replaceAll('.', '').replaceAll(',', '').trim();
  }

  Future<void> updateProduct() async {
    if (product == null || isSaving) return;

    final nama = namaController.text.trim();
    final deskripsi = deskripsiController.text.trim();
    final kategori = kategoriController.text.trim();
    final hargaOriginal = cleanNumber(hargaOriginalController.text);
    final hargaDiskon = cleanNumber(hargaDiskonController.text);
    final stok = stokController.text.trim();
    final expired = expiredController.text.trim();

    if (nama.isEmpty ||
        deskripsi.isEmpty ||
        kategori.isEmpty ||
        hargaOriginal.isEmpty ||
        hargaDiskon.isEmpty ||
        stok.isEmpty ||
        expired.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua kolom wajib diisi.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final original = double.tryParse(hargaOriginal);
    final discount = double.tryParse(hargaDiskon);
    final stock = int.tryParse(stok);

    if (original == null || discount == null || stock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga dan stok harus berupa angka yang valid.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (original <= 0 || discount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga harus lebih besar dari nol.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (discount > original) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga diskon tidak boleh melebihi harga asli.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stok tidak boleh kurang dari nol.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await context.read<MerchantProductProvider>().updateProduct(
            id: product!.id,
            nama: nama,
            deskripsi: deskripsi,
            kategori: kategori,
            hargaOriginal: hargaOriginal,
            hargaDiskon: hargaDiskon,
            stok: stok,
            expired: expired,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil diperbarui.'),
          backgroundColor: primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui produk: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Widget buildField(
    String label,
    TextEditingController controller, {
    String? hint,
    String? helperText,
    bool numberOnly = false,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
    IconData? prefixIcon,
    String? prefixText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,
            maxLines: maxLines,
            keyboardType: numberOnly
                ? TextInputType.number
                : TextInputType.text,
            inputFormatters: numberOnly
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    CurrencyInputFormatter(),
                  ]
                : null,
            style: const TextStyle(
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              helperText: helperText,
              helperMaxLines: 2,
              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(
                      prefixIcon,
                      size: 19,
                      color: secondaryTextColor,
                    ),
              prefixText: prefixText,
              suffixIcon: readOnly
                  ? const Icon(
                      Icons.calendar_month_outlined,
                      color: primaryGreen,
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF8FAF8),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFE3EAE5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFFE3EAE5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: primaryGreen,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionHeader(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryGreen.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: primaryGreen, size: 23),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: secondaryTextColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFormCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEAF0EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionHeader(title, subtitle, icon),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MerchantProductProvider>();

    if (!loaded || (provider.isLoading && product == null)) {
      return const Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: primaryGreen),
        ),
      );
    }

    if (loadError != null || product == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'Edit Produk',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 56,
                  color: secondaryTextColor,
                ),
                const SizedBox(height: 14),
                Text(
                  loadError ?? 'Data produk tidak tersedia.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      loaded = false;
                      loadError = null;
                    });
                    loadProduct();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 4,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Produk',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Perbarui informasi produk surplus',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.normal,
                color: Color(0xFFE3F4E8),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F6ED),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFD5EBDD),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.eco_outlined,
                      color: primaryGreen,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kelola produk surplus',
                            style: TextStyle(
                              color: primaryGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Pastikan harga, stok, dan waktu kedaluwarsa selalu sesuai dengan kondisi produk.',
                            style: TextStyle(
                              color: Color(0xFF52705C),
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              buildFormCard(
                title: 'Informasi Produk',
                subtitle: 'Perbarui nama dan deskripsi makanan.',
                icon: Icons.restaurant_menu_outlined,
                children: [
                  buildField(
                    'Nama Produk',
                    namaController,
                    hint: 'Contoh: Roti tawar isi',
                    prefixIcon: Icons.fastfood_outlined,
                  ),
                  buildField(
                    'Deskripsi',
                    deskripsiController,
                    hint: 'Jelaskan kondisi dan isi produk',
                    maxLines: 4,
                    prefixIcon: Icons.notes_outlined,
                  ),
                  buildField(
                    'Kategori',
                    kategoriController,
                    hint: 'Contoh: Roti, makanan berat',
                    prefixIcon: Icons.category_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              buildFormCard(
                title: 'Harga dan Stok',
                subtitle: 'Atur harga promo dan jumlah produk tersedia.',
                icon: Icons.sell_outlined,
                children: [
                  buildField(
                    'Harga Asli',
                    hargaOriginalController,
                    hint: 'Masukkan harga normal',
                    numberOnly: true,
                    prefixText: 'Rp ',
                    prefixIcon: Icons.payments_outlined,
                  ),
                  buildField(
                    'Harga Diskon',
                    hargaDiskonController,
                    hint: 'Masukkan harga setelah diskon',
                    numberOnly: true,
                    prefixText: 'Rp ',
                    prefixIcon: Icons.local_offer_outlined,
                    helperText: 'Harga diskon tidak boleh melebihi harga asli.',
                  ),
                  buildField(
                    'Stok',
                    stokController,
                    hint: 'Jumlah produk tersedia',
                    numberOnly: true,
                    prefixIcon: Icons.inventory_2_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              buildFormCard(
                title: 'Masa Berlaku Produk',
                subtitle: 'Tentukan batas waktu produk dapat dijual.',
                icon: Icons.schedule_outlined,
                children: [
                  buildField(
                    'Tanggal dan Waktu Kedaluwarsa',
                    expiredController,
                    hint: 'Pilih tanggal dan waktu',
                    readOnly: true,
                    onTap: selectDate,
                    prefixIcon: Icons.event_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: isSaving ? null : updateProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    disabledBackgroundColor: primaryGreen.withValues(alpha: 0.5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save_outlined, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Simpan Perubahan',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: isSaving ? null : () => Navigator.pop(context),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
