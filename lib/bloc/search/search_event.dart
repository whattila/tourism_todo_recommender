import 'package:equatable/equatable.dart';
import 'package:tourism_todo_recommender/models/detailed_search_data.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchLaunched extends SearchEvent {
  const SearchLaunched({required this.text});

  final String text;

  @override
  List<Object> get props => [text];

  @override
  String toString() => 'SearchLaunched { text: $text }';
}

class SearchFieldCleared extends SearchEvent {
  const SearchFieldCleared();

  @override
  String toString() => 'SearchFieldCleared';

  @override
  List<Object> get props => [];
}

class DetailedSearchLaunched extends SearchEvent {
  const DetailedSearchLaunched({required this.searchData});

  final DetailedSearchData searchData;

  @override
  List<Object> get props => [searchData];
}