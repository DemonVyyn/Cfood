import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Menyimpan foto profil yang dipilih user agar bisa dipakai
/// di banyak tempat (home header & halaman profil) sekaligus.
///
/// Foto disimpan di memory selama app berjalan. Saat backend siap,
/// tambahkan upload + simpan URL di sini.
class ProfilePhotoProvider extends ChangeNotifier {
  XFile? _photo;

  XFile? get photo => _photo;

  void setPhoto(XFile? photo) {
    _photo = photo;
    notifyListeners();
  }
}
