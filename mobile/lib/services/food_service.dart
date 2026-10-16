import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../core/storage/storage_service.dart';
import 'package:flutter/foundation.dart';

class FoodService {
  Future<List<dynamic>> getFoods() async {
    final token =
        await StorageService.getToken();

    debugPrint('TOKEN: $token');

    final response =
        await ApiClient.dio.get(
      '/foods',
      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
          'Accept':
              'application/json',
        },
      ),
    );

    debugPrint('FOODS RESPONSE');
debugPrint(response.data.toString());

    return List<dynamic>.from(
      response.data['data'] ?? [],
    );
  }
}