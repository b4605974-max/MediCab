import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import 'home_dashboard_screen.dart';
import 'digital_cabinet_screen.dart';
import 'medicine_schedule_screen.dart';
import 'user_profile_screen.dart';

class IntakeHistoryScreen extends StatefulWidget {
  const IntakeHistoryScreen({super.key});

  @override
  State<IntakeHistoryScreen> createState() => _IntakeHistoryScreenState();
}

class _IntakeHistoryScreenState extends State<IntakeHistoryScreen> {
  final _service = CabinetService();

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
    if (index == 3) return;

    Widget target;
    switch (index) {
      case 0:
        target = const HomeDashboardScreen();
        break;
      case 1:
        target = const DigitalCabinetScreen();
        break;
      case 2:
        target = const MedicineScheduleScreen();
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
        title: const Text("Intake History", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Adherence Score Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "30-DAY ADHERENCE RATE",
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryFixed,
                          letterSpacing: 0.6,
                        ),
                      ),
                      Icon(Icons.insights, color: Colors.white70, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "96.4%",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "28 out of 29 scheduled doses taken on time. Streak: ${_service.streakDays} Days 🔥",
                    style: const TextStyle(fontSize: 12, color: AppColors.onPrimaryContainer),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Log Records Header
            const Text(
              "Recent Intake Records",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Log Items
            ..._service.intakeLogs.map((log) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceContainer),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.done_all, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            log.medicineName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Logged at ${log.recordedTime} • ${log.shelfSlot}",
                            style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        "On Time",
                        style: TextStyle(
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
        selectedIndex: 3,
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

