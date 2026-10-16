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
}