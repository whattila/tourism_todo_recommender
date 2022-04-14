import 'package:equatable/equatable.dart';

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
