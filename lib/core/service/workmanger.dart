import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import 'local_notifications.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final notificationService = NotificationService();
    try {
      // Initialize notifications (skip channel creation in background)
      await notificationService.init(createChannel: false);
      await notificationService.showNotification(
        id: 1,
        title: 'Qubic AI Reminder',
        body: "You can ask Qubic AI about anything",
      );
    } catch (err) {
      debugPrint("Error showing notification: $err");
    }
    return Future.value(true);
  });
}

class WorkManagerService {
  static const String periodicTaskName = "periodicNotificationTask";

  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static void registerPeriodicNotificationTask() {
    // // Cancel existing task before registering new one
    // Workmanager().cancelByUniqueName("1");

    Workmanager().registerPeriodicTask(
      "1",
      periodicTaskName,
      frequency: const Duration(hours: 8),
      initialDelay: const Duration(seconds: 10),
    );
  }
}
