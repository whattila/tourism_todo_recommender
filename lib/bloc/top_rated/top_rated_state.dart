part of 'top_rated_bloc.dart';

enum TopRatedStatus { initial, loading, success, failure }

class TopRatedState extends Equatable {
  const TopRatedState({
    this.status = TopRatedStatus.initial,
    this.todos = const []
  });

  final TopRatedStatus status;
  final List<Todo> todos;

  TopRatedState copyWith({TopRatedStatus? status, List<Todo>? todos})
    => TopRatedState(status: status ?? this.status, todos: todos ?? this.todos);

  @override
  List<Object?> get props => [status, todos];
}
