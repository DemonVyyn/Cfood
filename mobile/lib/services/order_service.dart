
import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';

class OrderService {
  /// Membuat pesanan baru melalui Laravel API.
  ///
  /// menuId: ID menu dari database.
  /// quantity: jumlah makanan yang dipesan.
  ///
  /// Mengembalikan data pesanan dari server, termasuk
  /// kode_pengambilan untuk QR pickup.
  Future<Map<String, dynamic>> createOrder({
    required int menuId,
    required int quantity,
  }) async {
    final token = await StorageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Sesi login berakhir. Silakan login kembali.');
    }

    try {
      final response = await ApiClient.dio.post(
        '/orders',
        data: {
          'menu_id': menuId,
          'jumlah': quantity,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;

      if (responseData is! Map) {
        throw Exception('Format respons pesanan dari server tidak valid.');
      }

      final body = Map<String, dynamic>.from(responseData);
      final rawOrder = body['data'];

      if (rawOrder is! Map) {
        throw Exception(
          body['message']?.toString() ??
              'Server tidak mengembalikan data pesanan.',
        );
      }

      final order = Map<String, dynamic>.from(rawOrder);
      final pickupCode = order['kode_pengambilan']?.toString();

      if (pickupCode == null || pickupCode.isEmpty) {
        throw Exception('Kode pengambilan tidak ditemukan pada respons API.');
      }

      return order;
    } on DioException catch (e) {
      final responseData = e.response?.data;
      String message = 'Gagal membuat pesanan. Periksa koneksi dan coba lagi.';

      if (responseData is Map) {
        message = responseData['message']?.toString() ?? message;

        final errors = responseData['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            message = firstError.first.toString();
          }
        }
      } else if (e.message != null) {
        message = e.message!;
      }

      throw Exception(message);
    }
  }

  /// Mengambil riwayat pesanan customer.
  Future<List<Map<String, dynamic>>> getOrders() async {
    final token = await StorageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Sesi login berakhir. Silakan login kembali.');
    }

    try {
      final response = await ApiClient.dio.get(
        '/orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      final responseData = response.data;
      if (responseData is! Map) {
        throw Exception('Format respons riwayat pesanan tidak valid.');
      }

      final body = Map<String, dynamic>.from(responseData);
      final rawOrders = body['data'];

      if (rawOrders is! List) {
        return [];
      }

      return rawOrders
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on DioException catch (e) {
      final responseData = e.response?.data;
      if (responseData is Map &&
          responseData['message'] != null) {
        throw Exception(responseData['message'].toString());
      }

      throw Exception('Gagal mengambil riwayat pesanan.');
    }
  }
}
