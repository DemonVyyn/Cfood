 import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(
    String token,
  ) async {
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

  // ---------- FOTO PROFIL ----------

  static const _profilePhotoKey =
      'profile_photo_base64';

  /// Simpan foto profil dalam format base64 (string).
  static Future<void> saveProfilePhotoBase64(
    String value,
  ) async {
    await _storage.write(
      key: _profilePhotoKey,
      value: value,
    );
  }

  /// Ambil foto profil tersimpan (base64), null kalau belum ada.
  static Future<String?> getProfilePhotoBase64() async {
    return await _storage.read(
      key: _profilePhotoKey,
    );
  }

  /// Hapus foto profil tersimpan.
  static Future<void> clearProfilePhotoBase64() async {
    await _storage.delete(
      key: _profilePhotoKey,
    );
  }

  // ---------- PESANAN YANG SUDAH DI-POPUP ----------

  static const _acknowledgedOrdersKey =
      'acknowledged_orders';

  /// Simpan daftar ID pesanan yang sudah di-popup konfirmasi
  /// agar tidak muncul berulang.
  static Future<void> saveAcknowledgedOrders(
    List<int> ids,
  ) async {
    await _storage.write(
      key: _acknowledgedOrdersKey,
      value: ids.join(','),
    );
  }

  /// Ambil daftar ID pesanan yang sudah di-popup konfirmasi.
  static Future<List<int>> getAcknowledgedOrders() async {
    final raw = await _storage.read(
      key: _acknowledgedOrdersKey,
    );
    if (raw == null || raw.isEmpty) return const [];
    return raw
        .split(',')
        .where((e) => e.trim().isNotEmpty)
        .map((e) => int.tryParse(e.trim()) ?? -1)
        .where((e) => e != -1)
        .toList();
  }
}