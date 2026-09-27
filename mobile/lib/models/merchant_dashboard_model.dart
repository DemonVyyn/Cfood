import 'merchant_product_model.dart';

class MerchantDashboardModel {
  final String storeName;

  final int activeProducts;

  final int waitingOrders;

  final double todaySales;

  final List<dynamic> latestOrders;

  final List<MerchantProductModel> stocks;

  MerchantDashboardModel({
    required this.storeName,
    required this.activeProducts,
    required this.waitingOrders,
    required this.todaySales,
    required this.latestOrders,
    required this.stocks,
  });

  factory MerchantDashboardModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MerchantDashboardModel(
      storeName:
          json['store_name'] ?? '',

      activeProducts:
          json['active_products'] ?? 0,

      waitingOrders:
          json['waiting_orders'] ?? 0,

      todaySales:
          double.tryParse(
                json['today_sales']
                    .toString(),
              ) ??
              0,

      latestOrders:
          List<dynamic>.from(
        json['latest_orders'] ?? [],
      ),

      stocks:
          (json['stocks'] as List? ?? [])
              .map(
                (e) =>
                    MerchantProductModel
                        .fromJson(e),
              )
              .toList(),
    );
  }
}