import 'package:equatable/equatable.dart';

// Ez JsonSerializable? Ha igen, ide kellenek a megfelelő annotációk! De nem hiszem, hogy arra szükség lesz...
/// {@template todo}
/// A single tourism todo item.
/// [Todo]s are immutable and can be copied using [copyWith]
/// {@endtemplate}
class Todo extends Equatable {
  // Mikor először létrehozunk egy Todot, nem adunk id-t, mert majd a Cloud Firestore ad.
  // Egyébként viszont meg kell adni. Hogy lehet ezt megoldani?
  // Itt lehet az a megoldás is, ami a Todo példában látható (pl. assert). Melyik legyen?
  /// {@macro user}
  const Todo({
    required this.id,
    required this.shortDescription,
    required this.nature,
    required this.address,
    required this.detailedDescription
  });

  /// The unique identifier of the todo.
  ///
  /// Cannot be empty.
  final String id;

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

  // Ez így biztos jó?
  /// Returns a copy of this todo with the given values updated.
  ///
  /// {@macro todo}
  Todo copyWith({
    String? id,
    String? shortDescription,
    String? nature,
    String? address,
    String? detailedDescription
  }) {
    return Todo(
      id: id ?? this.id,
      shortDescription: shortDescription ?? this.shortDescription,
      nature: nature ?? this.nature,
      address: address ?? this.address,
      detailedDescription: detailedDescription ?? this.detailedDescription
    );
  }

  @override
  // TODO: update if something changes
  List<Object?> get props => [id, shortDescription, nature, address, detailedDescription];

}