import 'dart:convert';

class CabinetShelf {
  final String id;
  final String name;
  final String subtitle;
  final String iconName;
  final double temperatureC;
  final double weightGrams;
  bool isLocked;
  bool isLedActive;

  CabinetShelf({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.iconName,
    required this.temperatureC,
    this.weightGrams = 420.0,
    this.isLocked = false,
    this.isLedActive = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subtitle': subtitle,
      'iconName': iconName,
      'temperatureC': temperatureC,
      'weightGrams': weightGrams,
      'isLocked': isLocked,
      'isLedActive': isLedActive,
    };
  }

  factory CabinetShelf.fromMap(Map<String, dynamic> map) {
    return CabinetShelf(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      subtitle: map['subtitle'] ?? '',
      iconName: map['iconName'] ?? 'shelves',
      temperatureC: (map['temperatureC'] ?? 21.4).toDouble(),
      weightGrams: (map['weightGrams'] ?? 420.0).toDouble(),
      isLocked: map['isLocked'] ?? false,
      isLedActive: map['isLedActive'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory CabinetShelf.fromJson(String source) => CabinetShelf.fromMap(json.decode(source));
}

class CabinetHardware {
  final String cabinetId;
  final String modelName;
  final String firmwareVersion;
  bool isConnected;
  bool isDoorOpen;
  bool isChildLockEngaged;
  double temperatureC;
  int humidityPercent;
  int batteryPercent;
  int wifiSignalDbm;
  String activeLedShelfId;

  CabinetHardware({
    required this.cabinetId,
    this.modelName = "MediCab Smart Hub v2",
    this.firmwareVersion = "v2.4.1",
    this.isConnected = true,
    this.isDoorOpen = false,
    this.isChildLockEngaged = true,
    this.temperatureC = 21.4,
    this.humidityPercent = 48,
    this.batteryPercent = 94,
    this.wifiSignalDbm = -58,
    this.activeLedShelfId = "shelf-1",
  });

  Map<String, dynamic> toMap() {
    return {
      'cabinetId': cabinetId,
      'modelName': modelName,
      'firmwareVersion': firmwareVersion,
      'isConnected': isConnected,
      'isDoorOpen': isDoorOpen,
      'isChildLockEngaged': isChildLockEngaged,
      'temperatureC': temperatureC,
      'humidityPercent': humidityPercent,
      'batteryPercent': batteryPercent,
      'wifiSignalDbm': wifiSignalDbm,
      'activeLedShelfId': activeLedShelfId,
    };
  }

  factory CabinetHardware.fromMap(Map<String, dynamic> map) {
    return CabinetHardware(
      cabinetId: map['cabinetId'] ?? 'MC-IOT-98214',
      modelName: map['modelName'] ?? 'MediCab Smart Hub v2',
      firmwareVersion: map['firmwareVersion'] ?? 'v2.4.1',
      isConnected: map['isConnected'] ?? true,
      isDoorOpen: map['isDoorOpen'] ?? false,
      isChildLockEngaged: map['isChildLockEngaged'] ?? true,
      temperatureC: (map['temperatureC'] ?? 21.4).toDouble(),
      humidityPercent: map['humidityPercent']?.toInt() ?? 48,
      batteryPercent: map['batteryPercent']?.toInt() ?? 94,
      wifiSignalDbm: map['wifiSignalDbm']?.toInt() ?? -58,
      activeLedShelfId: map['activeLedShelfId'] ?? 'shelf-1',
    );
  }

  String toJson() => json.encode(toMap());

  factory CabinetHardware.fromJson(String source) => CabinetHardware.fromMap(json.decode(source));
}
