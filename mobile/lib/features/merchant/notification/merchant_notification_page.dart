import 'package:flutter/material.dart';

import '../../../core/storage/storage_service.dart';
import '../../../models/notification_model.dart';
import '../../../services/notification_service.dart';

import 'notification_detail_page.dart';
import '../notification/widget/notification_card.dart';
import '../notification/widget/notification_state_view.dart';
import '../notification/widget/notification_summary.dart';

class MerchantNotificationPage extends StatefulWidget {
  const MerchantNotificationPage({super.key});

  @override
  State<MerchantNotificationPage> createState() =>
      _MerchantNotificationPageState();
}

class _MerchantNotificationPageState
    extends State<MerchantNotificationPage> {
  final NotificationService _notificationService =
      NotificationService();

  List<NotificationModel> _notifications = [];

  bool _isLoading = true;
  bool _isMarkingAll = false;
  String? _errorMessage;

  int get _unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<String> _getToken() async {
    final token = await StorageService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        'Sesi login tidak ditemukan. Silakan login kembali.',
      );
    }

    return token;
  }

  Future<void> _loadNotifications() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final token = await _getToken();

      final result =
          await _notificationService.getNotifications(token);

      if (!mounted) return;

      setState(() {
        _notifications = result;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _markAsRead(NotificationModel notification) async {
    if (notification.isRead) return;

    final index = _notifications.indexWhere(
      (item) => item.id == notification.id,
    );

    if (index == -1) return;

    try {
      final token = await _getToken();

      await _notificationService.markAsRead(
        token: token,
        notificationId: notification.id,
      );

      if (!mounted) return;

      setState(() {
        final oldNotification = _notifications[index];

        _notifications[index] = NotificationModel(
          id: oldNotification.id,
          title: oldNotification.title,
          message: oldNotification.message,
          isRead: true,
          createdAt: oldNotification.createdAt,
          readAt: DateTime.now(),
        );
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui notifikasi: $e'),
          backgroundColor: Colors.red,
        ),
      );

      rethrow;
    }
  }

  Future<void> _openNotification(
    NotificationModel notification,
  ) async {
    try {
      await _markAsRead(notification);

      if (!mounted) return;

      final updatedNotification = _notifications.firstWhere(
        (item) => item.id == notification.id,
      );

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NotificationDetailPage(
            notification: updatedNotification,
          ),
        ),
      );
    } catch (_) {
      // Halaman rincian tidak dibuka jika status baca gagal disimpan.
    }
  }

  Future<void> _markAllAsRead() async {
    if (_unreadCount == 0 || _isMarkingAll) return;

    setState(() {
      _isMarkingAll = true;
    });

    try {
      final token = await _getToken();

      await _notificationService.markAllAsRead(token);

      if (!mounted) return;

      setState(() {
        _notifications = _notifications.map((notification) {
          if (notification.isRead) return notification;

          return NotificationModel(
            id: notification.id,
            title: notification.title,
            message: notification.message,
            isRead: true,
            createdAt: notification.createdAt,
            readAt: DateTime.now(),
          );
        }).toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua notifikasi sudah dibaca.'),
          backgroundColor: Color(0xFF198754),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memperbarui notifikasi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isMarkingAll = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF198754);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF26352C),
        elevation: 0,
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _isMarkingAll ? null : _markAllAsRead,
              child: _isMarkingAll
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: primaryColor,
                      ),
                    )
                  : const Text(
                      'Baca semua',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNotifications,
        color: primaryColor,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF198754),
        ),
      );
    }

    if (_errorMessage != null && _notifications.isEmpty) {
      return NotificationStateView(
        icon: Icons.wifi_off_rounded,
        title: 'Tidak dapat memuat notifikasi',
        message: _errorMessage!,
        onRetry: _loadNotifications,
      );
    }

    if (_notifications.isEmpty) {
      return const NotificationStateView(
        icon: Icons.notifications_none_rounded,
        title: 'Belum ada notifikasi',
        message:
            'Notifikasi terbaru dari aktivitas toko akan muncul di sini.',
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        NotificationSummary(
          unreadCount: _unreadCount,
        ),
        const SizedBox(height: 22),
        const Text(
          'Aktivitas Terbaru',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF26352C),
          ),
        ),
        const SizedBox(height: 13),
        ..._notifications.map(
          (notification) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NotificationCard(
              notification: notification,
              onTap: () => _openNotification(notification),
            ),
          ),
        ),
      ],
    );
  }
}
