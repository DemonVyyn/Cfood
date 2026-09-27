import 'package:dio/dio.dart';

import '../core/network/api_client.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await ApiClient.dio.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return response.data;
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  Future<Map<String, dynamic>> register({
  required String role,
  required String nama,
  required String email,
  required String phone,
  required String password,
  required String passwordConfirmation,
  String? namaToko,
  String? alamat,
  String? nomorTeleponToko,
  String? deskripsiToko,
}) async {
  try {
    final response =
        await ApiClient.dio.post(
      '/register',
      data: {
        'role': role,
        'nama': nama,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation':
            passwordConfirmation,

        'nama_toko': namaToko,
        'alamat': alamat,
        'nomor_telepon_toko':
            nomorTeleponToko,
        'deskripsi_toko':
            deskripsiToko,
      },
    );

    return response.data;
  } on DioException catch (e) {
    throw _extractError(e);
  }
}

  Future<Map<String, dynamic>> profile(
    String token,
  ) async {
    final response =
        await ApiClient.dio.get(
      '/profile',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
        },
      ),
    );

    return response.data;
  }

  Future<void> logout(
    String token,
  ) async {
    await ApiClient.dio.post(
      '/logout',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
        },
      ),
    );
  }

  String _extractError(
    DioException e,
  ) {
    final data = e.response?.data;

    if (data is Map &&
        data['errors'] != null) {
      final errors =
          data['errors'] as Map;

      final firstField =
          errors.values.first;

      if (firstField is List &&
          firstField.isNotEmpty) {
        return firstField.first
            .toString();
      }
    }

    if (data is Map &&
        data['message'] != null) {
      return data['message']
          .toString();
    }

    return 'Terjadi kesalahan';
  }
}