import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/storage/storage_service.dart';

/// Menyimpan foto profil pengguna agar bisa dipakai
/// di banyak tempat (home header & halaman profil) sekaligus.
///
/// Foto disimpan **permanen** di secure storage (format base64),
/// jadi tetap ada setelah logout, login kembali, atau app ditutup
/// dan dibuka lagi.
class ProfilePhotoProvider extends ChangeNotifier {
  Uint8List? _photoBytes;

  bool _isLoaded = false;

  /// Bytes foto profil, null kalau belum pernah diatur.
  Uint8List? get photo => _photoBytes;

  /// True setelah foto tersimpan selesai dimuat dari storage.
  bool get isLoaded => _isLoaded;

  /// Muat foto tersimpan dari storage (dipanggil sekali saat app mulai).
  Future<void> load() async {
    final base64String =
        await StorageService.getProfilePhotoBase64();

    _photoBytes =
        base64String != null ? base64Decode(base64String) : null;
    _isLoaded = true;

    notifyListeners();
  }

  /// Simpan foto terpilih (dari galeri/kamera) secara permanen.
  Future<void> setPhoto(XFile? photo) async {
    if (photo == null) {
      _photoBytes = null;
      await StorageService.clearProfilePhotoBase64();
    } else {
      final bytes = await photo.readAsBytes();
      _photoBytes = bytes;
      await StorageService.saveProfilePhotoBase64(
        base64Encode(bytes),
      );
    }

    notifyListeners();
  }
}
