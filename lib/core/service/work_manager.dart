import 'package:workmanager/workmanager.dart';

import 'local_notifications.dart';

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
    } catch (e) {
      print("Error showing notification: $e");
    }
    return Future.value(true);
  });
}

class WorkManagerService {
  static const String periodicTaskName = "periodicNotificationTask";

  static void initialize() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  static void registerPeriodicNotificationTask() {
    // Cancel existing task before registering new one
    Workmanager().cancelByUniqueName("1");

    Workmanager().registerPeriodicTask(
      "1",
      periodicTaskName,
      frequency: const Duration(minutes: 30),
      initialDelay: const Duration(seconds: 10),
    );
  }
}
