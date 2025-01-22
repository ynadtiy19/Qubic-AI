import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../core/di/get_it.dart';
import 'app.dart';
import 'core/notifications/local_notifications.dart';
import 'core/utils/constants/colors.dart';
import 'data/services/database/hive_service.dart';

Future<void> main() async {
  FlutterError.onError = (FlutterErrorDetails flutterErrorDetails) {
    FlutterError.dumpErrorToConsole(flutterErrorDetails);
  };

  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await HiveService().initializeDatabase();
  await dotenv.load(fileName: '.env');

  getItSetup();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: ColorManager.black,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}
