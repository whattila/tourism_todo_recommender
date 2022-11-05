import 'dart:typed_data';

import 'package:tourism_todo_recommender/models/todo.dart';

import '../models/detailed_search_data.dart';

/// {@template data_client}
/// The interface for an API that provides access to the data a logged-in user works with (e.g. uploaded todos).
/// It is abstract so it can be mocked for testing.
/// {@endtemplate}
abstract class DataClient {
  /// {@macro data_client}
  const DataClient();

  /// Provides a [Stream] of all todos uploaded through the app.
  Stream<List<Todo>> getOwnTodos(String userId);

  /// Fetches a [List] of Todos fitting for a search term.
  Future<List<Todo>> searchTodos(String searchTerm);

  /// Fetches a [List] of Todos fitting for the list of conditions specified in a DetailedSearchData object
  Future<List<Todo>> searchTodosInDetail(DetailedSearchData searchData);

  /// Provides the [Stream] of todos the user saved.
  Stream<List<Todo>> getFavoriteTodos(String userId);

  /// Uploads a [Todo] to the central database.
  Future<void> uploadTodo(Todo todo, {List<Uint8List> imagesToUpload = const[], List<String> remainingImages = const []});

  // TODO: ennél a kettőnél lehet hogy Future<int> kellene a mentett/törölt elemek számával?

  /// Saves a [List] of todos to the logged-in users favorites.
  ///
  /// If no todo exists with one of the ids, a [TodoNotFoundException] error is
  /// thrown.
  Future<void> saveTodosToFavorites(List<String> ids, String userId);

  /// Deletes a [List] of todos from the logged-in users favorites.
  ///
  /// If no todo exists with one of the ids, a [TodoNotFoundException] error is
  /// thrown.
  Future<void> deleteTodosFromFavorites(List<String> ids, String userId);
}

/// Error thrown when a [Todo] with a given id is not found.
class TodoNotFoundException implements Exception {}
