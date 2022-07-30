import 'package:equatable/equatable.dart';

/// {@template todo}
/// A single tourism todo item.
/// [Todo]s are immutable and can be copied using [copyWith]
/// {@endtemplate}
class Todo extends Equatable {
  /// {@macro user}
  const Todo({
    required this.id,
    required this.uploaderId,
    required this.uploaderName,
    required this.shortDescription,
    required this.nature,
    required this.address,
    this.latitude,
    this.longitude,
    required this.detailedDescription
  });

  /// Creates a Todo from a json (map) representation
  /// when querying from Cloud Firestore
  Todo.fromJson(Map<String, dynamic> json)
      : this(
          id: (json['id'] != null) ? json['id'] as String : '',
          uploaderId: (json['uploaderId'] != null) ? json['uploaderId'] as String : '',
          uploaderName: (json['uploaderName'] != null) ? json['uploaderName'] as String : '',
          shortDescription: (json['shortDescription'] != null) ? json['shortDescription'] as String : '',
          nature: (json['nature'] != null) ? json['nature'] as String : '',
          address: (json['address'] != null) ? json['address'] as String : '',
          latitude: (json['latitude'] != null) ? json['latitude'] as double : null,
          longitude: (json['longitude'] != null) ? json['longitude'] as double : null,
          detailedDescription: (json['detailedDescription'] != null) ? json['detailedDescription'] as String : '',
        );


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

  /// The coordinates of this todo, if geocoding was successful
  /// If it was not, they are null
  final double? latitude;
  /// The coordinates of this todo, if geocoding was successful
  /// If it was not, they are null
  final double? longitude;

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
    double? latitude,
    double? longitude,
    String? detailedDescription
  }) {
    return Todo(
      id: id ?? this.id,
      uploaderId: uploaderId ?? this.uploaderId,
      uploaderName: uploaderName ?? this.uploaderName,
      shortDescription: shortDescription ?? this.shortDescription,
      nature: nature ?? this.nature,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      detailedDescription: detailedDescription ?? this.detailedDescription
    );
  }

  /// Returns a json (map) representation of this Todo
  /// for uploading it to Cloud Firestore.
  /// {@macro todo}
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id' : id,
    'uploaderId': uploaderId,
    'uploaderName': uploaderName,
    'shortDescription' : shortDescription,
    'nature' : nature,
    'address' : address,
    'latitude': latitude,
    'longitude': longitude,
    'detailedDescription' : detailedDescription
  };

  @override
  List<Object?> get props => [id, uploaderId, uploaderName, shortDescription, nature, address, latitude, longitude, detailedDescription];

}