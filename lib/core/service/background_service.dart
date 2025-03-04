// import 'dart:async';
// import 'dart:developer';
// import 'dart:ui';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';

// import 'local_notifications.dart';
 
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   WidgetsFlutterBinding.ensureInitialized();

//   final notificationService = NotificationService();
//   await notificationService.init(
//       createChannel: true); // Create notification channel
//   if (kDebugMode) {
//     if (service is AndroidServiceInstance) {
//       service.setForegroundNotificationInfo(
//         title: "Qubic AI",
//         content: "Welcome to Qubic AI",
//       );
//     }
//   }

//   Timer.periodic(const Duration(minutes: 15), (timer) async {
//     try {
//       await notificationService.showNotification(
//         id: DateTime.now().millisecondsSinceEpoch % 100000,
//         title: 'Qubic AI Reminder',
//         body:
//             "You can ask Qubic AI about anything ${DateTime.now().toIso8601String()}",
//       );
//       log("Notification shown at ${DateTime.now()}");
//     } catch (err) {
//       log("Error showing notification: $err");
//     }
//   });
// }

// class BackgroundService {
//   static const String serviceId = "qubic_ai_service";

//   static Future<void> initialize() async {
//     final service = FlutterBackgroundService();
//     await service.configure(
//       androidConfiguration: AndroidConfiguration(
//         onStart: onStart,
//         autoStart: true,
//         isForegroundMode: false,
//         // Run as foreground service
//         notificationChannelId: 'qubic_ai_channel',
//         foregroundServiceNotificationId: 888,
//       ),
//       iosConfiguration: IosConfiguration(
//         autoStart: true,
//         onForeground: onStart,
//         onBackground: onIosBackground,
//       ),
//     );
//   }

//   @pragma('vm:entry-point')
//   static Future<bool> onIosBackground(ServiceInstance service) async {
//     WidgetsFlutterBinding.ensureInitialized();
//     DartPluginRegistrant.ensureInitialized();
//     return true;
//   }

//   static Future<void> startService() async {
//     final service = FlutterBackgroundService();
//     if (!await service.isRunning()) {
//       service.startService();
//     }
//   }
// }
