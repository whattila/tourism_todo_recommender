import 'package:equatable/equatable.dart';

import '../../models/todo.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends SearchState {}

class SearchStateLoading extends SearchState {}

class SearchStateSuccess extends SearchState {
  const SearchStateSuccess(this.items);

  final List<Todo> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends SearchState {
  const SearchStateError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}