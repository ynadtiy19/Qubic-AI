import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/locator.dart';
import '../../core/utils/constants/images.dart';
import '../../data/models/hive.dart';
import '../viewmodel/chat/chat_bloc.dart';
import '../viewmodel/search/search_bloc.dart';
import '../viewmodel/validation/validation_cubit.dart';
import 'widgets/build_dismissable.dart';
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
  late final ValidationCubit _validationCubit;
  StreamSubscription? _chatSubscription;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _chatAIBloc = getIt<ChatAIBloc>();
    _searchBloc = getIt<SearchBloc>();
    _validationCubit = getIt<ValidationCubit>();

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
      body: Column(
        children: [
          SearchField(
            searchController: _searchController,
            searchBloc: _searchBloc,
            validationCubit: _validationCubit,
          ),
          Expanded(
            child: BlocBuilder<ChatAIBloc, ChatAIState>(
              bloc: _chatAIBloc,
              builder: (context, state) {
                return BlocBuilder<SearchBloc, SearchState>(
                  bloc: _searchBloc,
                  builder: (context, searchState) {
                    final filteredSessions = searchState is SearchResults
                        ? searchState.filteredSessions
                        : _chatAIBloc.getChatSessions();

                    return _buildContent(filteredSessions);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(List<ChatSession> sessions) {
    if (sessions.isEmpty) {
      return const EmptyBodyCard(
        title: "No matching chats found",
        image: ImageManager.history,
      );
    }

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final chatMessages = _chatAIBloc.getMessages(session.chatId);
        return BuildDismissibleCard(
          index: index,
          chatSessions: sessions,
          session: session,
          chatAIBloc: _chatAIBloc,
          chatMessages: chatMessages,
          validationCubit: _validationCubit,
        );
      },
    );
  }
}
