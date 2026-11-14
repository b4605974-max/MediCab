import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import '../models/cabinet.dart';
import 'add_edit_medicine_screen.dart';

class CompartmentDetailsScreen extends StatefulWidget {
  final CabinetShelf shelf;

  const CompartmentDetailsScreen({super.key, required this.shelf});

  @override
  State<CompartmentDetailsScreen> createState() => _CompartmentDetailsScreenState();
}

class _CompartmentDetailsScreenState extends State<CompartmentDetailsScreen> {
  final _service = CabinetService();

  @override
  Widget build(BuildContext context) {
    final medicinesInShelf = _service.medicines.where((m) => m.shelfId == widget.shelf.id).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(widget.shelf.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditMedicineScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shelf Environmental & Sensor Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.surfaceContainer),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            widget.shelf.isLocked ? Icons.lock : Icons.shelves,
                            color: widget.shelf.isLocked ? AppColors.error : AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.shelf.isLocked ? "Drawer Child Locked" : "Compartment Online",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: widget.shelf.isLocked ? AppColors.error : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "${medicinesInShelf.length} Items",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.shelf.subtitle,
                    style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),

                  // Sensor readings row
                  Row(
                    children: [
                      Expanded(
                        child: _sensorCard(
                          icon: Icons.thermostat,
                          label: "Temp",
                          value: "${widget.shelf.temperatureC}°C",
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _sensorCard(
                          icon: Icons.water_drop,
                          label: "Humidity",
                          value: "${_service.hardware.humidityPercent}% RH",
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _sensorCard(
                          icon: Icons.scale,
                          label: "Load Cell",
                          value: "420g",
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stored Medicines Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stored Medications (${medicinesInShelf.length})",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Shelf load cell calibrated.")),
                    );
                  },
                  icon: const Icon(Icons.tune, size: 16),
                  label: const Text("Calibrate", style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Medicines List
            if (medicinesInShelf.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 36, color: AppColors.outline),
                    SizedBox(height: 8),
                    Text("No medicines stored in this compartment", style: TextStyle(fontSize: 13)),
                  ],
                ),
              )
            else
              ...medicinesInShelf.map((med) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceContainer),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.medication, color: AppColors.primary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${med.brandName} ${med.dosage}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              "${med.shelfSlot} • ${med.instructions}",
                              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 6),
                            // Stock progress bar
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: med.currentStock / med.totalStock,
                                minHeight: 4,
                                backgroundColor: AppColors.surfaceContainer,
                                valueColor: AlwaysStoppedAnimation(
                                  med.isLowStock ? AppColors.error : AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${med.currentStock} left",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: med.isLowStock ? AppColors.error : AppColors.onSurface,
                            ),
                          ),
                          Text(
                            "of ${med.totalStock}",
                            style: const TextStyle(fontSize: 10, color: AppColors.outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sensorCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

