import 'dart:convert';

class Medicine {
  final String id;
  final String brandName;
  final String genericName;
  final String dosage;
  final String form; // Capsule, Tablet, Spray, Liquid Syrup
  final String shelfId;
  final String shelfSlot;
  final int totalStock;
  int currentStock;
  final DateTime expiryDate;
  final String instructions;
  final String? prescribedBy;
  final List<String> tags;
  final String? imageUrl;
  final double bottleWeightGrams; // Weight sensor telemetry

  Medicine({
    required this.id,
    required this.brandName,
    required this.genericName,
    required this.dosage,
    required this.form,
    required this.shelfId,
    required this.shelfSlot,
    required this.totalStock,
    required this.currentStock,
    required this.expiryDate,
    required this.instructions,
    this.prescribedBy,
    this.tags = const [],
    this.imageUrl,
    this.bottleWeightGrams = 85.0,
  });

  bool get isLowStock => currentStock <= 5;

  bool get isExpiringSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry >= 0;
  }

  bool get isExpired => expiryDate.isBefore(DateTime.now());

  int get daysUntilExpiry => expiryDate.difference(DateTime.now()).inDays;

  double get stockPercentage => totalStock > 0 ? (currentStock / totalStock).clamp(0.0, 1.0) : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brandName': brandName,
      'genericName': genericName,
      'dosage': dosage,
      'form': form,
      'shelfId': shelfId,
      'shelfSlot': shelfSlot,
      'totalStock': totalStock,
      'currentStock': currentStock,
      'expiryDate': expiryDate.toIso8601String(),
      'instructions': instructions,
      'prescribedBy': prescribedBy,
      'tags': tags,
      'imageUrl': imageUrl,
      'bottleWeightGrams': bottleWeightGrams,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] ?? '',
      brandName: map['brandName'] ?? '',
      genericName: map['genericName'] ?? '',
      dosage: map['dosage'] ?? '',
      form: map['form'] ?? 'Capsule',
      shelfId: map['shelfId'] ?? 'shelf-1',
      shelfSlot: map['shelfSlot'] ?? 'Slot A1',
      totalStock: map['totalStock']?.toInt() ?? 30,
      currentStock: map['currentStock']?.toInt() ?? 30,
      expiryDate: DateTime.tryParse(map['expiryDate'] ?? '') ?? DateTime.now().add(const Duration(days: 365)),
      instructions: map['instructions'] ?? '',
      prescribedBy: map['prescribedBy'],
      tags: List<String>.from(map['tags'] ?? []),
      imageUrl: map['imageUrl'],
      bottleWeightGrams: (map['bottleWeightGrams'] ?? 85.0).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Medicine.fromJson(String source) => Medicine.fromMap(json.decode(source));
}
