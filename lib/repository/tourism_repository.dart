import 'package:tourism_todo_recommender/data/data_client.dart';
import 'package:tourism_todo_recommender/data/device_services.dart';
import 'package:tourism_todo_recommender/models/detailed_search_data.dart';
import '../data/authenticator.dart';
import '../data/geocoder.dart';
import '../models/geolocation.dart';
import '../models/todo.dart';
import '../../models/user.dart';

/// {@template todos_repository}
/// A repository that transmits services of the DL to the BL, while also masking the former:
/// data acquisition, user handling, geocoding and anything we add later.
/// {@endtemplate}
class TourismRepository {
  /// {@macro todos_repository}
  const TourismRepository({
    required Authenticator authenticator,
    required DataClient dataClient,
    required Geocoder geocoder,
    required DeviceServices deviceServices
  }) : _authenticator = authenticator,
        _dataClient = dataClient,
        _geocoder = geocoder,
        _deviceServices = deviceServices;

  final Authenticator _authenticator;
  final DataClient _dataClient;
  final Geocoder _geocoder;
  final DeviceServices _deviceServices;

  Stream<List<Todo>> getOwnTodos(String userId) => _dataClient.getOwnTodos(userId);

  Future<List<Todo>> searchTodos(String searchTerm) => _dataClient.searchTodos(searchTerm);

  Future<List<Todo>> searchTodosInDetail(DetailedSearchData searchData) => _dataClient.searchTodosInDetail(searchData);

  Stream<List<Todo>> getSavedTodos(String userId) => _dataClient.getSavedTodos(userId);

  Future<void> uploadTodo(Todo todo) => _dataClient.uploadTodo(todo);

  Future<void> saveTodosToFavorites(List<String> ids) => _dataClient.saveTodosToFavorites(ids);

  Future<void> deleteTodosFromFavorites(List<String> ids) => _dataClient.deleteTodosFromFavorites(ids);

  Stream<User> get user => _authenticator.user;

  User get currentUser => _authenticator.currentUser;

  Future<void> signUp({required String email, required String password}) =>
      _authenticator.signUp(email: email, password: password);

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) => _authenticator.logInWithEmailAndPassword(email: email, password: password);

  Future<void> logOut() => _authenticator.logOut();

  Future<Geolocation?> getLocationFromAddress(String address) => _geocoder.getLocationFromAddress(address);

  Future<Geolocation> getDeviceLocation() => _deviceServices.getDeviceLocation();
}