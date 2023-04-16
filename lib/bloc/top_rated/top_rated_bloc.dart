import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  TopRatedBloc({
    required TourismRepository tourismRepository,
  })  : _tourismRepository = tourismRepository,
        super(const TopRatedState()) {
    on<TopRatedSubscriptionRequested>(_onSubscriptionRequested);
  }

  /// The number of todos we display on the top-rated todos page
  static const topRatedTodosCount = 10;

  final TourismRepository _tourismRepository;

  Future<void> _onSubscriptionRequested(TopRatedSubscriptionRequested event, Emitter<TopRatedState> emit,) async {
    emit(state.copyWith(status: TopRatedStatus.loading));
    await emit.forEach<List<Todo>>(
      _tourismRepository.getTopRatedTodos(topRatedTodosCount),
      onData: (todos) => state.copyWith(
        status: TopRatedStatus.success,
        todos: todos,
      ),
      onError: (_, __) => state.copyWith(
        status: TopRatedStatus.failure,
      ),
    );
  }
}
