import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/user_model.dart';

class StorageService {
  static const FlutterSecureStorage _storage =
      FlutterSecureStorage();

  // ---------- TOKEN ----------

  static Future<void> saveToken(String token) async {
    await _storage.write(
      key: 'token',
      value: token,
    );
  }

  static Future<String?> getToken() async {
    return await _storage.read(
      key: 'token',
    );
  }

  static Future<void> clearToken() async {
    await _storage.delete(
      key: 'token',
    );
  }

  // ---------- DATA PENGGUNA ----------

  static const String _userKey = 'user_data';

  static Future<void> saveUser(UserModel user) async {
    await _storage.write(
      key: _userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  static Future<UserModel?> getUser() async {
    final raw = await _storage.read(
      key: _userKey,
    );

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> userData =
          jsonDecode(raw);

      return UserModel.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  static Future<void> clearUser() async {
    await _storage.delete(
      key: _userKey,
    );
  }

  // ---------- FOTO PROFIL ----------

  static const String _profilePhotoKey =
      'profile_photo_base64';

  static Future<void> saveProfilePhotoBase64(
    String value,
  ) async {
    await _storage.write(
      key: _profilePhotoKey,
      value: value,
    );
  }

  static Future<String?> getProfilePhotoBase64() async {
    return await _storage.read(
      key: _profilePhotoKey,
    );
  }

  static Future<void> clearProfilePhotoBase64() async {
    await _storage.delete(
      key: _profilePhotoKey,
    );
  }

  // ---------- PESANAN YANG SUDAH DI-POPUP ----------

  static const String _acknowledgedOrdersKey =
      'acknowledged_orders';

  static Future<void> saveAcknowledgedOrders(
    List<int> ids,
  ) async {
    await _storage.write(
      key: _acknowledgedOrdersKey,
      value: ids.join(','),
    );
  }

  static Future<List<int>> getAcknowledgedOrders() async {
    final raw = await _storage.read(
      key: _acknowledgedOrdersKey,
    );

    if (raw == null || raw.isEmpty) {
      return const [];
    }

    return raw
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .map((e) => int.tryParse(e.trim()) ?? -1)
        .where((e) => e != -1)
        .toList();
  }
}
