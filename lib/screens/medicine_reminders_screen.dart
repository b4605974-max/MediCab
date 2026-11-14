import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import '../models/schedule.dart';

class MedicineRemindersScreen extends StatefulWidget {
  const MedicineRemindersScreen({super.key});

  @override
  State<MedicineRemindersScreen> createState() => _MedicineRemindersScreenState();
}

class _MedicineRemindersScreenState extends State<MedicineRemindersScreen> {
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

  @override
  Widget build(BuildContext context) {
    final dueSchedules = _service.schedules.where((s) => s.status == ScheduleStatus.due).toList();
    final upcomingSchedules = _service.schedules.where((s) => s.status == ScheduleStatus.upcoming).toList();
    final takenSchedules = _service.schedules.where((s) => s.status == ScheduleStatus.taken).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text("Medicine Reminders", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Due Right Now Section
            if (dueSchedules.isNotEmpty) ...[
              const Row(
                children: [
                  Icon(Icons.alarm_on, color: AppColors.warningAmber, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "DUE RIGHT NOW",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.tertiary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...dueSchedules.map((sched) => _buildReminderCard(sched, isDue: true)),
              const SizedBox(height: 20),
            ],

            // Upcoming Today
            const Row(
              children: [
                Icon(Icons.schedule, color: AppColors.primary, size: 18),
                SizedBox(width: 8),
                Text(
                  "UPCOMING TODAY",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (upcomingSchedules.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("No more upcoming doses scheduled for today.", style: TextStyle(fontSize: 12)),
              )
            else
              ...upcomingSchedules.map((sched) => _buildReminderCard(sched, isDue: false)),
            const SizedBox(height: 24),

            // Already Taken Today
            const Row(
              children: [
                Icon(Icons.check_circle_outline, color: AppColors.secondary, size: 18),
                SizedBox(width: 8),
                Text(
                  "ALREADY LOGGED TODAY",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.outline,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...takenSchedules.map((sched) {
              final med = _service.getMedicine(sched.medicineId);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.surfaceContainer),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med != null ? "${med.brandName} ${med.dosage}" : "Medicine",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              "Scheduled: ${sched.timeString}",
                              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      "Taken at ${sched.takenAt ?? ''}",
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
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

  Widget _buildReminderCard(Schedule sched, {required bool isDue}) {
    final med = _service.getMedicine(sched.medicineId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDue ? AppColors.warningAmber : AppColors.surfaceContainer,
          width: isDue ? 1.5 : 1,
        ),
        boxShadow: [
          if (isDue)
            BoxShadow(
              color: AppColors.warningAmber.withOpacity(0.08),
              blurRadius: 12,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDue ? AppColors.warningAmberLight : AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  isDue ? "DUE NOW • ${sched.timeString}" : "TODAY • ${sched.timeString}",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDue ? AppColors.tertiary : AppColors.primary,
                  ),
                ),
              ),
              if (med != null)
                Text(
                  med.shelfSlot,
                  style: const TextStyle(fontSize: 11, color: AppColors.outline),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            med != null ? "${med.brandName} ${med.dosage}" : "Medicine",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            sched.dosageDisplay,
            style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _service.markDoseTaken(sched.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Logged ${med?.brandName ?? 'dose'} as Taken!"),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text("Mark as Taken"),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Reminder snoozed for 15 minutes.")),
                  );
                },
                child: const Text("Snooze"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

