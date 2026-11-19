import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';

class MerchantService {
  Future<Map<String, dynamic>>
      dashboard() async {
    final token =
        await StorageService.getToken();

    final response =
        await ApiClient.dio.get(
      '/merchant/dashboard',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
        },
      ),
    );

    return response.data['data'];
  }

  Future<Map<String, dynamic>>
      getProfile() async {
    final token =
        await StorageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Sesi login berakhir. Silakan login kembali.',
      );
    }

    final response =
        await ApiClient.dio.get(
      '/merchant/profile',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return Map<String, dynamic>.from(
      response.data as Map,
    );
  }

  Future<Map<String, dynamic>>
      updateProfile({
    required String storeName,
    required String address,
    required String phone,
    String? description,
  }) async {
    final token =
        await StorageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Sesi login berakhir. Silakan login kembali.',
      );
    }

    final response =
        await ApiClient.dio.put(
      '/merchant/profile',
      data: {
        'nama_toko': storeName,
        'alamat': address,
        'nomor_telepon': phone,
        'deskripsi_toko': description,
      },
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    return Map<String, dynamic>.from(
      response.data as Map,
    );
  }
}
