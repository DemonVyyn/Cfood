import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';

class MerchantOrderService {
  Future<List<dynamic>> getOrders() async {
    final token =
        await StorageService.getToken();

    final response =
        await ApiClient.dio.get(
      '/merchant/orders',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
          'Accept':
              'application/json',
        },
      ),
    );

    return List<dynamic>.from(
      response.data['data'] ?? [],
    );
  }
}