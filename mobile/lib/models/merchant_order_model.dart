
class MerchantOrderModel {
  final int id;
  final String customerName;
  final String productName;
  final String status;
  final String pickupCode;
  final String pickupTime;
  final double totalPrice;
  final String paymentStatus;
  final String paymentMethod;

  MerchantOrderModel({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.status,
    required this.pickupCode,
    required this.pickupTime,
    required this.totalPrice,
    required this.paymentStatus,
    required this.paymentMethod,
  });

  factory MerchantOrderModel.fromJson(Map<String, dynamic> json) {
    String productName = '';

    final items = json['items'];
    if (items is List && items.isNotEmpty) {
      final firstItem = items.first;
      if (firstItem is Map) {
        final menu = firstItem['menu'];
        if (menu is Map) {
          productName = menu['nama']?.toString() ?? '';
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
      status: json['order_status']?.toString() ?? '',
      pickupCode: json['kode_pengambilan']?.toString() ?? '',
      pickupTime: json['waktu_pengambilan']?.toString() ?? '',
      totalPrice:
          double.tryParse(json['total_harga'].toString()) ?? 0,
      paymentStatus:
          paymentMap?['status_pembayaran']?.toString() ?? 'unknown',
      paymentMethod:
          paymentMap?['metode_pembayaran']?.toString() ?? '',
    );
  }
}
