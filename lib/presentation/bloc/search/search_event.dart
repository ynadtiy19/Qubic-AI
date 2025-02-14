part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
}

class HideSearch extends SearchEvent {}