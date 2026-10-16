import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';

class MerchantOrderService {
  Future<Map<String, dynamic>> _headers() async {
    final token = await StorageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Sesi login berakhir. Silakan login kembali.');
    }

    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  Future<List<dynamic>> getOrders() async {
    final response = await ApiClient.dio.get(
      '/merchant/orders',
      options: Options(headers: await _headers()),
    );

    return List<dynamic>.from(response.data['data'] ?? []);
  }

  Future<Map<String, dynamic>> confirmPickup(
    String pickupCode,
  ) async {
    try {
      final response = await ApiClient.dio.post(
        '/merchant/orders/confirm-pickup',
        data: {
          'kode_pengambilan': pickupCode,
        },
        options: Options(headers: await _headers()),
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      final data = e.response?.data;

      final message = data is Map
          ? data['message']?.toString()
          : null;

      throw Exception(
        message ?? 'Gagal mengonfirmasi pickup. Periksa koneksi dan coba lagi.',
      );
    }
  }
}