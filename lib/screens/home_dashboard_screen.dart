import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import '../models/schedule.dart';
import 'digital_cabinet_screen.dart';
import 'compartment_details_screen.dart';
import 'medicine_schedule_screen.dart';
import 'intake_history_screen.dart';
import 'notifications_screen.dart';
import 'user_profile_screen.dart';
import 'add_edit_medicine_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  final _service = CabinetService();
  final int _currentNavIndex = 0;

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
    if (index == _currentNavIndex) return;

    Widget target;
    switch (index) {
      case 1:
        target = const DigitalCabinetScreen();
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
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => target,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nextSched = _service.nextDueSchedule;
    final nextMed = nextSched != null ? _service.getMedicine(nextSched.medicineId) : null;
    final totalTaken = _service.schedules.where((s) => s.status == ScheduleStatus.taken).length;
    final totalSched = _service.schedules.length;
    final adherencePercent = totalSched > 0 ? ((totalTaken / totalSched) * 100).toInt() : 0;

    final lowStockMeds = _service.medicines.where((m) => m.isLowStock).toList();
    final expiringMeds = _service.medicines.where((m) => m.isExpiringSoon).toList();
    final totalAttentionCount = lowStockMeds.length + expiringMeds.length;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface.withOpacity(0.9),
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.medication, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "MEDICAB",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  "Home",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 18),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.onSurfaceVariant),
                if (_service.notifications.any((n) => !n.isRead))
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.secondaryContainer,
              child: Icon(Icons.person, size: 18, color: AppColors.primary),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting & Status Strip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TODAY",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                    ),
                    Text(
                      "Hello, ${_service.userName}",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 22),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        "CABINET SYNCED",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSecondaryContainer,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Next Scheduled Dose Focus Card
            if (nextSched != null && nextMed != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceContainer),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: nextSched.status == ScheduleStatus.taken
                                ? AppColors.secondaryContainer
                                : AppColors.tertiaryFixed,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                nextSched.status == ScheduleStatus.taken
                                    ? Icons.check_circle
                                    : Icons.timer,
                                size: 14,
                                color: nextSched.status == ScheduleStatus.taken
                                    ? AppColors.primary
                                    : AppColors.tertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                nextSched.status == ScheduleStatus.taken
                                    ? "Completed at ${nextSched.takenAt}"
                                    : "Due: ${nextSched.timeString}",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: nextSched.status == ScheduleStatus.taken
                                      ? AppColors.onSecondaryContainer
                                      : AppColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.shelves, size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              nextMed.shelfSlot,
                              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.medication, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "${nextMed.brandName} ${nextMed.dosage}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceContainer,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      nextMed.form,
                                      style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                nextSched.dosageDisplay,
                                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (nextSched.status != ScheduleStatus.taken)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _service.markDoseTaken(nextSched.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Logged ${nextMed.brandName} as Taken!"),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.check_circle, size: 18),
                              label: const Text("Mark as Taken"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filledTonal(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Reminder snoozed for 15 minutes.")),
                              );
                            },
                            icon: const Icon(Icons.snooze, size: 20),
                          ),
                        ],
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "✓ Recorded in Adherence Log",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Quick Stats Row
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL STOCK",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.primary),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${_service.medicines.length}",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Medicines in cabinet",
                          style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "TODAY'S DOSES",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              "$adherencePercent%",
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "$totalTaken/$totalSched",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Doses logged today",
                          style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cabinet Attention Alerts (Dynamic from _service.medicines)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: totalAttentionCount > 0 ? AppColors.warningAmberLight : AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            totalAttentionCount > 0 ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                            size: 18,
                            color: totalAttentionCount > 0 ? AppColors.tertiary : AppColors.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            totalAttentionCount > 0 ? "Cabinet Attention ($totalAttentionCount)" : "Cabinet Inventory Normal",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: totalAttentionCount > 0 ? AppColors.tertiary : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const DigitalCabinetScreen()),
                          );
                        },
                        child: Text(
                          "Review All",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: totalAttentionCount > 0 ? AppColors.tertiary : AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (totalAttentionCount == 0)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "All prescription items are in healthy supply.",
                        style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                    )
                  else ...[
                    ...lowStockMeds.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${m.brandName} ${m.dosage}", style: const TextStyle(fontSize: 12)),
                              Text(
                                "${m.currentStock} left",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        )),
                    ...expiringMeds.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${m.brandName} ${m.dosage}", style: const TextStyle(fontSize: 12)),
                              Text(
                                "Expires in ${m.daysUntilExpiry}d",
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.tertiary,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Physical Cabinet Layout Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.inventory_2, color: AppColors.primary, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Cabinet Layout",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DigitalCabinetScreen()),
                    );
                  },
                  child: const Text(
                    "Manage Shelves",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Shelves List (with navigation to CompartmentDetailsScreen)
            ..._service.shelves.map((shelf) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CompartmentDetailsScreen(shelf: shelf)),
                  );
                },
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.surfaceContainer),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: shelf.isLocked
                              ? AppColors.surfaceContainer
                              : AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          shelf.isLocked ? Icons.lock : Icons.medical_services,
                          color: shelf.isLocked ? AppColors.outline : AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shelf.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              "${shelf.subtitle} • ${shelf.temperatureC}°C",
                              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: AppColors.outlineVariant, size: 20),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // Adherence Motivation Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryFixed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_fire_department, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Adherence Streak: ${_service.streakDays} Days 🔥",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Great consistency! You haven't missed any scheduled doses this week.",
                          style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // Padding for FAB & Nav
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditMedicineScreen()),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentNavIndex,
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
}
