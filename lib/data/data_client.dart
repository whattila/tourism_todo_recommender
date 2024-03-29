import 'dart:typed_data';

import 'package:tourism_todo_recommender/models/todo.dart';

import '../models/comment.dart';
import '../models/detailed_search_data.dart';
import '../models/rating.dart';

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

  /// Saves a new or updated rating a user gave to a todo.
  Future<void> addRating(Rating rating);

  /// Provides a [Stream] to the [Rating] of the current user of a todo
  Stream<Rating> getRating(String todoId, String userId);

  /// Provides the [Stream] of the todos with the highest average rating currently.
  Stream<List<Todo>> getTopRatedTodos(int count);

  /// Uploads a new [Comment] for the given todo.
  Future<void> addComment(Comment comment);

  /// Provides a [Stream] of [Comments] of the given [Todo]
  Stream<List<Comment>> getTodoComments(Todo todo);
}

/// Error thrown when a [Todo] with a given id is not found.
class TodoNotFoundException implements Exception {}
