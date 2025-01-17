import 'package:hive_flutter/hive_flutter.dart';

import '../../model/hive.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() {
    return _instance;
  }

  HiveService._internal();

  Future<void> initializeDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(ChatSessionAdapter());

    await Hive.openBox<Message>('messages');
    await Hive.openBox<ChatSession>('chat_sessions');
  }

  Future<void> deleteAndRecreateDatabase() async {
    await Hive.close();
    await Hive.deleteBoxFromDisk('messages');
    await Hive.deleteBoxFromDisk('chat_sessions');

    await initializeDatabase();
  }
}
