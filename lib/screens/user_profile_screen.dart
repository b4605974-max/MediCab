import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import 'home_dashboard_screen.dart';
import 'digital_cabinet_screen.dart';
import 'medicine_schedule_screen.dart';
import 'intake_history_screen.dart';
import 'sign_in_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _service = CabinetService();

  void _onBottomNavTapped(int index) {
    if (index == 4) return;

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
      case 3:
        target = const IntakeHistoryScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
          pageBuilder: (_, __, ___) => target,
          transitionDuration: Duration.zero),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text("User Profile",
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // Avatar Card
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.surfaceContainer),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.secondaryContainer,
                    child: Text(
                      _service.userName.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_service.userName,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(_service.userEmail,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.outline)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      "Primary Patient Account",
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Paired Cabinet Hardware Box
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
                  const Row(
                    children: [
                      Icon(Icons.inventory_2,
                          color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Text("Paired MediCab Device",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 20, color: AppColors.surfaceContainer),
                  _buildProfileRow("Hardware Unit", "MediCab Smart Hub v2"),
                  _buildProfileRow(
                      "Serial Number", _service.hardware.cabinetId),
                  _buildProfileRow("Firmware Version", "v2.4.1 (Latest)"),
                  _buildProfileRow("Battery Level",
                      "${_service.hardware.batteryPercent}% Healthy"),
                  _buildProfileRow("Wi-Fi Connection", "Connected (2.4 GHz)"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Caregiver Link
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
                  const Row(
                    children: [
                      Icon(Icons.family_restroom,
                          color: AppColors.primary, size: 18),
                      SizedBox(width: 8),
                      Text("Caregiver Monitoring",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const Divider(height: 20, color: AppColors.surfaceContainer),
                  _buildProfileRow("Caregiver", "Dr. Elena Santos (Physician)"),
                  _buildProfileRow(
                      "Emergency Contact", "Mark Chen (+1 555-0192)"),
                  _buildProfileRow(
                      "Missed Dose Alerts", "Instant SMS & Push Enabled"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Sign Out Button
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SignInScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                side: const BorderSide(color: AppColors.criticalCoralLight),
                foregroundColor: AppColors.error,
              ),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text("Sign Out of Cabinet"),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 4,
        onDestinationSelected: _onBottomNavTapped,
        backgroundColor: AppColors.surface.withOpacity(0.95),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(
              icon: Icon(Icons.inventory_2), label: "Cabinet"),
          NavigationDestination(
              icon: Icon(Icons.event_available), label: "Schedule"),
          NavigationDestination(icon: Icon(Icons.fact_check), label: "History"),
          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.onSurfaceVariant)),
          Text(value,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
