import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../models/food_model.dart';
import '../checkout/checkout_page.dart';

class FoodDetailPage extends StatefulWidget {
  final FoodModel food;

  const FoodDetailPage({
    super.key,
    required this.food,
  });

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  int _qty = 1;
  bool _isBookmarked = false;

  FoodModel get _food => widget.food;

  bool get _canOrder => !_food.isExpired && _food.stok > 0;

  int get _maxQty => _food.stok > 0 ? _food.stok : 1;

  int get _subtotal => _food.hargaDiskon.round() * _qty;

  String _formatPrice(num price) {
    final value = price.round().toString();

    return 'Rp ${value.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]}.',
    )}';
  }

  void _decrement() {
    if (_qty > 1) {
      setState(() => _qty--);
    }
  }

  void _increment() {
    if (_qty < _maxQty && _canOrder) {
      setState(() => _qty++);
    }
  }

  void _goToCheckout() {
    if (_food.isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maaf, makanan ini sudah kedaluwarsa.'),
        ),
      );
      return;
    }

    if (_food.stok <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maaf, stok makanan sudah habis.'),
        ),
      );
      return;
    }

    if (_qty > _food.stok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jumlah pesanan melebihi stok yang tersedia.'),
        ),
      );
      setState(() => _qty = _food.stok);
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CheckoutPage(
          food: _food,
          quantity: _qty,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroImage(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMerchantCard(),
                      const SizedBox(height: 16),
                      _buildProductIdentity(),
                      const SizedBox(height: 16),
                      _buildPickupDetails(),
                      const SizedBox(height: 16),
                      _buildDescriptionCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 170),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleHeaderButton(
                      icon: Icons.arrow_back,
                      iconColor: AppColors.primary,
                      onTap: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        _circleHeaderButton(
                          icon: Icons.share,
                          iconColor: AppColors.onSurfaceVariant,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Fitur berbagi belum tersedia.',
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        _circleHeaderButton(
                          icon: _isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          iconColor: _isBookmarked
                              ? AppColors.primary
                              : AppColors.onSurfaceVariant,
                          onTap: () {
                            setState(() {
                              _isBookmarked = !_isBookmarked;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomBar(),
          ),
        ],
      ),
    );
  }

  // HERO IMAGE

  Widget _buildHeroImage() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: _food.foto.isNotEmpty
              ? Image.network(
                  _food.foto,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, error, stackTrace) {
                    return _imagePlaceholder();
                  },
                )
              : _imagePlaceholder(),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.surface,
                    AppColors.surface.withValues(alpha: 0.0),
                    AppColors.surface.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _heroBadge(
                icon: _food.isExpired
                    ? Icons.block
                    : Icons.inventory_2_outlined,
                label: _food.isExpired
                    ? 'Kedaluwarsa'
                    : _food.stok > 0
                        ? 'Tersisa ${_food.stok} porsi'
                        : 'Stok habis',
                background: _food.isExpired
                    ? AppColors.error
                    : _food.stok > 0
                        ? AppColors.primary
                        : Colors.grey,
                foreground: Colors.white,
              ),
              if (_food.persenDiskon > 0)
                _heroBadge(
                  icon: Icons.eco,
                  label: 'Hemat ${_food.persenDiskon}%',
                  background: AppColors.primaryContainer,
                  foreground: AppColors.surface,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.surfaceContainerHigh,
      alignment: Alignment.center,
      child: const Icon(
        Icons.fastfood,
        size: 48,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _heroBadge({
    required IconData icon,
    required String label,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleHeaderButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withValues(
            alpha: 0.9,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: iconColor),
      ),
    );
  }

  // MERCHANT

  Widget _buildMerchantCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer.withValues(
                alpha: 0.4,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront,
              size: 28,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _food.namaToko.isNotEmpty
                      ? _food.namaToko
                      : 'Mitra CheaFood',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mitra makanan CheaFood',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.verified,
            size: 20,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // PRODUCT IDENTITY

  Widget _buildProductIdentity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _food.nama,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            height: 1.3,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Kategori: ${_food.kategori}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              _formatPrice(_food.hargaDiskon),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryContainer,
              ),
            ),
            if (_food.hargaOriginal > _food.hargaDiskon)
              Text(
                _formatPrice(_food.hargaOriginal),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.outline,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            if (_food.persenDiskon > 0)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Hemat ${_food.persenDiskon}%',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSecondaryContainer,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStockBar(),
      ],
    );
  }

  Widget _buildStockBar() {
    final isAvailable = _canOrder;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isAvailable
                ? Icons.inventory_2_outlined
                : Icons.remove_shopping_cart,
            size: 20,
            color: isAvailable ? AppColors.primary : AppColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _food.isExpired
                  ? 'Makanan sudah kedaluwarsa'
                  : _food.stok > 0
                      ? 'Stok tersedia: ${_food.stok} porsi'
                      : 'Stok makanan habis',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isAvailable
                    ? AppColors.onSurface
                    : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // PICKUP DETAILS

  Widget _buildPickupDetails() {
    return _detailCard(
      icon: Icons.storefront,
      title: 'Detail Pengambilan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(
            icon: Icons.location_on,
            label: 'Lokasi Pengambilan',
            value: _food.namaToko.isNotEmpty
                ? 'Silakan konfirmasi alamat kepada ${_food.namaToko}.'
                : 'Informasi alamat mitra belum tersedia.',
            iconColor: AppColors.primary,
          ),
          const SizedBox(height: 16),
          _infoRow(
            icon: Icons.inventory_2_outlined,
            label: 'Ketersediaan',
            value: _food.isExpired
                ? 'Makanan sudah kedaluwarsa dan tidak dapat dipesan.'
                : _food.stok > 0
                    ? 'Tersedia ${_food.stok} porsi.'
                    : 'Stok saat ini habis.',
            iconColor: AppColors.secondary,
          ),
          const SizedBox(height: 16),
          _infoRow(
            icon: Icons.qr_code_scanner,
            label: 'Petunjuk Klaim Makanan',
            value:
                'Setelah pesanan dikonfirmasi, ikuti petunjuk pengambilan yang tersedia pada detail pesanan.',
            iconColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  // DESCRIPTION

  Widget _buildDescriptionCard() {
    return _detailCard(
      icon: Icons.restaurant,
      title: 'Deskripsi Makanan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _food.deskripsi.isNotEmpty
                ? _food.deskripsi
                : 'Belum ada deskripsi untuk makanan ini.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 1.5,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primaryFixedDim.withValues(
                  alpha: 0.3,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.energy_savings_leaf,
                  size: 22,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Dengan membeli makanan berlebih, kamu membantu mengurangi makanan yang terbuang dan mendukung gerakan pengurangan food waste.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      height: 1.5,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // SHARED CARD

  Widget _detailCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.surfaceContainer,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: AppColors.primaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                 
  ),             ),
            ],
          ),
        ),
      ],
    );
  }

  // BOTTOM BAR

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(
          alpha: 0.98,
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subtotal Tagihan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatPrice(_subtotal),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStepper(),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _canOrder ? _goToCheckout : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ctaGreen,
                  foregroundColor: AppColors.onPrimary,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: Icon(
                  _food.isExpired ? Icons.block : Icons.bolt,
                  size: 20,
                ),
                label: Text(
                  _food.isExpired
                      ? 'Makanan Kedaluwarsa'
                      : _food.stok > 0
                          ? 'Pesan Sekarang'
                          : 'Stok Habis',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          _stepperButton(
            icon: Icons.remove,
            enabled: _qty > 1,
            onTap: _decrement,
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$_qty',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          _stepperButton(
            icon: Icons.add,
            enabled: _qty < _maxQty && _canOrder,
            onTap: _increment,
            isAdd: true,
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    bool isAdd = false,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isAdd
                ? AppColors.ctaGreen
                : AppColors.surfaceContainerLowest,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: isAdd ? AppColors.surface : AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}
