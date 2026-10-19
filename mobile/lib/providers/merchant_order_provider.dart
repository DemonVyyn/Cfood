
import 'package:flutter/material.dart';

import '../models/merchant_order_model.dart';
import '../services/merchant_order_service.dart';

class MerchantOrderProvider extends ChangeNotifier {
  final MerchantOrderService _service = MerchantOrderService();

  List<MerchantOrderModel> orders = [];

  bool isLoading = false;
  bool isConfirmingPickup = false;
  final Set<int> _verifyingOrderIds = {};

  bool isVerifyingPayment(int orderId) {
    return _verifyingOrderIds.contains(orderId);
  }

  Future<void> loadOrders() async {
    try {
      isLoading = true;
      notifyListeners();

      final data = await _service.getOrders();

      orders = data
          .map<MerchantOrderModel>(
            (e) => MerchantOrderModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> verifyPayment(int orderId) async {
    if (_verifyingOrderIds.contains(orderId)) {
      throw Exception('Verifikasi pembayaran sedang diproses.');
    }

    _verifyingOrderIds.add(orderId);
    notifyListeners();

    try {
      final result = await _service.verifyPayment(orderId);

      if (result['success'] != true) {
        throw Exception(
          result['message']?.toString() ??
              'Pembayaran gagal diverifikasi.',
        );
      }

      await loadOrders();
      return result;
    } finally {
      _verifyingOrderIds.remove(orderId);
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> confirmPickup(
    String pickupCode,
  ) async {
    if (isConfirmingPickup) {
      throw Exception('Konfirmasi pickup sedang diproses.');
    }

    isConfirmingPickup = true;
    notifyListeners();

    try {
      final result = await _service.confirmPickup(pickupCode);

      if (result['success'] != true) {
        throw Exception(
          result['message']?.toString() ?? 'Pickup gagal dikonfirmasi.',
        );
      }

      await loadOrders();
      return result;
    } finally {
      isConfirmingPickup = false;
      notifyListeners();
    }
  }
}
