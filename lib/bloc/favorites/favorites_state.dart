import 'package:equatable/equatable.dart';
import '../../models/todo.dart';

enum FavoritesStatus { initial, loading, success, failure }

class FavoritesState extends Equatable {
  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.favorites = const [],
  });

  final FavoritesStatus status;
  final List<Todo> favorites;

  bool isTodoFavorite(Todo todo) => favorites.any((element) => element.id == todo.id);

  FavoritesState copyWith({
    FavoritesStatus Function()? status,
    List<Todo> Function()? favorites,
  }) {
    return FavoritesState(
      status: status != null ? status() : this.status,
      favorites: favorites != null ? favorites() : this.favorites,
    );
  }

  @override
  List<Object?> get props => [status, favorites];
}
