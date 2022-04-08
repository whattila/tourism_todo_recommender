import 'package:tourism_todo_recommender/data/data_client.dart';

import '../data/todo.dart';

/// {@template todos_repository}
/// A repository that handles requests related to our touristic todos app:
/// data acquisition and user handling.
/// {@endtemplate}
class TourismRepository {
  // TODO: _authenticator inicializálása
  /// {@macro todos_repository}
  const TourismRepository({
    required DataClient dataClient,
  }) : _dataClient = dataClient;

  // TODO: final Authenticator _authenticator;
  final DataClient _dataClient;

  /// Fetches a [List] of Todos fitting for a search term.
  Future<List<Todo>> searchTodos(String searchTerm) => _dataClient.searchTodos(searchTerm);

  /// Provides the [Stream] of todos the user saved.
  Stream<List<Todo>> getSavedTodos(String userId) => _dataClient.getSavedTodos(userId);

  /// Uploads a [Todo] to the central database.
  ///
  /// If a [todo] with the same id already exists, it will be replaced.
  Future<void> uploadTodo(Todo todo) => _dataClient.uploadTodo(todo);

  // TODO: ennél a kettőnél lehet hogy Future<int> kellene a mentett/törölt elemek számával?

  /// Saves a [List] of todos to the logged-in users favorites.
  ///
  /// If no todo exists with one of the ids, a [TodoNotFoundException] error is
  /// thrown.
  Future<void> saveTodosToFavorites(List<String> ids) => _dataClient.saveTodosToFavorites(ids);

  /// Deletes a [List] of todos from the logged-in users favorites.
  ///
  /// If no todo exists with one of the ids, a [TodoNotFoundException] error is
  /// thrown.
  Future<void> deleteTodosFromFavorites(List<String> ids) => _dataClient.deleteTodosFromFavorites(ids);

  // TODO: authenticator metódusai
}