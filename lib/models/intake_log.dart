import 'dart:convert';

class IntakeLog {
  final String id;
  final String medicineName;
  final String scheduledTime;
  final String recordedTime;
  final String status;
  final String shelfSlot;

  IntakeLog({
    required this.id,
    required this.medicineName,
    required this.scheduledTime,
    required this.recordedTime,
    required this.status,
    required this.shelfSlot,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineName': medicineName,
      'scheduledTime': scheduledTime,
      'recordedTime': recordedTime,
      'status': status,
      'shelfSlot': shelfSlot,
    };
  }

  factory IntakeLog.fromMap(Map<String, dynamic> map) {
    return IntakeLog(
      id: map['id'] ?? '',
      medicineName: map['medicineName'] ?? '',
      scheduledTime: map['scheduledTime'] ?? '',
      recordedTime: map['recordedTime'] ?? '',
      status: map['status'] ?? 'TAKEN_ON_TIME',
      shelfSlot: map['shelfSlot'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory IntakeLog.fromJson(String source) => IntakeLog.fromMap(json.decode(source));
}
