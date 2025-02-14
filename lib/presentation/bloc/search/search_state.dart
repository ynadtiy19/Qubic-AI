part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchResults extends SearchState {
  final String query;
  final List<ChatSession> filteredSessions;

  SearchResults(this.query, this.filteredSessions);
}

class SearchHidden extends SearchState {}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}