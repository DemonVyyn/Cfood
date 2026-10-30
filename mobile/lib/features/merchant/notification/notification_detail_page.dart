
import 'package:flutter/material.dart';

import '../../../models/notification_model.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailPage({
    super.key,
    required this.notification,
  });

  static const Color primaryColor = Color(0xFF198754);

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tidak tersedia';

    final localDate = date.toLocal();

    return '${localDate.day.toString().padLeft(2, '0')}/'
        '${localDate.month.toString().padLeft(2, '0')}/'
        '${localDate.year}';
  }

  String _formatTime(DateTime? date) {
    if (date == null) return 'Tidak tersedia';

    final localDate = date.toLocal();

    return '${localDate.hour.toString().padLeft(2, '0')}:'
        '${localDate.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF26352C),
        elevation: 0,
        title: const Text(
          'Rincian Notifikasi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5EC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.notifications_active_outlined,
                      size: 32,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 13),
                  Text(
                    'Informasi Notifikasi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF587063),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Judul Notifikasi',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              notification.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF26352C),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Isi Notifikasi',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE9EEEB),
                ),
              ),
              child: Text(
                notification.message,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.7,
                  color: Color(0xFF46564C),
                ),
              ),
            ),
            const SizedBox(height: 22),
            _buildInformationRow(
              icon: Icons.calendar_today_outlined,
              title: 'Tanggal',
              value: _formatDate(notification.createdAt),
            ),
            const SizedBox(height: 15),
            _buildInformationRow(
              icon: Icons.access_time_rounded,
              title: 'Waktu',
              value: _formatTime(notification.createdAt),
            ),
            const SizedBox(height: 15),
            _buildInformationRow(
              icon: Icons.mark_email_read_outlined,
              title: 'Status',
              value: notification.isRead
                  ? 'Sudah dibaca'
                  : 'Belum dibaca',
              valueColor: notification.isRead
                  ? Colors.grey
                  : primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInformationRow({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE9EEEB),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryColor,
            size: 21,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64736A),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? const Color(0xFF26352C),
            ),
          ),
        ],
      ),
    );
  }
}
