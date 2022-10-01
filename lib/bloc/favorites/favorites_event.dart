import 'package:equatable/equatable.dart';

import '../../models/todo.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

class FavoritesSubscriptionRequested extends FavoritesEvent {
  const FavoritesSubscriptionRequested();

  @override
  List<Object?> get props => [];
}

// TODO: we could make a common ancestor for the next two if more features come in

class TodosSavedToFavorites extends FavoritesEvent {
  const TodosSavedToFavorites({required this.todos});

  final List<Todo> todos;

  @override
  List<Object> get props => [todos];
}

class TodosDeletedFromFavorites extends FavoritesEvent {
  const TodosDeletedFromFavorites({required this.todos});

  final List<Todo> todos;

  @override
  List<Object> get props => [todos];
}