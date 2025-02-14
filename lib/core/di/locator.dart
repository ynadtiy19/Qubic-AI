import 'package:get_it/get_it.dart';

import '../../data/repositories/message_repository.dart';
import '../../data/source/apis/generative_ai_web_service.dart';
import '../../data/source/database/hive_service.dart';
import '../../presentation/bloc/chat/chat_bloc.dart';
import '../../presentation/bloc/input/input_field_bloc.dart';
import '../../presentation/bloc/search/search_bloc.dart';
import '../service/image_packer.dart';
import '../service/text_recognition.dart';

final getIt = GetIt.instance;

void getItSetup() {
  getIt.registerLazySingleton<GenerativeAIWebService>(
      () => GenerativeAIWebService());
  getIt.registerLazySingleton<HiveService>(() => HiveService());

  getIt.registerLazySingleton<MessageRepository>(() => MessageRepository());

  getIt.registerFactory<ChatBloc>(() => ChatBloc(
        getIt<GenerativeAIWebService>(),
        getIt<MessageRepository>(),
      ));
  getIt
      .registerLazySingleton<SearchBloc>(() => SearchBloc(getIt<ChatBloc>()));

  getIt.registerLazySingleton<ImagePickerService>(() => ImagePickerService());
  getIt.registerLazySingleton<TextRecognitionService>(
      () => TextRecognitionService());

  getIt.registerLazySingleton<InputFieldBloc>(
    () => InputFieldBloc(),
  );
}
