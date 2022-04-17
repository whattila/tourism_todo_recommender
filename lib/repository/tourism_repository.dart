import 'package:tourism_todo_recommender/data/data_client.dart';

import '../data/authenticator.dart';
import '../data/geocoder.dart';
import '../data/todo.dart';
import '../data/user.dart';

/// {@template todos_repository}
/// A repository that handles requests related to our touristic todos app:
/// data acquisition and user handling.
/// {@endtemplate}
class TourismRepository {
  /// {@macro todos_repository}
  const TourismRepository({
    required Authenticator authenticator,
    required DataClient dataClient,
    required Geocoder geocoder
  }) : _authenticator = authenticator,
        _dataClient = dataClient,
        _geocoder = geocoder;

  final Authenticator _authenticator;
  final DataClient _dataClient;
  final Geocoder _geocoder;

  /// Provides a [Stream] of all todos uploaded through the app.
  Stream<List<Todo>> getTodos() => _dataClient.getTodos();

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

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  Stream<User> get user => _authenticator.user;

  /// Returns the current user.
  /// Defaults to [User.empty] if there is no logged-in user.
  User get currentUser => _authenticator.currentUser;

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Email and password combination for signing up/in is so common
  /// that it can be assumed it will remain the method with every auth solution.
  Future<void> signUp({required String email, required String password}) =>
      _authenticator.signUp(email: email, password: password);

  /// Signs in with the provided [email] and [password].
  ///
  /// Email and password combination for signing up/in is so common
  /// that it can be assumed it will remain the method with every auth solution.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) => _authenticator.logInWithEmailAndPassword(email: email, password: password);

  /// Signs out the current user
  Future<void> logOut() => _authenticator.logOut();

  /// Returns the coordinates for a geographical place, or null if no results were found or an error occurred
  Future<Geolocation?> getLocationFromAddress(String address) => _geocoder.getLocationFromAddress(address);
}