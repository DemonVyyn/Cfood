import 'package:flutter/material.dart';

import '../core/storage/storage_service.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? user;

  bool isLoading = false;

  String? errorMessage;

  bool get isLoggedIn => user != null;

  // ---------- LOGIN ----------

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final response = await _authService.login(
        email: email,
        password: password,
      );

      final newUser = UserModel.fromJson(
        response['user'],
      );

      await StorageService.saveToken(
        response['token'],
      );

      await StorageService.saveUser(newUser);

      user = newUser;

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------- REGISTER ----------

  Future<bool> register({
    required String role,
    required String nama,
    required String email,
    required String phone,
    required String password,
    String? namaToko,
    String? alamat,
    String? nomorTeleponToko,
    String? deskripsiToko,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _authService.register(
        role: role,
        nama: nama,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: password,
        namaToko: namaToko,
        alamat: alamat,
        nomorTeleponToko: nomorTeleponToko,
        deskripsiToko: deskripsiToko,
      );

      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ---------- CHECK LOGIN ----------

  // Membaca token dan profil dari penyimpanan lokal.
  // Tidak melakukan request internet atau API.

  Future<bool> checkLogin() async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) {
        user = null;
        return false;
      }

      final savedUser = await StorageService.getUser();

      if (savedUser == null) {
        user = null;
        return false;
      }

      user = savedUser;

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('CHECK LOGIN ERROR: $e');

      user = null;

      return false;
    }
  }

  // ---------- LOGOUT ----------

  Future<void> logout() async {
    final token = await StorageService.getToken();

    if (token != null) {
      try {
        await _authService.logout(token);
      } catch (e) {
        debugPrint('LOGOUT API ERROR: $e');
      }
    }

    await StorageService.clearToken();
    await StorageService.clearUser();

    user = null;

    notifyListeners();
  }
}
