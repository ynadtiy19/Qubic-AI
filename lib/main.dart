import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/locator.dart';
import 'app.dart';
import 'core/service/local_notifications.dart';
import 'core/service/permission.dart';
import 'core/service/background_service.dart';
import 'core/utils/constants/colors.dart';
import 'data/source/database/hive_service.dart';

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails flutterErrorDetails) {
    FlutterError.dumpErrorToConsole(flutterErrorDetails);
  };

  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().initializeDatabase();
  await dotenv.load(fileName: '.env');
  getItSetup();
  await PermissionService().requestNotificationPermission();
  await NotificationService().init();
    await BackgroundService.initialize();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: ColorManager.black,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

