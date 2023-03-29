import 'package:bloc/bloc.dart';

import '../../models/todo.dart';
import '../../repository/tourism_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc({
    required TourismRepository tourismRepository,
  })  : _tourismRepository = tourismRepository,
        super(const FavoritesState()) {
          on<FavoritesSubscriptionRequested>(_onSubscriptionRequested);
          on<TodosSavedToFavorites>(_onTodosSaved);
          on<TodosDeletedFromFavorites>(_onTodosDeleted);
        }

  final TourismRepository _tourismRepository;

  Future<void> _onSubscriptionRequested(
      FavoritesSubscriptionRequested event,
      Emitter<FavoritesState> emit,
      ) async {
    emit(state.copyWith(status: () => FavoritesStatus.loading));
    await emit.forEach<List<Todo>>(
      _tourismRepository.getFavoriteTodos(_tourismRepository.currentUser.id),
      onData: (favorites) => state.copyWith(
        status: () => FavoritesStatus.success,
        favorites: () => favorites,
      ),
      onError: (_, __) => state.copyWith(
        status: () => FavoritesStatus.failure,
      ),
    );
  }

  Future<void> _onTodosSaved(
      TodosSavedToFavorites event,
      Emitter<FavoritesState> emit,
      ) async {
    final List<String> ids = [];
    for (final todo in event.todos) {
      ids.add(todo.id);
    }
    try {
      await _tourismRepository.saveTodosToFavorites(ids, _tourismRepository.currentUser.id);
    } catch (_) {
      // TODO: what do we do here?
    }
  }

  Future<void> _onTodosDeleted(
      TodosDeletedFromFavorites event,
      Emitter<FavoritesState> emit,
      ) async {
    final List<String> ids = [];
    for (final todo in event.todos) {
      ids.add(todo.id);
    }
    try {
      await _tourismRepository.deleteTodosFromFavorites(ids, _tourismRepository.currentUser.id);
    } catch (_) {
      // TODO: what do we do here?
    }
  }
}