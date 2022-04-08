import 'package:tourism_todo_recommender/data/data_client.dart';
import 'package:tourism_todo_recommender/data/todo.dart';

/// {@template mock_data_client}
/// A Flutter implementation of the [DataClient] that provides mock data while we are making the UI.
/// {@endtemplate}
class MockDataClient extends DataClient {
  @override
  Future<void> deleteTodosFromFavorites(List<String> ids) {
    // TODO: implement deleteTodosFromFavorites
    throw UnimplementedError();
  }

  @override
  Future<void> saveTodosToFavorites(List<String> ids) {
    // TODO: implement saveTodosToFavorites
    throw UnimplementedError();
  }

  @override
  Future<void> uploadTodo(Todo todo) {
    // TODO: implement uploadTodo
    throw UnimplementedError();
  }

  // ha mégis szükség van arra, hogy visszaadjunk valamit,
  // nézzük meg a AUTos tárgy blocos példáját a kereséssel
  // és váltsunk Future-re!
  @override
  Stream<List<Todo>> getSavedTodos(String userId) {
    // TODO: implement getSavedTodos
    throw UnimplementedError();
  }

  @override
  Future<List<Todo>> searchTodos(String searchTerm) {
    // TODO: implement searchTodos
    throw UnimplementedError();
  }
  
}