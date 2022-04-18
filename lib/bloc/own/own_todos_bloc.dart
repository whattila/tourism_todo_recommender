import 'package:bloc/bloc.dart';
import '../../data/todo.dart';
import '../../repository/tourism_repository.dart';
import 'own_todos_event.dart';
import 'own_todos_state.dart';

class OwnTodosBloc extends Bloc<OwnTodosEvent, OwnTodosState> {
  OwnTodosBloc({
    required TourismRepository tourismRepository,
  })  : _tourismRepository = tourismRepository,
        super(const OwnTodosState()) {
    on<OwnTodosSubscriptionRequested>(_onSubscriptionRequested);
  }

  final TourismRepository _tourismRepository;

  Future<void> _onSubscriptionRequested(
      OwnTodosSubscriptionRequested event,
      Emitter<OwnTodosState> emit,
      ) async {
    emit(state.copyWith(status: () => OwnTodosStatus.loading));
    await emit.forEach<List<Todo>>(
      _tourismRepository.getOwnTodos(_tourismRepository.currentUser.id),
      onData: (todos) => state.copyWith(
        status: () => OwnTodosStatus.success,
        todos: () => todos,
      ),
      onError: (_, __) => state.copyWith(
        status: () => OwnTodosStatus.failure,
      ),
    );
  }
}
