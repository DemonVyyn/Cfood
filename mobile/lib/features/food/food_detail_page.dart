import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/dummy_foods.dart';
import '../checkout/checkout_page.dart';

class FoodDetailPage extends StatefulWidget {
  final DummyFood food;

  const FoodDetailPage({
    super.key,
    required this.food,
  });

  @override
  State<FoodDetailPage> createState() =>
      _FoodDetailPageState();
}

class _FoodDetailPageState
    extends State<FoodDetailPage> {
  int _qty = 1;
  bool _isBookmarked = false;

  DummyFood get _food => widget.food;

  int get _maxQty =>
      _food.boxesLeft > 0 ? _food.boxesLeft : 1;

  int get _subtotal =>
      _food.discountPrice * _qty;

  String _formatPrice(int price) =>
      'Rp ${price.toString().replaceAllMapped(
            RegExp(r'(\d)(?=(\d{3})+$)'),
            (m) => '${m[1]}.',
          )}';

  void _decrement() {
    if (_qty > 1) {
      setState(() => _qty--);
    }
  }

  void _increment() {
    if (_qty < _maxQty) {
      setState(() => _qty++);
    }
  }

  void _goToCheckout() {
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
          // Scrollable content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildHeroImage(),

                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
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

                // Ruang untuk sticky bottom bar
                const SizedBox(height: 160),
              ],
            ),
          ),

          // Floating header (di atas hero image)
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
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    _circleHeaderButton(
                      icon: Icons.arrow_back,
                      iconColor: AppColors.primary,
                      onTap: () =>
                          Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        _circleHeaderButton(
                          icon: Icons.share,
                          iconColor:
                              AppColors.onSurfaceVariant,
                          onTap: () {
                            // TODO: bagikan produk
                          },
                        ),
                        const SizedBox(width: 8),
                        _circleHeaderButton(
                          icon: _isBookmarked
                              ? Icons.bookmark
                              : Icons
                                  .bookmark_border,
                          iconColor: _isBookmarked
                              ? AppColors
                                  .primaryContainer
                              : AppColors
                                  .onSurfaceVariant,
                          onTap: () => setState(
                            () => _isBookmarked =
                                !_isBookmarked,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sticky bottom purchase bar
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

  // ---------- HERO ----------

  Widget _buildHeroImage() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Image.network(
            _food.image,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              color: AppColors.surfaceContainerHigh,
              child: const Icon(
                Icons.fastfood,
                size: 48,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),

        // Vignette gradasi ke warna surface
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.surface,
                    AppColors.surface
                        .withValues(alpha: 0.0),
                    AppColors.surface
                        .withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),
          ),
        ),

        // Badges overlay
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    _heroBadge(
                      icon: Icons.timer,
                      label:
                          'Tersisa ${_food.boxesLeft} Box',
                      background: AppColors.error,
                      foreground:
                          AppColors.onError,
                    ),
                    _heroBadge(
                      icon: Icons.eco,
                      label:
                          'Hemat ${_food.discountPercent}%',
                      background:
                          AppColors.primaryContainer,
                      foreground: AppColors.surface,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(child: _buildCo2Chip()),
            ],
          ),
        ),
      ],
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
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius:
            BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: foreground),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                height: 14 / 10,
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCo2Chip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest
            .withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.compost,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '1.4 kg CO₂e Saved',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                height: 14 / 10,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
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
          color: AppColors.surfaceContainerLowest
              .withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: 0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(icon, size: 22, color: iconColor),
      ),
    );
  }

  // ---------- MERCHANT ----------

  Widget _buildMerchantCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer
                .withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar toko
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondaryContainer
                  .withValues(alpha: 0.4),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primaryFixedDim
                    .withValues(alpha: 0.4),
              ),
            ),
            child: const Icon(
              Icons.bakery_dining,
              size: 28,
              color: AppColors.primaryContainer,
            ),
          ),

          const SizedBox(width: 8),

          // Nama & meta
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _food.store,
                        maxLines: 1,
                        overflow:
                            TextOverflow.ellipsis,
                        style: GoogleFonts
                            .plusJakartaSans(
                          fontSize: 18,
                          height: 24 / 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 18,
                      color:
                          AppColors.primaryContainer,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Wrap(
                  crossAxisAlignment:
                      WrapCrossAlignment.center,
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 15,
                      color: Color(0xFFF59E0B),
                    ),
                    Text(
                      _food.rating.toString(),
                      style: GoogleFonts
                          .plusJakartaSans(
                        fontSize: 12,
                        height: 16 / 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    _metaDot(),
                    Text(
                      '(420+ ulasan)',
                      style: GoogleFonts
                          .plusJakartaSans(
                        fontSize: 12,
                        height: 16 / 12,
                        color:
                            AppColors.onSurfaceVariant,
                      ),
                    ),
                    _metaDot(),
                    const Icon(
                      Icons.near_me,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    Text(
                      _food.distance,
                      style: GoogleFonts
                          .plusJakartaSans(
                        fontSize: 12,
                        height: 16 / 12,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Tombol profil mitra
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.surfaceContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaDot() {
    return Text(
      '•',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        height: 16 / 12,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }

  // ---------- PRODUCT IDENTITY ----------

  Widget _buildProductIdentity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul produk
        Text(
          _food.name,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            height: 34 / 26,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),

        const SizedBox(height: 4),

        // Kategori
        Text(
          'Kategori: ${_food.category}',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            height: 16 / 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 8),

        // Baris harga (Wrap agar turun baris di layar sempit)
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            Text(
              _formatPrice(_food.discountPrice),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 32,
                height: 40 / 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                color: AppColors.primaryContainer,
              ),
            ),
            Text(
              _formatPrice(_food.originalPrice),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                height: 20 / 14,
                color: AppColors.outline,
                decoration: TextDecoration.lineThrough,
                decorationColor: AppColors.outline,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Hemat ${_food.discountPercent}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  height: 14 / 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSecondaryContainer,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Stock scarcity bar
        _buildStockBar(),
      ],
    );
  }

  Widget _buildStockBar() {
    final total = _food.totalStock > 0
        ? _food.totalStock
        : _food.sold + _food.boxesLeft;
    final progress = total > 0
        ? (_food.sold / total).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.30),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Sisa ${_food.boxesLeft} porsi lagi!',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts
                            .plusJakartaSans(
                          fontSize: 12,
                          height: 16 / 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Terjual ${_food.sold}/$total',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 16 / 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Progress track
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors
                      .surfaceContainerHighest,
                  borderRadius:
                      BorderRadius.circular(999),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.secondary,
                        AppColors.error,
                      ],
                    ),
                    borderRadius:
                        BorderRadius.circular(999),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- PICKUP DETAILS ----------

  Widget _buildPickupDetails() {
    return _detailCard(
      icon: Icons.storefront,
      title: 'Detail Pengambilan',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(
            icon: Icons.location_on,
            iconBackground: AppColors.primaryFixed
                .withValues(alpha: 0.5),
            iconColor: AppColors.primary,
            label: 'Lokasi Pengambilan',
            value:
                'Jl. Kemang Raya No. 14, Jakarta Selatan',
            note:
                'Samping Galeri Seni Kemang, parkir motor & mobil tersedia.',
          ),

          const SizedBox(height: 12),

          _infoRow(
            icon: Icons.schedule,
            iconBackground: AppColors
                .secondaryContainer
                .withValues(alpha: 0.5),
            iconColor: AppColors.secondary,
            label: 'Jadwal Pickup Mandiri',
            value:
                'Hari ini, ${_food.pickupTime} WIB',
            valueColor: AppColors.primaryContainer,
            note:
                'Ambil sebelum toko tutup pada pukul 21:30 WIB',
          ),

          const SizedBox(height: 12),

          _infoRow(
            icon: Icons.qr_code_scanner,
            iconBackground:
                AppColors.surfaceContainer,
            iconColor: AppColors.onSurface,
            label: 'Petunjuk Klaim Makanan',
            value:
                'Tunjukkan QR Code pesanan aktif pada staf kasir saat tiba di outlet. Makanan sudah dikemas siap bawa.',
            highlighted: true,
          ),
        ],
      ),
    );
  }

  // ---------- DESCRIPTION ----------

  Widget _buildDescriptionCard() {
    return _detailCard(
      icon: Icons.restaurant,
      title: 'Deskripsi Makanan & Dampak',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paket kejutan berisi aneka croissant butter, pain au chocolat, dan artisanal sourdough segar hari ini yang belum terjual. Kualitas prima dan higienis terjamin.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              height: 20 / 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 12),

          // Komitmen zero waste
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primaryFixedDim
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.energy_savings_leaf,
                  size: 22,
                  color: AppColors.primaryContainer,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: GoogleFonts
                          .plusJakartaSans(
                        fontSize: 12,
                        height: 16 / 12,
                        color: AppColors.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text:
                              'Komitmen Zero Waste:',
                          style: GoogleFonts
                              .plusJakartaSans(
                            fontWeight:
                                FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' Dengan menyelamatkan paket ini, kamu telah mencegah 1.4 kg jejak karbon emisi metana dari tempat pembuangan akhir.',
                        ),
                      ],
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

  // ---------- SHARED CARD ----------

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
          color: AppColors.outlineVariant
              .withValues(alpha: 0.30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryContainer
                .withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan garis bawah
          Container(
            padding:
                const EdgeInsets.only(bottom: 8),
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
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts
                        .plusJakartaSans(
                      fontSize: 18,
                      height: 24 / 18,
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
    required Color iconBackground,
    required Color iconColor,
    required String label,
    required String value,
    String? note,
    Color valueColor = AppColors.onSurface,
    bool highlighted = false,
  }) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
              ),
              if (note != null) ...[
                const SizedBox(height: 2),
                Text(
                  note,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 16 / 12,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );

    if (highlighted) {
      return Container(
        // Padding kiri = 0 agar ikon & teks sejajar dengan baris
        // Lokasi & Jadwal di atasnya (box hover pun background
        // penuh sampai tepi konten kartu).
        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: row,
      );
    }
    return row;
  }

  // ---------- BOTTOM BAR ----------

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest
            .withValues(alpha: 0.98),
        border: Border(
          top: BorderSide(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            // Subtotal + stepper
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subtotal Tagihan',
                        maxLines: 1,
                        style: GoogleFonts
                            .plusJakartaSans(
                          fontSize: 10,
                          height: 14 / 10,
                          color: AppColors
                              .onSurfaceVariant,
                        ),
                      ),
                      Text(
                        _formatPrice(_subtotal),
                        maxLines: 1,
                        style: GoogleFonts
                            .plusJakartaSans(
                          fontSize: 18,
                          height: 24 / 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors
                              .primaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStepper(),
              ],
            ),

            const SizedBox(height: 8),

            // Tombol keranjang + checkout
            Row(
              children: [
                _buildCartButton(),

                const SizedBox(width: 8),

                Expanded(
                  child: _buildCheckoutButton(),
                ),
              ],
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
          color: AppColors.outlineVariant
              .withValues(alpha: 0.30),
        ),
      ),
      child: Row(
        children: [
          _stepperButton(
            icon: Icons.remove,
            background:
                AppColors.surfaceContainerLowest,
            foreground: AppColors.onSurface,
            enabled: _qty > 1,
            onTap: _decrement,
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$_qty',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                height: 24 / 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ),
          _stepperButton(
            icon: Icons.add,
            background: AppColors.ctaGreen,
            foreground: AppColors.surface,
            enabled: _qty < _maxQty,
            onTap: _increment,
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required Color background,
    required Color foreground,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18,
            color: foreground,
          ),
        ),
      ),
    );
  }

  Widget _buildCartButton() {
    return GestureDetector(
      onTap: () {
        // TODO: tambah ke keranjang
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.4),
          ),
        ),
        child: const Icon(
          Icons.add_shopping_cart,
          size: 22,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return GestureDetector(
      onTap: _goToCheckout,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.ctaGreen,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryContainer
                  .withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.bolt,
              size: 20,
              color: AppColors.onPrimary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Pesan Sekarang (3-Tap)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
