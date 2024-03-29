import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:tourism_todo_recommender/data/data_client.dart';
import 'package:tourism_todo_recommender/models/comment.dart';
import 'package:tourism_todo_recommender/models/detailed_search_data.dart';
import 'package:tourism_todo_recommender/models/rating.dart';
import 'package:tourism_todo_recommender/models/todo.dart';
import 'package:uuid/uuid.dart';

class FirebaseDataClient extends DataClient {
  FirebaseDataClient({FirebaseFirestore? firebaseFirestore, FirebaseStorage? firebaseStorage})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _firebaseStorage;

  @override
  Future<void> deleteTodosFromFavorites(List<String> ids, String userId) async {
    for (var id in ids) {
      await _firebaseFirestore.collection(userId).doc(id).delete();
      await FirebaseMessaging.instance.unsubscribeFromTopic(id);
    }
  }

  @override
  Stream<List<Todo>> getFavoriteTodos(String userId) {
    final favoriteIdsStream = _firebaseFirestore.collection(userId).snapshots();
    return favoriteIdsStream.switchMap(
            (qShot) {
              final favoriteIds = [];
              for (var doc in qShot.docs) {
                favoriteIds.add(doc.id);
              }
              if (favoriteIds.isEmpty) {
                return Stream.value(<Todo>[]);
              }
              final favoriteTodosStream = _firebaseFirestore
                  .collection('todos')
                  .where('id', whereIn: favoriteIds)
                  .snapshots();
              return favoriteTodosStream.map(
                      (qShot) => qShot.docs.map(
                          (doc) => Todo.fromJson(doc.data())
                  ).toList()
              );
            }
      );
  }

  @override
  Future<void> saveTodosToFavorites(List<String> ids, String userId) async {
    for (var id in ids) {
      await _firebaseFirestore.collection(userId).doc(id).set({});
      await FirebaseMessaging.instance.subscribeToTopic(id);
    }
  }

  @override
  Future<List<Todo>> searchTodos(String searchTerm) async {
    // this is fine when we have relatively few documents
    // if we had many, we would implement a full-text search solution with a third-party service like Algolia or Elastic
    List<Todo> matchingTodos = [];
    final querySnapshot = await _firebaseFirestore.collection('todos').get();
    for (var doc in querySnapshot.docs) {
      final todo = Todo.fromJson(doc.data());
      final lowerCaseSearchTerm = searchTerm.toLowerCase();
      if (todo.address.toLowerCase().contains(lowerCaseSearchTerm) ||
          todo.shortDescription.toLowerCase().contains(lowerCaseSearchTerm) ||
          todo.uploaderName.toLowerCase().contains(lowerCaseSearchTerm) ||
          todo.detailedDescription.toLowerCase().contains(lowerCaseSearchTerm) ||
          todo.nature.toLowerCase().contains(lowerCaseSearchTerm)
      ) {
        matchingTodos.add(todo);
      }
    }
    return matchingTodos;
  }

  @override
  Future<List<Todo>> searchTodosInDetail(DetailedSearchData searchData) async {
    List<Todo> matchingTodos = [];
    final querySnapshot = await _firebaseFirestore.collection('todos').get();
    for (var doc in querySnapshot.docs) {
      final todo = Todo.fromJson(doc.data());
      if (searchData.isTodoMatching(todo) == true) {
        matchingTodos.add(todo);
      }
    }
    return matchingTodos;
  }

  @override
  Future<void> uploadTodo(Todo todo, {List<Uint8List> imagesToUpload = const[], List<String> remainingImages = const[]}) async {
    final String id;
    if (todo.id == '') {
      id = _firebaseFirestore.collection('todos').doc().id;
    }
    else {
      id = todo.id;
    }

    final imageURLs = await _updateImages(todo, imagesToUpload, remainingImages);

    final trueTodo = todo.copyWith(id: id, imageReferences: imageURLs);
    await _firebaseFirestore.collection('todos').doc(trueTodo.id).set(trueTodo.toJson(), SetOptions(merge: true));
    // we need 'SetOptions(merge: true)' not to overwrite derived data like rating average
    await FirebaseMessaging.instance.subscribeToTopic(todo.uploaderId);
  }

  @override
  Stream<List<Todo>> getOwnTodos(String userId) {
    final stream = _firebaseFirestore
        .collection('todos')
        .where('uploaderId', isEqualTo: userId)
        .snapshots();
    return stream.map(
            (qShot) => qShot.docs.map(
                (doc) => Todo.fromJson(doc.data())
        ).toList()
    );
  }

  @override
  Future<void> addRating(Rating rating) async {
    if (rating.isNotEmpty) {
      await _firebaseFirestore
          .collection('todos')
          .doc(rating.todoId)
          .collection('ratings')
          .doc(rating.userId)
          .set(rating.toJson());
    }
    else {
      throw ArgumentError('Empty rating cannot be uploaded!');
    }
  }

  @override
  Stream<Rating> getRating(String todoId, String userId) {
    final ratingStream = _firebaseFirestore
        .collection('todos')
        .doc(todoId)
        .collection('ratings')
        .doc(userId)
        .snapshots();
    return ratingStream.map(
            (dShot) {
              if (dShot.exists) {
                final rating = Rating.fromJson(dShot.data() as Map<String, dynamic>);
                return rating.copyWith(userId: userId, todoId: todoId); // we do this because the server data only includes the value
              }
              else {
                return Rating.empty;
              }
            }
        );
  }

  @override
  Stream<List<Todo>> getTopRatedTodos(int count) {
    final topRatedQueryStream = _firebaseFirestore
        .collection('todos')
        .orderBy('rateStatistics.average', descending: true)
        .limit(count)
        .snapshots();
    return topRatedQueryStream.map(
            (qShot) => qShot.docs.map(
                (doc) => Todo.fromJson(doc.data())
        ).toList()
    );
  }

  @override
  Future<void> addComment(Comment comment) async {
    await _firebaseFirestore
        .collection('todos')
        .doc(comment.todoId)
        .collection('comments')
        .add(comment.toJson());
  }

  @override
  Stream<List<Comment>> getTodoComments(Todo todo) {
    final commentsQuerySnapshotStream = _firebaseFirestore
        .collection('todos')
        .doc(todo.id)
        .collection('comments')
        .orderBy('date', descending: true)
        .snapshots();
    return commentsQuerySnapshotStream.map(
        (qShot) => qShot.docs.map(
            (doc) => Comment.fromJson(doc.data())
        ).toList()
    );
  }

  Future<List<String>> _updateImages(Todo todo, List<Uint8List> imagesToUpload, List<String> remainingImages) async {
    final imagesToDelete = todo.imageReferences.where((element) => remainingImages.contains(element) == false).toList();
    await _deleteImages(imagesToDelete);
    final newImageURLs = await _uploadImages(imagesToUpload, todo);
    return remainingImages + newImageURLs;
  }

  Future<List<String>> _uploadImages(List<Uint8List> images, Todo todo) async {
    final imageURLs = <String>[];
    const uuid = Uuid();

    for (final image in images) {
      final imagePath = '${todo.id}/${uuid.v4()}.jpg';
      final imageReference = _firebaseStorage.ref().child(imagePath);
      try {
        await imageReference.putData(image); // can it cause problems if we partially wrote here before during an unsuccessful write?
        final imageURL = await imageReference.getDownloadURL();
        imageURLs.add(imageURL);
      } on FirebaseException catch (e) {
        // Caught an exception from Firebase.
        print("Failed with error '${e.code}': ${e.message}");
      }
    }

    return imageURLs;
  }

  Future<void> _deleteImages(List<String> imageURLs) async {
    for (final imageURL in imageURLs) {
      final imageReference = _firebaseStorage.refFromURL(imageURL);
      await imageReference.delete();
    }
  }
}