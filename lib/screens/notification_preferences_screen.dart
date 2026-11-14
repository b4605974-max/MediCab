import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  bool _cabinetChime = true;
  bool _shelfLedGuide = true;
  bool _mobilePushAlerts = true;
  bool _caregiverSmsAlerts = true;
  bool _lowStockWarning = true;
  bool _expiryAlert30Days = true;
  bool _temperatureAlerts = true;
  double _reminderDelayMins = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text("Notification Preferences", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hardware Cabinet Alerts Section
            _buildSectionHeader("HARDWARE CABINET ALERTS", Icons.inventory_2),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.surfaceContainer),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    value: _shelfLedGuide,
                    title: const Text("Compartment LED Guide", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text("Lights up the active shelf slot at scheduled dose time", style: TextStyle(fontSize: 12)),
                    onChanged: (val) => setState(() => _shelfLedGuide = val),
                  ),
                  const Divider(height: 1, color: AppColors.surfaceContainer),
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    value: _cabinetChime,
                    title: const Text("Physical Cabinet Chime", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text("Audible chime from cabinet speaker when door opens or dose is due", style: TextStyle(fontSize: 12)),
                    onChanged: (val) => setState(() => _cabinetChime = val),
                  ),
                  const Divider(height: 1, color: AppColors.surfaceContainer),
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    value: _temperatureAlerts,
                    title: const Text("Environmental Sensor Alerts", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text("Instant warning if internal temperature exceeds 25°C", style: TextStyle(fontSize: 12)),
                    onChanged: (val) => setState(() => _temperatureAlerts = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Adherence & Caregiver Alerts
            _buildSectionHeader("ADHERENCE & CAREGIVER", Icons.family_restroom),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.surfaceContainer),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    value: _mobilePushAlerts,
                    title: const Text("Mobile Push Reminders", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text("Scheduled notifications on your smartphone", style: TextStyle(fontSize: 12)),
                    onChanged: (val) => setState(() => _mobilePushAlerts = val),
                  ),
                  const Divider(height: 1, color: AppColors.surfaceContainer),
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    value: _caregiverSmsAlerts,
                    title: const Text("Caregiver Escalation", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text("Send SMS to Dr. Elena Santos if dose is missed by >30 mins", style: TextStyle(fontSize: 12)),
                    onChanged: (val) => setState(() => _caregiverSmsAlerts = val),
                  ),
                  const Divider(height: 1, color: AppColors.surfaceContainer),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Snooze Reminder Interval", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                            Text("${_reminderDelayMins.toInt()} mins", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                        Slider(
                          value: _reminderDelayMins,
                          min: 5,
                          max: 60,
                          divisions: 11,
                          activeColor: AppColors.primary,
                          onChanged: (val) => setState(() => _reminderDelayMins = val),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stock & Expiration Warnings
            _buildSectionHeader("INVENTORY & EXPIRY", Icons.notifications_active),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.surfaceContainer),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    value: _lowStockWarning,
                    title: const Text("Low Stock Warnings", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text("Notify when remaining capsules drop to 5 or fewer", style: TextStyle(fontSize: 12)),
                    onChanged: (val) => setState(() => _lowStockWarning = val),
                  ),
                  const Divider(height: 1, color: AppColors.surfaceContainer),
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    value: _expiryAlert30Days,
                    title: const Text("30-Day Expiry Notice", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    subtitle: const Text("Warm amber notification 30 days before medication expiry", style: TextStyle(fontSize: 12)),
                    onChanged: (val) => setState(() => _expiryAlert30Days = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Notification preferences saved!"),
                    backgroundColor: AppColors.primary,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("Save Preferences"),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.outline,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

