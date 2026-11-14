import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import '../models/schedule.dart';
import 'home_dashboard_screen.dart';
import 'digital_cabinet_screen.dart';
import 'intake_history_screen.dart';
import 'user_profile_screen.dart';

class MedicineScheduleScreen extends StatefulWidget {
  const MedicineScheduleScreen({super.key});

  @override
  State<MedicineScheduleScreen> createState() => _MedicineScheduleScreenState();
}

class _MedicineScheduleScreenState extends State<MedicineScheduleScreen> {
  final _service = CabinetService();
  int _selectedDayIndex = 1; // Tuesday

  final List<Map<String, String>> _days = [
    {"day": "Mon", "date": "23"},
    {"day": "Tue", "date": "24"},
    {"day": "Wed", "date": "25"},
    {"day": "Thu", "date": "26"},
    {"day": "Fri", "date": "27"},
    {"day": "Sat", "date": "28"},
    {"day": "Sun", "date": "29"},
  ];

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
    if (index == 2) return;

    Widget target;
    switch (index) {
      case 0:
        target = const HomeDashboardScreen();
        break;
      case 1:
        target = const DigitalCabinetScreen();
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
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text("Medicine Schedule", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week Calendar Strip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_days.length, (idx) {
                final item = _days[idx];
                final isSelected = idx == _selectedDayIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = idx),
                  child: Container(
                    width: 44,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item["day"]!,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white70 : AppColors.outline,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item["date"]!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Today's Routine Heading
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tuesday, Oct 24 • 4 Doses",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    "All Alarms Active",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Schedule Timeline Items
            ..._service.schedules.map((sched) {
              final med = _service.getMedicine(sched.medicineId);
              final isTaken = sched.status == ScheduleStatus.taken;
              final isDue = sched.status == ScheduleStatus.due;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDue ? AppColors.warningAmber : AppColors.surfaceContainer,
                    width: isDue ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Node Time Bullet
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isTaken
                            ? AppColors.secondaryContainer
                            : isDue
                                ? AppColors.warningAmberLight
                                : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isTaken
                            ? Icons.check_circle
                            : isDue
                                ? Icons.timer
                                : Icons.schedule,
                        color: isTaken
                            ? AppColors.primary
                            : isDue
                                ? AppColors.warningAmber
                                : AppColors.outline,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                sched.timeString,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                "• ${sched.category}",
                                style: const TextStyle(fontSize: 11, color: AppColors.secondary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            med != null ? "${med.brandName} ${med.dosage}" : "Medicine",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          Text(
                            sched.dosageDisplay,
                            style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),

                    // Action / Badge
                    if (!isTaken)
                      ElevatedButton(
                        onPressed: () {
                          _service.markDoseTaken(sched.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Logged dose at ${sched.timeString}!"),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(80, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor: isDue ? AppColors.primary : AppColors.surfaceContainer,
                          foregroundColor: isDue ? Colors.white : AppColors.onSurfaceVariant,
                        ),
                        child: Text(isDue ? "Take" : "Log", style: const TextStyle(fontSize: 12)),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryContainer,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          "Taken ${sched.takenAt ?? ''}",
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 2,
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

