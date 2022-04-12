import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourism_todo_recommender/data/data_client.dart';
import 'package:tourism_todo_recommender/data/todo.dart';

class FirebaseDataClient extends DataClient {
  FirebaseDataClient({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;

  @override
  Future<void> deleteTodosFromFavorites(List<String> ids) {
    // TODO: implement deleteTodosFromFavorites
    throw UnimplementedError();
  }

  @override
  Stream<List<Todo>> getSavedTodos(String userId) {
    // TODO: implement getSavedTodos
    throw UnimplementedError();
  }

  @override
  Future<void> saveTodosToFavorites(List<String> ids) {
    // TODO: implement saveTodosToFavorites
    throw UnimplementedError();
  }

  @override
  Future<List<Todo>> searchTodos(String searchTerm) {
    // TODO: implement searchTodos
    throw UnimplementedError();
  }

  @override
  Future<void> uploadTodo(Todo todo) async {
    final document = _firebaseFirestore.collection('todos').doc();
    // TODO: ez kell?
    todo.copyWith(id: document.id);
    await document.set(todo.toMap());
  }
  
}