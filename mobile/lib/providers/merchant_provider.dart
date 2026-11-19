import 'package:flutter/material.dart';

import '../models/merchant_dashboard_model.dart';
import '../models/merchant_profile_model.dart';
import '../services/merchant_service.dart';

class MerchantProvider
    extends ChangeNotifier {
  final MerchantService _service =
      MerchantService();

  MerchantDashboardModel?
      dashboard;

  MerchantProfileModel?
      profile;

  bool isLoading = false;

  String? error;

  bool _loaded = false;

  bool _profileLoaded = false;

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

  Future<void>
      loadProfile() async {
    if (_profileLoaded) return;

    try {
      _profileLoaded = true;

      isLoading = true;
      error = null;
      notifyListeners();

      final response =
          await _service.getProfile();

      profile =
          MerchantProfileModel
              .fromJson(
        Map<String, dynamic>.from(
          response['data'] as Map,
        ),
      );
    } catch (e) {
      error = e.toString();
      _profileLoaded = false;
      debugPrint(
        'STORE PROFILE ERROR: $e',
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void>
      refreshProfile() async {
    _profileLoaded = false;

    await loadProfile();
  }

  Future<bool>
      updateProfile({
    required String storeName,
    required String address,
    required String phone,
    String? description,
  }) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response =
          await _service.updateProfile(
        storeName: storeName,
        address: address,
        phone: phone,
        description: description,
      );

      profile =
          MerchantProfileModel
              .fromJson(
        Map<String, dynamic>.from(
          response['data'] as Map,
        ),
      );

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    dashboard = null;
    profile = null;

    error = null;

    _loaded = false;
    _profileLoaded = false;

    notifyListeners();
  }
}