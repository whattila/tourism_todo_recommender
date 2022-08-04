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

  final Geolocation userLocation;
}