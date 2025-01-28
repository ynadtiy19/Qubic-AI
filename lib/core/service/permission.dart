import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Check if notification permission is granted
  Future<bool> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Request notification permission
  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  // Open app settings for manual permission adjustment
  Future<void> openAppSettings() async {
    await openAppSettings();
  }
}
