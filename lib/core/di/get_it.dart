import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

import '../../data/repositories/message_repository.dart';
import '../../data/services/apis/genetative_ai.dart';
import '../../data/services/database/hive_service.dart';
import '../../presentation/viewmodel/chat/chat_bloc.dart';
import '../../presentation/viewmodel/validation/validation_cubit.dart';
import '../service/permission.dart';

final getIt = GetIt.instance;

void getItSetup() {
  getIt.registerLazySingleton<GenerativeAIWebService>(
      () => GenerativeAIWebService());
  getIt.registerLazySingleton<HiveService>(() => HiveService());

  getIt.registerLazySingleton<MessageRepository>(() => MessageRepository());

  getIt.registerLazySingleton<ValidationCubit>(() => ValidationCubit());
  getIt.registerFactory<ChatAIBloc>(() => ChatAIBloc(
        getIt<GenerativeAIWebService>(),
        getIt<MessageRepository>(),
      ));
  getIt.registerFactory<PermissionService>(() => PermissionService());
  getIt.registerLazySingleton<FlutterLocalNotificationsPlugin>(
      () => FlutterLocalNotificationsPlugin());
}
