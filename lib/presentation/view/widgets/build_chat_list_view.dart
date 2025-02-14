import 'package:flutter/material.dart';

import '../../../data/models/hive.dart';
import '../../bloc/chat/chat_bloc.dart';
import 'ai_chat_bubble.dart';
import 'user_chat_bubble.dart';

class BuildChatListViewBuilder extends StatelessWidget {
  const BuildChatListViewBuilder({
    super.key,
    required ScrollController scrollController,
    required this.messagesLength,
    required this.prompt,
    required this.messages,
    required this.state,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final int messagesLength;
  final String prompt;
  final List<Message> messages;
  final ChatState state;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: ValueKey(messagesLength),
      controller: _scrollController,
      reverse: true,
      itemCount: messagesLength,
      itemBuilder: (context, index) {
        if (state is ChatStreaming && index == 0) {
          return AIBubble(
            message: prompt.trim(),
            time: DateTime.now().toString(),
          );
        } else {
          final adjustedIndex = state is ChatStreaming ? index - 1 : index;
          final message = messages[adjustedIndex];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: message.isUser
                ? UserBubble(
                    message: message.message.trim(),
                    time: message.timestamp,
                    image: message.image,
                  )
                : AIBubble(
                    message: message.message.trim(),
                    time: message.timestamp,
                  ),
          );
        }
      },
    );
  }
}
