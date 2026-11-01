
import 'package:dio/dio.dart';

import '../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationService {
  // ============================================================
  // MITRA NOTIFICATIONS
  // ============================================================

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

  // ============================================================
  // CUSTOMER NOTIFICATIONS
  // ============================================================

  Future<List<NotificationModel>> getCustomerNotifications(
    String token,
  ) async {
    try {
      final response = await ApiClient.dio.get(
        '/notifications',
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

  Future<void> markCustomerAsRead({
    required String token,
    required int notificationId,
  }) async {
    try {
      await ApiClient.dio.patch(
        '/notifications/$notificationId/read',
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

  Future<void> markAllCustomerAsRead(String token) async {
    try {
      await ApiClient.dio.patch(
        '/notifications/read-all',
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

  // ============================================================
  // ERROR HANDLER
  // ============================================================

  String _extractError(DioException e) {
    final data = e.response?.data;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    if (e.response?.statusCode == 401) {
      return 'Sesi login berakhir. Silakan login kembali.';
    }

    if (e.response?.statusCode == 403) {
      return 'Anda tidak memiliki izin untuk mengakses notifikasi ini.';
    }

    if (e.response?.statusCode == 404) {
      return 'Data atau endpoint notifikasi tidak ditemukan.';
    }

    return 'Gagal menghubungkan ke server.';
  }
}
