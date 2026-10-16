import 'package:flutter/material.dart';

import '../models/merchant_dashboard_model.dart';
import '../services/merchant_service.dart';

class MerchantProvider
    extends ChangeNotifier {
  final MerchantService _service =
      MerchantService();

  MerchantDashboardModel?
      dashboard;

  bool isLoading = false;

  String? error;

  bool _loaded = false;

  Future<void> loadDashboard()
      async {
    if (_loaded) return;

    try {
      _loaded = true;

      isLoading = true;

      error = null;

      notifyListeners();

      final data =
          await _service.dashboard();

      dashboard =
          MerchantDashboardModel
              .fromJson(
        data,
      );
    } catch (e) {
      error = e.toString();

      _loaded = false;

      debugPrint(
        'DASHBOARD ERROR: $e',
      );
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void>
      refreshDashboard() async {
    _loaded = false;

    await loadDashboard();
  }

  void clear() {
    dashboard = null;

    error = null;

    _loaded = false;

    notifyListeners();
  }
}