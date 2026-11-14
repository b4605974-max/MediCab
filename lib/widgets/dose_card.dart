import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/schedule.dart';
import '../models/medicine.dart';

class DoseCard extends StatelessWidget {
  final Schedule schedule;
  final Medicine? medicine;
  final VoidCallback onTake;
  final VoidCallback onSnooze;

  const DoseCard({
    super.key,
    required this.schedule,
    required this.medicine,
    required this.onTake,
    required this.onSnooze,
  });

  @override
  Widget build(BuildContext context) {
    final isTaken = schedule.status == ScheduleStatus.taken;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceContainer),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
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
                  color: isTaken ? AppColors.secondaryContainer : AppColors.tertiaryFixed,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Icon(
                      isTaken ? Icons.check_circle : Icons.timer,
                      size: 14,
                      color: isTaken ? AppColors.primary : AppColors.tertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isTaken ? "Taken at ${schedule.takenAt}" : "Due: ${schedule.timeString}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isTaken ? AppColors.onSecondaryContainer : AppColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (medicine != null)
                Text(
                  medicine!.shelfSlot,
                  style: const TextStyle(fontSize: 11, color: AppColors.outline),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.medication, color: AppColors.primary, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine != null ? "${medicine!.brandName} ${medicine!.dosage}" : "Medication",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      schedule.dosageDisplay,
                      style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (!isTaken)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onTake,
                    icon: const Icon(Icons.check_circle, size: 18),
                    label: const Text("Mark as Taken"),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  onPressed: onSnooze,
                  icon: const Icon(Icons.snooze, size: 20),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "✓ Logged in Adherence Records",
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

