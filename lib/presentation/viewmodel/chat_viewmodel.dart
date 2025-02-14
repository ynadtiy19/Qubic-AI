
import '../bloc/chat/chat_bloc.dart';

class ChatViewModel {
  final ChatBloc chatBloc;
  bool isLoading = false;
  String prompt = '';

  ChatViewModel({
    required this.chatBloc,
  });
  void sendMessage({
    required String prompt,
    required int chatId,
    String? image,
    String? recognizedText,
  }) {
    chatBloc.add(StreamDataEvent(
      prompt: prompt,
      chatId: chatId,
      isUser: true,
      image: image,
      recognizedText: recognizedText,
    ));
  }

  void createNewChatSession() {
    chatBloc.add(const CreateNewChatSessionEvent());
  }
}
