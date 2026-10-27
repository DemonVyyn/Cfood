import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/merchant_product_model.dart';
import '../../../../providers/merchant_product_provider.dart';
import '../../../../core/constants/app_constants.dart';

const Color _primaryGreen = Color(0xFF168348);
const Color _textColor = Color(0xFF17251D);
const Color _expiredRed = Color(0xFFD92D20);

class ProductCard extends StatelessWidget {
  final MerchantProductModel product;

  const ProductCard({
    super.key,
    required this.product,
  });

  String get _formattedPrice {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(product.discountPrice);
  }

  String get _formattedOriginalPrice {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(product.originalPrice);
  }

  int get _discountPercent {
    if (product.originalPrice <= 0 ||
        product.discountPrice >= product.originalPrice) {
      return 0;
    }

    return ((product.originalPrice - product.discountPrice) /
            product.originalPrice *
            100)
        .round();
  }

  bool get _isExpired {
    try {
      final expiredDate = DateTime.parse(product.expiredAt);
      return DateTime.now().isAfter(expiredDate);
    } catch (_) {
      return false;
    }
  }

  String get _expiredLabel {
    try {
      final date = DateTime.parse(product.expiredAt);
      return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
    } catch (_) {
      return product.expiredFormatted;
    }
  }

  String get _stockLabel {
    if (product.stock <= 0) {
      return 'Stok habis';
    }

    return 'Stok: ${product.stock}';
  }

  @override
  Widget build(BuildContext context) {
    final isSoldOut = product.stock <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE7EDE8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(isSoldOut),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCategoryAndStock(isSoldOut),
                const SizedBox(height: 10),

                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),

                if (product.description.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF78847C),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],

                const SizedBox(height: 14),
                _buildPriceSection(),
                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _isExpired
                        ? const Color(0xFFFFF0EF)
                        : const Color(0xFFF5F8F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isExpired
                            ? Icons.warning_amber_rounded
                            : Icons.schedule_outlined,
                        size: 17,
                        color: _isExpired
                            ? _expiredRed
                            : _primaryGreen,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          _isExpired
                              ? 'Kedaluwarsa: $_expiredLabel'
                              : 'Kedaluwarsa: $_expiredLabel',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: _isExpired
                                ? _expiredRed
                                : const Color(0xFF58665D),
                            fontSize: 11,
                            fontWeight: _isExpired
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/merchant-edit-product',
                            arguments: product.id,
                          );
                        },
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 17,
                        ),
                        label: const Text('Edit'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _primaryGreen,
                          side: const BorderSide(
                            color: Color(0xFFD5E6DA),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmDelete(context),
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 17,
                        ),
                        label: const Text('Hapus'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: _expiredRed,
                          side: const BorderSide(
                            color: Color(0xFFF3D6D3),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(bool isSoldOut) {
    final raw = (product.photo ?? '').trim();
    final photoUrl = raw.isEmpty
        ? ''
        : (raw.startsWith('http') ? raw : '${AppConstants.imageBaseUrl}/$raw');

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(22),
      ),
      child: SizedBox(
        height: 190,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (photoUrl.isNotEmpty)
              Image.network(
                photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Container(
                    color: const Color(0xFFEAF2EC),
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      color: _primaryGreen,
                    ),
                  );
                },
              )
            else
              _buildImagePlaceholder(),

            // Label PRODUCT EXPIRED di pojok kanan atas foto.
            if (_isExpired)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _expiredRed,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'PRODUCT EXPIRED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Badge diskon tetap ditampilkan untuk produk yang belum expired.
            if (!_isExpired && _discountPercent > 0)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _primaryGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'DISKON $_discountPercent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

            // Overlay stok habis tetap dipertahankan.
            if (isSoldOut)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.42),
                  alignment: Alignment.center,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'STOK HABIS',
                      style: TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFEAF2EC),
      alignment: Alignment.center,
      child: const Icon(
        Icons.fastfood_outlined,
        size: 48,
        color: _primaryGreen,
      ),
    );
  }

  Widget _buildCategoryAndStock(bool isSoldOut) {
    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7ED),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                product.kategori,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _primaryGreen,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          isSoldOut
              ? Icons.remove_circle_outline
              : Icons.inventory_2_outlined,
          size: 15,
          color: isSoldOut ? _expiredRed : _primaryGreen,
        ),
        const SizedBox(width: 5),
        Text(
          _stockLabel,
          style: TextStyle(
            color: isSoldOut ? _expiredRed : const Color(0xFF58665D),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Harga jual',
                style: TextStyle(
                  color: Color(0xFF78847C),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formattedPrice,
                style: const TextStyle(
                  color: _primaryGreen,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (product.originalPrice > product.discountPrice) ...[
                const SizedBox(height: 3),
                Text(
                  _formattedOriginalPrice,
                  style: const TextStyle(
                    color: Color(0xFF8D978F),
                    fontSize: 12,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_discountPercent > 0)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2DF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Hemat $_discountPercent%',
              style: const TextStyle(
                color: Color(0xFFB56A00),
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Hapus Produk?',
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Apakah kamu yakin ingin menghapus "${product.name}"? Tindakan ini tidak dapat dibatalkan.',
            style: const TextStyle(
              color: Color(0xFF58665D),
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text(
                'Batal',
                style: TextStyle(color: Color(0xFF78847C)),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: _expiredRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await context.read<MerchantProductProvider>().deleteProduct(
            product.id,
          );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permintaan hapus produk selesai.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus produk: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}