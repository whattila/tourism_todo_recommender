import 'package:equatable/equatable.dart';

import '../../models/todo.dart';

enum OwnTodosStatus { initial, loading, success, failure }

class OwnTodosState extends Equatable {
  const OwnTodosState({
    this.status = OwnTodosStatus.initial,
    this.todos = const [],
  });

  final OwnTodosStatus status;
  final List<Todo> todos;

  OwnTodosState copyWith({
    OwnTodosStatus Function()? status,
    List<Todo> Function()? todos,
  }) {
    return OwnTodosState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
    );
  }

  @override
  List<Object?> get props => [status, todos];
}
