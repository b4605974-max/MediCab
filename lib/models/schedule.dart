import 'dart:convert';

enum ScheduleStatus { taken, due, upcoming, missed }

class Schedule {
  final String id;
  final String medicineId;
  final String timeString; // e.g. "12:30 PM"
  final String category; // "Antibiotics", "Daily Rx"
  final String dosageDisplay; // "1 Capsule with lunch"
  ScheduleStatus status;
  String? takenAt;
  final bool enableLedGuide;
  final bool enableCabinetChime;

  Schedule({
    required this.id,
    required this.medicineId,
    required this.timeString,
    required this.category,
    required this.dosageDisplay,
    this.status = ScheduleStatus.upcoming,
    this.takenAt,
    this.enableLedGuide = true,
    this.enableCabinetChime = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicineId': medicineId,
      'timeString': timeString,
      'category': category,
      'dosageDisplay': dosageDisplay,
      'status': status.name,
      'takenAt': takenAt,
      'enableLedGuide': enableLedGuide,
      'enableCabinetChime': enableCabinetChime,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'] ?? '',
      medicineId: map['medicineId'] ?? '',
      timeString: map['timeString'] ?? '',
      category: map['category'] ?? 'Daily Rx',
      dosageDisplay: map['dosageDisplay'] ?? '',
      status: ScheduleStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ScheduleStatus.upcoming,
      ),
      takenAt: map['takenAt'],
      enableLedGuide: map['enableLedGuide'] ?? true,
      enableCabinetChime: map['enableCabinetChime'] ?? true,
    );
  }

  String toJson() => json.encode(toMap());

  factory Schedule.fromJson(String source) => Schedule.fromMap(json.decode(source));
}
