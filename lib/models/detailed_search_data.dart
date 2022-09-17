import 'package:tourism_todo_recommender/models/todo.dart';

import 'geolocation.dart';

class DetailedSearchData {

  const DetailedSearchData({
    required this.uploaderSearchTerm,
    required this.shortDescriptionSearchTerm,
    required this.natureSearchTerm,
    required this.addressSearchTerm,
    required this.detailedDescriptionSearchTerm,
    required this.userLocation
  });

  final String uploaderSearchTerm;
  final String shortDescriptionSearchTerm;
  final String natureSearchTerm;
  final String addressSearchTerm;
  final String detailedDescriptionSearchTerm;
  final Geolocation? userLocation;

  // TODO: I could add a property here which returns if the location is valid or not

  /// Returns true if the given todo matches the conditions specified in this object
  /// otherwise returns false
  bool isTodoMatching(Todo todo) {
      return todo.uploaderName.toLowerCase().contains(uploaderSearchTerm.toLowerCase())
          && todo.shortDescription.toLowerCase().contains(shortDescriptionSearchTerm.toLowerCase())
          && todo.nature.toLowerCase().contains(natureSearchTerm.toLowerCase())
          && todo.address.toLowerCase().contains(addressSearchTerm.toLowerCase())
          && todo.detailedDescription.toLowerCase().contains(detailedDescriptionSearchTerm.toLowerCase());
  }
}