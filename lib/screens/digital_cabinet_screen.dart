import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import '../models/medicine.dart';
import 'home_dashboard_screen.dart';
import 'medicine_schedule_screen.dart';
import 'intake_history_screen.dart';
import 'user_profile_screen.dart';
import 'add_edit_medicine_screen.dart';

class DigitalCabinetScreen extends StatefulWidget {
  const DigitalCabinetScreen({super.key});

  @override
  State<DigitalCabinetScreen> createState() => _DigitalCabinetScreenState();
}

class _DigitalCabinetScreenState extends State<DigitalCabinetScreen> {
  final _service = CabinetService();
  String _selectedShelfId = "all";

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  void _onBottomNavTapped(int index) {
    if (index == 1) return;

    Widget target;
    switch (index) {
      case 0:
        target = const HomeDashboardScreen();
        break;
      case 2:
        target = const MedicineScheduleScreen();
        break;
      case 3:
        target = const IntakeHistoryScreen();
        break;
      case 4:
        target = const UserProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(pageBuilder: (_, __, ___) => target, transitionDuration: Duration.zero),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredMedicines = _selectedShelfId == "all"
        ? _service.medicines
        : _service.medicines.where((m) => m.shelfId == _selectedShelfId).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text("Digital Cabinet", style: TextStyle(fontWeight: FontWeight.bold)),
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
            // Smart Hardware IoT Sensor Panel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.surfaceContainer),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "MediCab Unit MC-IOT-98214",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "${_service.hardware.wifiSignalDbm} dBm",
                        style: const TextStyle(fontSize: 11, color: AppColors.outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Sensor Metrics Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          icon: Icons.thermostat,
                          label: "Temperature",
                          value: "${_service.hardware.temperatureC.toStringAsFixed(1)}°C",
                          color: _service.hardware.temperatureC > 25.0
                              ? AppColors.error
                              : AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricTile(
                          icon: Icons.water_drop,
                          label: "Humidity",
                          value: "${_service.hardware.humidityPercent}% RH",
                          color: AppColors.secondary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildMetricTile(
                          icon: _service.hardware.isDoorOpen ? Icons.door_front_door_outlined : Icons.door_sliding,
                          label: "Door State",
                          value: _service.hardware.isDoorOpen ? "OPEN" : "CLOSED",
                          color: _service.hardware.isDoorOpen ? AppColors.error : AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Interactive Hardware Simulation Controls
                  const Text(
                    "HARDWARE SIMULATOR (IoT Controls)",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.outline,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _service.toggleDoor(),
                          icon: Icon(
                            _service.hardware.isDoorOpen ? Icons.close : Icons.meeting_room,
                            size: 16,
                          ),
                          label: Text(
                            _service.hardware.isDoorOpen ? "Close Door" : "Open Door",
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _service.toggleChildLock(),
                          icon: Icon(
                            _service.hardware.isChildLockEngaged ? Icons.lock : Icons.lock_open,
                            size: 16,
                          ),
                          label: Text(
                            _service.hardware.isChildLockEngaged ? "Unlock Drawer" : "Lock Drawer",
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Shelf Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildShelfChip("all", "All Shelves (${_service.medicines.length})"),
                  const SizedBox(width: 6),
                  _buildShelfChip("shelf-1", "Top Shelf (Daily Rx)"),
                  const SizedBox(width: 6),
                  _buildShelfChip("shelf-2", "Middle Shelf (First Aid)"),
                  const SizedBox(width: 6),
                  _buildShelfChip("shelf-3", "Bottom Drawer 🔒"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Medicine Cards
            ...filteredMedicines.map((med) => _buildMedicineCard(med)),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: _onBottomNavTapped,
        backgroundColor: AppColors.surface.withOpacity(0.95),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.inventory_2), label: "Cabinet"),
          NavigationDestination(icon: Icon(Icons.event_available), label: "Schedule"),
          NavigationDestination(icon: Icon(Icons.fact_check), label: "History"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildShelfChip(String id, String label) {
    final isSelected = _selectedShelfId == id;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => setState(() => _selectedShelfId = id),
      selectedColor: AppColors.secondaryContainer,
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
      ),
    );
  }

  Widget _buildMedicineCard(Medicine med) {
    Color badgeColor = AppColors.secondaryContainer;
    Color badgeTextColor = AppColors.primary;
    String badgeText = "In Stock (${med.currentStock})";

    if (med.isExpiringSoon) {
      badgeColor = AppColors.warningAmberLight;
      badgeTextColor = AppColors.tertiary;
      badgeText = "Expires in ${med.daysUntilExpiry}d";
    } else if (med.isLowStock) {
      badgeColor = AppColors.criticalCoralLight;
      badgeTextColor = AppColors.error;
      badgeText = "Low Stock (${med.currentStock} left)";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.surfaceContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${med.brandName} ${med.dosage}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeColor,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      med.genericName,
                      style: const TextStyle(fontSize: 11, color: AppColors.outline),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      med.instructions,
                      style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shelves, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(med.shelfSlot, style: const TextStyle(fontSize: 11)),
                ],
              ),
              Text(
                "Exp: ${med.expiryDate.year}-${med.expiryDate.month.toString().padLeft(2, '0')}-${med.expiryDate.day.toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 11, color: AppColors.outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

