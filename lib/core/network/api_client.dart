import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      headers: {
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(
        seconds: 20,
      ),
      receiveTimeout: const Duration(
        seconds: 20,
      ),
    ),
  );
}