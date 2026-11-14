import 'dart:convert';

enum NotificationType { warning, expiry, system, info }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String time;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.name,
      'time': time,
      'isRead': isRead,
    };
  }

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => NotificationType.info,
      ),
      time: map['time'] ?? '',
      isRead: map['isRead'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationItem.fromJson(String source) => NotificationItem.fromMap(json.decode(source));
}
