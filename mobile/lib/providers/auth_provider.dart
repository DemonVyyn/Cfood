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

      await StorageService.saveToken(
        response['token'],
      );

      user = UserModel.fromJson(
        response['user'],
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
      passwordConfirmation:
          password,

      namaToko: namaToko,
      alamat: alamat,
      nomorTeleponToko:
          nomorTeleponToko,
      deskripsiToko:
          deskripsiToko,
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

  Future<bool> checkLogin() async {
    try {
      final token =
          await StorageService.getToken();

      if (token == null) {
        return false;
      }

      final response =
          await _authService.profile(token);

      user = UserModel.fromJson(
        response['user'],
      );

      notifyListeners();

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> logout() async {
    final token =
        await StorageService.getToken();

    if (token != null) {
      await _authService.logout(token);
    }

    await StorageService.clearToken();

    user = null;

    notifyListeners();
  }
}