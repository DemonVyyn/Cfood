class MerchantOrderModel {
  final int id;

  final String customerName;

  final String productName;

  final String status;

  final String pickupCode;

  final String pickupTime;

  final double totalPrice;

  MerchantOrderModel({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.status,
    required this.pickupCode,
    required this.pickupTime,
    required this.totalPrice,
  });

  factory MerchantOrderModel.fromJson(
    Map<String, dynamic> json,
  ) {
    String productName = '';

    if (json['items'] != null &&
        json['items'].isNotEmpty) {
      productName =
          json['items'][0]['menu']['nama'] ??
              '';
    }

    return MerchantOrderModel(
      id: json['id'],

      customerName:
          json['customer']?['nama'] ?? '',

      productName: productName,

      status:
          json['order_status'] ?? '',

      pickupCode:
          json['kode_pengambilan'] ?? '',

      pickupTime:
          json['waktu_pengambilan'] ?? '',

      totalPrice: double.parse(
        json['total_harga'].toString(),
      ),
    );
  }
}