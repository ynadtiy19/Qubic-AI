import 'dart:async';

import 'package:flutter/material.dart';

import '../bloc/chat/chat_bloc.dart';
import '../bloc/search/search_bloc.dart';

class SearchViewModel {
  final TextEditingController searchController;
  final SearchBloc searchBloc;
  final ChatBloc chatAIBloc;
  StreamSubscription? _chatSubscription;

  SearchViewModel({
    required this.searchController,
    required this.searchBloc,
    required this.chatAIBloc,
  }) {
    _chatSubscription = chatAIBloc.stream.listen((state) {
      if (state is ChatListUpdated) {
        searchBloc.add(SearchQueryChanged(searchController.text));
      }
    });
  }

  void handleSearchChange(String value) {
    searchBloc.add(SearchQueryChanged(value.trim()));
  }

  // void handleSearchChange(String value) {
  //   if (_debounce?.isActive ?? false) _debounce?.cancel();
  //   _debounce = Timer(const Duration(milliseconds: 500), () {
  //     searchBloc.add(SearchQueryChanged(value.trim()));
  //   });
  // }

  void clearSearch() {
    searchController.clear();
    searchBloc.add(SearchQueryChanged(''));
  }

  void dispose() {
    searchController.dispose();
    _chatSubscription?.cancel();
    _debounce?.cancel();
  }

  Timer? _debounce;
}
