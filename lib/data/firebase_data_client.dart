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
  Future<List<Todo>> searchTodos(String searchTerm) async {
    // this is fine when we have relatively few documents
    // if we had many, we would implement a full-text search solution with a third-party service like Algolia or Elastic
    List<Todo> _matchingTodos = [];
    final _querySnapshot = await _firebaseFirestore.collection('todos').get();
    _querySnapshot.docs.forEach((doc) {
      final todo = Todo.fromJson(doc.data());
      if (todo.address.toLowerCase().contains(searchTerm) ||
          todo.shortDescription.toLowerCase().contains(searchTerm) ||
          todo.uploaderName.toLowerCase().contains(searchTerm) ||
          todo.detailedDescription.toLowerCase().contains(searchTerm) ||
          todo.nature.toLowerCase().contains(searchTerm)
      ) {
        _matchingTodos.add(todo);
      }
    });
    return _matchingTodos;
  }

  @override
  Future<void> uploadTodo(Todo todo) async {
    if (todo.id == '') {
      final document = _firebaseFirestore.collection('todos').doc();
      final trueTodo = todo.copyWith(id: document.id);
      await document.set(trueTodo.toJson());
    }
    else {
      await _firebaseFirestore.collection('todos').doc(todo.id).set(todo.toJson());
    }
  }

  @override
  Stream<List<Todo>> getOwnTodos(String userId) {
    Stream<QuerySnapshot> stream = _firebaseFirestore
        .collection('todos')
        .where('uploaderId', isEqualTo: userId)
        .snapshots();
    return stream.map(
            (qShot) => qShot.docs.map(
                (doc) => Todo.fromJson(doc.data() as Map<String, dynamic>)
        ).toList()
    );
  }
  
}