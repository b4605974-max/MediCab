import 'package:flutter/foundation.dart';
import '../models/medicine.dart';
import '../models/schedule.dart';
import '../models/cabinet.dart';
import '../models/intake_log.dart';
import '../models/notification_item.dart';

class CabinetService extends ChangeNotifier {
  static final CabinetService _instance = CabinetService._internal();
  factory CabinetService() => _instance;
  CabinetService._internal() {
    _initDefaults();
  }

  String userName = "Alex Chen";
  String userEmail = "alex.chen@healthmail.com";
  int streakDays = 12;

  late CabinetHardware hardware;
  List<CabinetShelf> shelves = [];
  List<Medicine> medicines = [];
  List<Schedule> schedules = [];
  List<IntakeLog> intakeLogs = [];
  List<NotificationItem> notifications = [];

  void resetDefaults() {
    _initDefaults();
    notifyListeners();
  }

  void _initDefaults() {
    userName = "Alex Chen";
    userEmail = "alex.chen@healthmail.com";
    streakDays = 12;

    hardware = CabinetHardware(cabinetId: "MC-IOT-98214");

    shelves = [
      CabinetShelf(
        id: "shelf-1",
        name: "Top Shelf (Daily Rx)",
        subtitle: "Daily maintenance & chronic prescription medications",
        iconName: "pill",
        temperatureC: 21.2,
      ),
      CabinetShelf(
        id: "shelf-2",
        name: "Middle Shelf (First Aid)",
        subtitle: "Emergency dressings, antiseptics & fever relief",
        iconName: "medical_services",
        temperatureC: 21.4,
      ),
      CabinetShelf(
        id: "shelf-3",
        name: "Bottom Drawer (Misc & Child)",
        subtitle: "Pediatric syrups & high-potency medications",
        iconName: "child_care",
        temperatureC: 21.6,
        isLocked: true,
      ),
    ];

    medicines = [
      Medicine(
        id: "med-1",
        brandName: "Amoxicillin",
        genericName: "Amoxicillin Trihydrate",
        dosage: "500mg",
        form: "Capsule",
        shelfId: "shelf-1",
        shelfSlot: "Slot A1 (Upper Left)",
        totalStock: 30,
        currentStock: 18,
        expiryDate: DateTime.now().add(const Duration(days: 180)),
        instructions: "Take 1 capsule with food and water",
        prescribedBy: "Dr. Elena Santos",
        tags: ["Antibiotic", "Active Regimen"],
        imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuAuaJfjWfFQjjA25MYFjMqz5tBjmtmRl4reolkRqdh7X7gREFLX6z3A7NhZaW-9KjfRs3oqrEsgB73vvWLZaPxzh6wFcycUUAWMvD0A7UmTn4hCHUJw4hSrrGD0kdBNEbgfK7jB6XLpydJ6Uep0Dg19ji9ov9RfMgHn796PHhK_nHASM6pMPlpAQ6T3T0W9mt1ATAlAAJlRkgRZErBspRn2grNaQcdhCHVJjyysGTw-",
      ),
      Medicine(
        id: "med-2",
        brandName: "Atorvastatin",
        genericName: "Atorvastatin Calcium",
        dosage: "20mg",
        form: "Tablet",
        shelfId: "shelf-1",
        shelfSlot: "Slot A2",
        totalStock: 60,
        currentStock: 42,
        expiryDate: DateTime.now().add(const Duration(days: 300)),
        instructions: "1 tablet daily after breakfast",
        prescribedBy: "Dr. Marcus Vance",
        tags: ["Cardio", "Daily Rx"],
      ),
      Medicine(
        id: "med-3",
        brandName: "Ibuprofen",
        genericName: "Ibuprofen NSAID",
        dosage: "400mg",
        form: "Capsule",
        shelfId: "shelf-2",
        shelfSlot: "Slot B1",
        totalStock: 24,
        currentStock: 4, // Low stock trigger
        expiryDate: DateTime.now().add(const Duration(days: 90)),
        instructions: "Take as needed for pain with a meal",
        tags: ["Pain Relief", "Low Stock"],
      ),
      Medicine(
        id: "med-4",
        brandName: "Saline Nasal Spray",
        genericName: "Sodium Chloride 0.9%",
        dosage: "15ml",
        form: "Spray",
        shelfId: "shelf-2",
        shelfSlot: "Slot B2",
        totalStock: 1,
        currentStock: 1,
        expiryDate: DateTime.now().add(const Duration(days: 6)), // Expiring soon
        instructions: "1 spray each nostril twice daily",
        tags: ["Respiratory", "Expiring Soon"],
      ),
      Medicine(
        id: "med-5",
        brandName: "Melatonin",
        genericName: "Melatonin Sleep Aid",
        dosage: "5mg",
        form: "Tablet",
        shelfId: "shelf-1",
        shelfSlot: "Slot A3",
        totalStock: 45,
        currentStock: 30,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        instructions: "1 tablet 30 minutes before bed",
        tags: ["Sleep", "Evening"],
      ),
    ];

    schedules = [
      Schedule(
        id: "sched-1",
        medicineId: "med-2",
        timeString: "08:00 AM",
        category: "Daily Rx",
        dosageDisplay: "1 Tablet with water",
        status: ScheduleStatus.taken,
        takenAt: "8:05 AM",
      ),
      Schedule(
        id: "sched-2",
        medicineId: "med-1",
        timeString: "12:30 PM",
        category: "Antibiotics",
        dosageDisplay: "1 Capsule with lunch",
        status: ScheduleStatus.due,
      ),
      Schedule(
        id: "sched-3",
        medicineId: "med-1",
        timeString: "06:00 PM",
        category: "Antibiotics",
        dosageDisplay: "1 Capsule with dinner",
        status: ScheduleStatus.upcoming,
      ),
      Schedule(
        id: "sched-4",
        medicineId: "med-5",
        timeString: "09:00 PM",
        category: "Sleep Routine",
        dosageDisplay: "1 Tablet 30 min before bed",
        status: ScheduleStatus.upcoming,
      ),
    ];

    intakeLogs = [
      IntakeLog(
        id: "log-1",
        medicineName: "Atorvastatin 20mg",
        scheduledTime: "Today, 8:00 AM",
        recordedTime: "Today, 8:05 AM",
        status: "TAKEN_ON_TIME",
        shelfSlot: "Top Shelf • Slot A2",
      ),
      IntakeLog(
        id: "log-2",
        medicineName: "Amoxicillin 500mg",
        scheduledTime: "Yesterday, 6:00 PM",
        recordedTime: "Yesterday, 6:12 PM",
        status: "TAKEN_ON_TIME",
        shelfSlot: "Top Shelf • Slot A1",
      ),
    ];

    notifications = [
      NotificationItem(
        id: "notif-1",
        title: "Low Stock Alert: Ibuprofen 400mg",
        message: "Only 4 capsules remain in Middle Shelf Slot B1. Reorder recommended.",
        type: NotificationType.warning,
        time: "25 mins ago",
      ),
      NotificationItem(
        id: "notif-2",
        title: "Expiring Soon: Saline Nasal Spray",
        message: "Bottle expires in 6 days. Check compartment inventory.",
        type: NotificationType.expiry,
        time: "2 hours ago",
      ),
      NotificationItem(
        id: "notif-3",
        title: "Cabinet Synced Successfully",
        message: "Hardware sensors calibrated. Ambient temperature stable at 21.4°C.",
        type: NotificationType.system,
        time: "Today, 8:00 AM",
        isRead: true,
      ),
    ];
  }

  // Next due schedule with safety null checks
  Schedule? get nextDueSchedule {
    if (schedules.isEmpty) return null;
    try {
      return schedules.firstWhere(
        (s) => s.status == ScheduleStatus.due,
        orElse: () => schedules.firstWhere(
          (s) => s.status == ScheduleStatus.upcoming,
          orElse: () => schedules.first,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Medicine? getMedicine(String id) {
    try {
      return medicines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  void markDoseTaken(String scheduleId) {
    final index = schedules.indexWhere((s) => s.id == scheduleId);
    if (index == -1) return;

    final sched = schedules[index];
    sched.status = ScheduleStatus.taken;
    sched.takenAt = "Just now";

    final med = getMedicine(sched.medicineId);
    if (med != null && med.currentStock > 0) {
      med.currentStock -= 1;
    }

    intakeLogs.insert(
      0,
      IntakeLog(
        id: "log-${DateTime.now().millisecondsSinceEpoch}",
        medicineName: med != null ? "${med.brandName} ${med.dosage}" : "Medication",
        scheduledTime: "Today, ${sched.timeString}",
        recordedTime: "Today, Just now",
        status: "TAKEN_ON_TIME",
        shelfSlot: med?.shelfSlot ?? "Shelf 1",
      ),
    );

    notifyListeners();
  }

  /// Updates the signed-in user's profile and notifies listeners.
  void saveUserProfile({required String name, required String email}) {
    userName = name;
    userEmail = email;
    notifyListeners();
  }

  /// Appends a new schedule and notifies listeners.
  void addSchedule(Schedule schedule) {
    schedules.add(schedule);
    notifyListeners();
  }

  void addMedicine(Medicine med) {
    medicines.add(med);
    notifyListeners();
  }

  void toggleDoor() {
    hardware.isDoorOpen = !hardware.isDoorOpen;
    if (hardware.isDoorOpen) {
      notifications.insert(
        0,
        NotificationItem(
          id: "notif-${DateTime.now().millisecondsSinceEpoch}",
          title: "Cabinet Door Opened",
          message: "Physical access detected on MediCab unit ${hardware.cabinetId}.",
          type: NotificationType.info,
          time: "Just now",
        ),
      );
    }
    notifyListeners();
  }

  void toggleChildLock() {
    hardware.isChildLockEngaged = !hardware.isChildLockEngaged;
    final shelfIndex = shelves.indexWhere((s) => s.id == "shelf-3");
    if (shelfIndex != -1) {
      shelves[shelfIndex].isLocked = hardware.isChildLockEngaged;
    }
    notifyListeners();
  }

  void setTemperature(double temp) {
    hardware.temperatureC = temp;
    if (temp > 25.0) {
      notifications.insert(
        0,
        NotificationItem(
          id: "notif-${DateTime.now().millisecondsSinceEpoch}",
          title: "High Temperature Warning!",
          message: "Cabinet internal temperature reached ${temp.toStringAsFixed(1)}°C.",
          type: NotificationType.warning,
          time: "Just now",
        ),
      );
    }
    notifyListeners();
  }
}
