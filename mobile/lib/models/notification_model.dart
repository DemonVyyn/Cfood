
class NotificationModel {
  final int id;
  final String title;
  final String message;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? readAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.isRead,
    this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: int.parse(json['id'].toString()),
      title: json['judul']?.toString() ?? '',
      message: json['pesan']?.toString() ?? '',
      isRead: json['is_read'] == true ||
          json['is_read'] == 1 ||
          json['is_read']?.toString() == '1',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      readAt: json['read_at'] != null
          ? DateTime.tryParse(json['read_at'].toString())
          : null,
    );
  }
}
