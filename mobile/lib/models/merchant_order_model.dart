
class MerchantOrderModel {
  final int id;
  final String customerName;
  final String productName;
  final String categoryName;
  final String storeName;
  final String status;
  final String pickupCode;
  final String pickupTime;
  final double totalPrice;
  final String paymentStatus;
  final String paymentMethod;
  final DateTime? createdAt;

  MerchantOrderModel({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.categoryName,
    required this.storeName,
    required this.status,
    required this.pickupCode,
    required this.pickupTime,
    required this.totalPrice,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory MerchantOrderModel.fromJson(Map<String, dynamic> json) {
    String productName = '';
    String categoryName = '';

    final items = json['items'];
    if (items is List && items.isNotEmpty) {
      final firstItem = items.first;
      if (firstItem is Map) {
        final menu = firstItem['menu'];
        if (menu is Map) {
          productName = menu['nama']?.toString() ?? '';
          categoryName =
              menu['kategori']?.toString() ?? '';
        }
      }
    }

    final payment = json['pembayaran'];
    final paymentMap = payment is Map ? payment : null;

    return MerchantOrderModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      customerName: json['customer'] is Map
          ? json['customer']['nama']?.toString() ?? ''
          : '',
      productName: productName,
      categoryName: categoryName,
      storeName: _extractStoreName(json),
      status: json['order_status']?.toString() ?? '',
      pickupCode: json['kode_pengambilan']?.toString() ?? '',
      pickupTime: json['waktu_pengambilan']?.toString() ?? '',
      totalPrice:
          double.tryParse(json['total_harga'].toString()) ?? 0,
      paymentStatus:
          paymentMap?['status_pembayaran']?.toString() ?? 'unknown',
      paymentMethod:
          paymentMap?['metode_pembayaran']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(
              json['created_at'].toString(),
            )
          : null,
      );
      }

      static String _extractStoreName(
      Map<String, dynamic> json,
      ) {
      final mitra = json['mitra'];
      if (mitra is Map && mitra['nama_toko'] != null) {
      return mitra['nama_toko'].toString();
      }

      final items = json['items'];
      if (items is List && items.isNotEmpty) {
      final first = items.first;
      if (first is Map) {
      final menu = first['menu'];
      if (menu is Map) {
        final m = menu['mitra'];
        if (m is Map && m['nama_toko'] != null) {
          return m['nama_toko'].toString();
        }
      }
      }
      }

      return '';
      }
      }
