import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/cabinet_service.dart';
import '../models/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _service = CabinetService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text("Notifications", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _service.notifications) {
                  n.isRead = true;
                }
              });
            },
            child: const Text("Mark All Read"),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _service.notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (ctx, idx) {
          final notif = _service.notifications[idx];
          Color iconBg = AppColors.secondaryContainer;
          Color iconColor = AppColors.primary;
          IconData iconData = Icons.info_outline;

          if (notif.type == NotificationType.warning) {
            iconBg = AppColors.criticalCoralLight;
            iconColor = AppColors.error;
            iconData = Icons.warning_amber_rounded;
          } else if (notif.type == NotificationType.expiry) {
            iconBg = AppColors.warningAmberLight;
            iconColor = AppColors.tertiary;
            iconData = Icons.event_busy;
          } else if (notif.type == NotificationType.system) {
            iconBg = AppColors.surfaceContainer;
            iconColor = AppColors.secondary;
            iconData = Icons.sync;
          }

          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: notif.isRead
                  ? AppColors.surfaceContainerLowest
                  : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: notif.isRead ? AppColors.surfaceContainer : AppColors.secondaryContainer,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(iconData, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notif.title,
                              style: TextStyle(
                                fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            notif.time,
                            style: const TextStyle(fontSize: 10, color: AppColors.outline),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif.message,
                        style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

