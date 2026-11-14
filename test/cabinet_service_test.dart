import 'package:flutter_test/flutter_test.dart';
import 'package:medicab/services/cabinet_service.dart';
import 'package:medicab/models/schedule.dart';
import 'package:medicab/models/medicine.dart';

void main() {
  group('MediCab CabinetService Tests', () {
    late CabinetService service;

    setUp(() {
      service = CabinetService();
      service.resetDefaults();
    });

    test('Initial state contains default shelves and medicines', () {
      expect(service.shelves.length, equals(3));
      expect(service.medicines.isNotEmpty, isTrue);
      expect(service.schedules.isNotEmpty, isTrue);
      expect(service.hardware.isConnected, isTrue);
    });

    test('Marking a dose as taken decrements stock and logs entry', () {
      final dueSched = service.schedules.firstWhere((s) => s.id == 'sched-2');
      final med = service.getMedicine(dueSched.medicineId);
      final initialStock = med!.currentStock;
      final initialLogs = service.intakeLogs.length;

      service.markDoseTaken(dueSched.id);

      expect(dueSched.status, equals(ScheduleStatus.taken));
      expect(med.currentStock, equals(initialStock - 1));
      expect(service.intakeLogs.length, equals(initialLogs + 1));
    });

    test('Toggling cabinet door creates an access notification', () {
      final initialNotifs = service.notifications.length;
      service.toggleDoor();

      expect(service.hardware.isDoorOpen, isTrue);
      expect(service.notifications.length, equals(initialNotifs + 1));
      expect(service.notifications.first.title, contains("Door"));
    });

    test('High temperature spike triggers warning alert', () {
      service.setTemperature(27.5);

      expect(service.hardware.temperatureC, equals(27.5));
      expect(service.notifications.first.title, contains("High Temperature"));
    });

    test('Adding a new prescription updates the medicines inventory', () {
      final initialCount = service.medicines.length;
      final newMed = Medicine(
        id: 'med-test',
        brandName: 'Metformin',
        genericName: 'Metformin HCl',
        dosage: '850mg',
        form: 'Tablet',
        shelfId: 'shelf-1',
        shelfSlot: 'Slot A3',
        totalStock: 60,
        currentStock: 60,
        expiryDate: DateTime.now().add(const Duration(days: 365)),
        instructions: 'Take 1 tablet twice daily with meals',
      );

      service.addMedicine(newMed);

      expect(service.medicines.length, equals(initialCount + 1));
      expect(service.getMedicine('med-test')?.brandName, equals('Metformin'));
    });

    test('Medicine model serializes to and from JSON', () {
      final med = service.medicines.first;
      final jsonStr = med.toJson();
      final revived = Medicine.fromJson(jsonStr);

      expect(revived.id, equals(med.id));
      expect(revived.brandName, equals(med.brandName));
      expect(revived.currentStock, equals(med.currentStock));
    });

    test('nextDueSchedule returns null safely when no schedules exist', () {
      service.schedules.clear();
      expect(service.nextDueSchedule, isNull);
    });
  });
}
