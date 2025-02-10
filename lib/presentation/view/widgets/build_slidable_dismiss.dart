import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qubic_ai/core/di/locator.dart';
import 'package:qubic_ai/core/utils/extension/extension.dart';
import '../../../core/utils/constants/colors.dart';
import '../../../core/utils/constants/routes.dart';
import '../../../data/models/hive.dart';
import '../../viewmodel/chat/chat_bloc.dart';
import '../../viewmodel/validation/validation_cubit.dart';

class SlidableDismissCard extends StatelessWidget {
  const SlidableDismissCard({
    super.key,
    required ChatAIBloc chatAIBloc,
    required this.chatMessages,
    required this.index,
    required this.chatSessions,
  }) : _chatAIBloc = chatAIBloc;

  final ChatAIBloc _chatAIBloc;
  final List<Message> chatMessages;
  final int index;
  final List<ChatSession> chatSessions;

  @override
  Widget build(BuildContext context) {
    final session = chatSessions[index];
    return ColoredBox(
      color: ColorManager.dark,
      child: Padding(
        padding: const EdgeInsets.only(top: 1),
        child: Slidable(
          key: ValueKey(session.chatId.toString()),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.33,
            children: [
              SlidableAction(
                onPressed: (_) {
                  _chatAIBloc.add(DeleteChatSessionEvent(session.chatId));
                  chatSessions.removeAt(index);
                },
                backgroundColor: ColorManager.purple,
                autoClose: true,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                foregroundColor: ColorManager.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: chatMessages.lastOrNull?.message != null
              ? Card(
                  color: ColorManager.black,
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  surfaceTintColor: ColorManager.transparent,
                  shape: const BeveledRectangleBorder(),
                  child: ListTile(
                    splashColor: ColorManager.purple,
                    title: Text(
                      chatMessages.last.message,
                      textDirection: getIt<ValidationCubit>().getTextDirection(
                        chatMessages.last.message,
                      ),
                      style: context.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "Started on ${getIt<ValidationCubit>().formatDateTime(session.createdAt)}",
                      style: context.textTheme.bodySmall
                          ?.copyWith(color: ColorManager.grey),
                    ),
                    onTap: () => Navigator.pushNamed(
                      context,
                      RouteManager.chat,
                      arguments: [session.chatId, _chatAIBloc],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
