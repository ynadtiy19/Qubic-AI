part of 'chat_bloc.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final String response;

  ChatSuccess(this.response);
}

class ChatStreaming extends ChatState {
  final String streamedText;

  ChatStreaming(this.streamedText);
}

class ChatFailure extends ChatState {
  final String error;

  ChatFailure(this.error);
}

class NewChatSessionCreated extends ChatState {
  final int newChatId;

  NewChatSessionCreated(this.newChatId);
}

class ChatSessionDeleted extends ChatState {
  final int chatId;

  ChatSessionDeleted(this.chatId);
}
class ChatListUpdated extends ChatState {}