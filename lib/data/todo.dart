import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template todo}
/// A single tourism todo item.
/// [Todo]s are immutable and can be copied using [copyWith]
/// {@endtemplate}
class Todo extends Equatable {
  // All arguments must be a non-empty string to maintain domain integrity
  // and therefore must be initialized
  // the only exception is when we create and upload an object:
  // id will be an empty string, but it will receive its value from Cloud Firestore shortly
  /// {@macro user}
  const Todo({
    required this.id,
    required this.uploaderId,
    required this.uploaderName,
    required this.shortDescription,
    required this.nature,
    required this.address,
    required this.detailedDescription
  });

  /// The unique identifier of the todo.
  ///
  /// Cannot be empty.
  final String id;

  /// The unique identifier of the user who created this item.
  ///
  /// Cannot be empty.
  final String uploaderId;

  /// The name of the user who created this item.
  ///
  /// Cannot be empty.
  final String uploaderName;

  /// The short description of the todo.
  ///
  /// Cannot be empty.
  final String shortDescription;

  /// The nature of the todo.
  /// There are no constraints to the nature, besides that it must be a valid string.
  /// Cannot be empty.
  final String nature;

  /// The address (address) of the todo, where it can be found and done.
  /// There are no constraints to the address, besides that it must be a valid string.
  /// Geocoding will be run on this value, but it does not have to be successful.
  /// Cannot be empty.
  final String address;

  // Ide lehet még jönnek a koordináták is...
  // Meg a képek is...

  /// The detailed description of the todo.
  ///
  /// Cannot be empty.
  final String detailedDescription;

  /// Returns a copy of this todo with the given values updated.
  ///
  /// {@macro todo}
  Todo copyWith({
    String? id,
    String? uploaderId,
    String? uploaderName,
    String? shortDescription,
    String? nature,
    String? address,
    String? detailedDescription
  }) {
    return Todo(
      id: id ?? this.id,
      uploaderId: uploaderId ?? this.uploaderId,
      uploaderName: uploaderName ?? this.uploaderName,
      shortDescription: shortDescription ?? this.shortDescription,
      nature: nature ?? this.nature,
      address: address ?? this.address,
      detailedDescription: detailedDescription ?? this.detailedDescription
    );
  }

  /// Returns a map representation of this Todo
  /// for uploading it to Cloud Firestore.
  /// {@macro todo}
  Map<String, dynamic> toMap() => <String, dynamic>{
    'id' : id,
    'uploaderId': uploaderId,
    'uploaderName': uploaderName,
    'shortDescription' : shortDescription,
    'nature' : nature,
    'address' : address,
    'detailedDescription' : detailedDescription
  };

  @override
  List<Object?> get props => [id, uploaderId, uploaderName, shortDescription, nature, address, detailedDescription];

}