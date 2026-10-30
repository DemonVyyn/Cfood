
import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotifications(
    String token,
  ) async {
    try {
      final response = await ApiClient.dio.get(
        '/merchant/notifications',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final List<dynamic> data = response.data['data'];

      return data
          .map(
            (item) => NotificationModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  Future<void> markAsRead({
    required String token,
    required int notificationId,
  }) async {
    try {
      await ApiClient.dio.patch(
        '/merchant/notifications/$notificationId/read',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  Future<void> markAllAsRead(String token) async {
    try {
      await ApiClient.dio.patch(
        '/merchant/notifications/read-all',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    if (e.response?.statusCode == 401) {
      return 'Sesi login berakhir. Silakan login kembali.';
    }

    return 'Gagal menghubungkan ke server.';
  }
}
