import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qubic_ai/core/utils/extension/extension.dart';

import '../../core/di/locator.dart';
import '../../core/utils/constants/images.dart';
import '../viewmodel/chat/chat_bloc.dart';
import '../viewmodel/search/search_bloc.dart';
import 'widgets/build_slidable_dismiss.dart';
import 'widgets/empty_body.dart';
import 'widgets/search_field.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final TextEditingController _searchController;
  late final ChatAIBloc _chatAIBloc;
  late final SearchBloc _searchBloc;
  StreamSubscription? _chatSubscription;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _chatAIBloc = getIt<ChatAIBloc>();
    _searchBloc = getIt<SearchBloc>();

    _chatSubscription = _chatAIBloc.stream.listen((state) {
      if (state is ChatListUpdated) {
        _searchBloc.add(SearchQueryChanged(_searchController.text));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _chatSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ChatAIBloc, ChatAIState>(
        bloc: _chatAIBloc,
        builder: (context, chatState) {
          return BlocBuilder<SearchBloc, SearchState>(
            bloc: _searchBloc,
            builder: (context, searchState) {
              final filteredSessions = searchState is SearchResults
                  ? searchState.filteredSessions
                  : _chatAIBloc.getChatSessions();
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: SearchField(
                      searchController: _searchController,
                      searchBloc: _searchBloc,
                    ),
                  ),
                  if (filteredSessions.length <= 1)
                    SliverFillRemaining(
                      child: Center(
                        child: const EmptyBodyCard(
                          title: "No matching chats found",
                          image: ImageManager.history,
                        ).withOnlyPadding(bottom: 10.h),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final session = filteredSessions[index];
                          final chatMessages =
                              _chatAIBloc.getMessages(session.chatId);
                          return SlidableDismissCard(
                            index: index,
                            chatSessions: filteredSessions,
                            chatAIBloc: _chatAIBloc,
                            chatMessages: chatMessages,
                          );
                        },
                        childCount: filteredSessions.length,
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
