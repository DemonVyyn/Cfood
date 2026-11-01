
import 'package:flutter/material.dart';

import '../../../core/storage/storage_service.dart';
import '../../../models/notification_model.dart';
import '../../../services/notification_service.dart';

import 'widgets/notification_card.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];

  bool _loading = false;
  bool _onlyUnread = false;
  bool _isMarkingAll = false;

  String? _errorMessage;

  int get _unreadCount =>
      _notifications.where((notification) => !notification.isRead).length;

  List<NotificationModel> get _visibleNotifications {
    if (!_onlyUnread) return _notifications;

    return _notifications
        .where((notification) => !notification.isRead)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _load();
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

  Future<void> _load() async {
    if (!mounted) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final token = await _getToken();

      final result =
          await _notificationService.getCustomerNotifications(token);

      if (!mounted) return;

      result.sort(
        (a, b) => (b.createdAt ?? DateTime(2000))
            .compareTo(a.createdAt ?? DateTime(2000)),
      );

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
          _loading = false;
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

    final token = await _getToken();

    await _notificationService.markCustomerAsRead(
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
  }

  Future<void> _markAllAsRead() async {
    if (_unreadCount == 0 || _isMarkingAll) return;

    setState(() {
      _isMarkingAll = true;
    });

    try {
      final token = await _getToken();

      await _notificationService.markAllCustomerAsRead(token);

      if (!mounted) return;

      final now = DateTime.now();

      setState(() {
        _notifications = _notifications.map((notification) {
          if (notification.isRead) return notification;

          return NotificationModel(
            id: notification.id,
            title: notification.title,
            message: notification.message,
            isRead: true,
            createdAt: notification.createdAt,
            readAt: now,
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

  Future<void> _showDetail(NotificationModel notification) async {
    try {
      await _markAsRead(notification);

      if (!mounted) return;

      final updatedNotification = _notifications.firstWhere(
        (item) => item.id == notification.id,
      );

      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (_) => _buildDetailSheet(updatedNotification),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuka notifikasi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDetailSheet(NotificationModel notification) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFF198754),
                  size: 25,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF26352C),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              notification.message,
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _relativeTime(notification.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF198754),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _relativeTime(DateTime? dateTime) {
    if (dateTime == null) return '';

    final difference = DateTime.now().difference(dateTime);

    if (difference.inMinutes < 1) return 'Baru saja';

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit lalu';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} jam lalu';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    }

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleNotifications;

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
                        color: Color(0xFF198754),
                      ),
                    )
                  : const Text(
                      'Baca semua',
                      style: TextStyle(
                        color: Color(0xFF198754),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: const Color(0xFF198754),
        child: _buildBody(visible),
      ),
    );
  }

  Widget _buildBody(List<NotificationModel> visible) {
    if (_loading && _notifications.isEmpty) {
      return ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 300,
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF198754),
              ),
            ),
          ),
        ],
      );
    }

    if (_errorMessage != null && _notifications.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 350,
            child: _buildEmptyState(
              icon: Icons.wifi_off_rounded,
              message: 'Tidak dapat memuat notifikasi.',
              description: _errorMessage!,
              showRetry: true,
            ),
          ),
        ],
      );
    }

    if (visible.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: 350,
            child: _buildEmptyState(
              icon: Icons.notifications_off_outlined,
              message: _onlyUnread
                  ? 'Tidak ada notifikasi belum dibaca.'
                  : 'Belum ada notifikasi.',
              description: _onlyUnread
                  ? 'Semua notifikasi sudah dibaca.'
                  : 'Notifikasi terbaru akan muncul di sini.',
            ),
          ),
        ],
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        ...visible.map(
          (notification) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: NotificationCard(
              title: notification.title,
              message: notification.message,
              time: _relativeTime(notification.createdAt),
              icon: Icons.notifications_active_outlined,
              iconColor: const Color(0xFF198754),
              isUnread: !notification.isRead,
              onTap: () => _showDetail(notification),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            _unreadCount > 0
                ? '$_unreadCount belum dibaca'
                : 'Semua sudah dibaca',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),
        ),
        FilterChip(
          label: const Text('Belum dibaca'),
          selected: _onlyUnread,
          onSelected: (value) {
            setState(() {
              _onlyUnread = value;
            });
          },
          selectedColor: Colors.green.shade100,
          checkmarkColor: const Color(0xFF198754),
        ),
      ],
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    required String description,
    bool showRetry = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
            ),
            if (showRetry) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _load,
                child: const Text('Coba lagi'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
