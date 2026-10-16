import 'package:flutter/material.dart';

import '../models/merchant_order_model.dart';
import '../services/merchant_order_service.dart';

class MerchantOrderProvider
    extends ChangeNotifier {
  final MerchantOrderService _service =
      MerchantOrderService();

  List<MerchantOrderModel> orders = [];

  bool isLoading = false;

  Future<void> loadOrders() async {
    try {
      isLoading = true;

      notifyListeners();

      final data =
          await _service.getOrders();

      orders =
          data
              .map<MerchantOrderModel>(
                (e) =>
                    MerchantOrderModel
                        .fromJson(e),
              )
              .toList();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}