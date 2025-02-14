import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:qubic_ai/data/models/hive.dart';
import '../chat/chat_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ChatBloc chatAIBloc;
  SearchBloc(this.chatAIBloc) : super(SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<HideSearch>(_onHideSearch);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(SearchLoading());
      final filteredSessions =
          _filterChatSessions(chatAIBloc.getChatSessions(), event.query);
      emit(SearchResults(event.query.toLowerCase(), filteredSessions));
    } catch (_) {
      emit(SearchError('Error searching chats'));
    }
  }

  void _onHideSearch(HideSearch event, Emitter<SearchState> emit) {
    emit(SearchHidden());
  }

  List<ChatSession> _filterChatSessions(
      List<ChatSession> chatSessions, String query) {
    if (query.isEmpty) return chatSessions;
    final lowerQuery = query.toLowerCase();
    return chatSessions.where((session) {
      final messages =
          chatAIBloc.getMessages(session.chatId); // Get actual messages
      return messages
          .any((message) => message.message.toLowerCase().contains(lowerQuery));
    }).toList();
  }
}
