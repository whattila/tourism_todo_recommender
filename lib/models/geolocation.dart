import 'package:equatable/equatable.dart';

/// Represents a geographical location by storing its latitude and longitude.
/// Masks the library behind geocoding, to detach the business layer from it.
/// Extends Equatable as a best practice.
class Geolocation extends Equatable {
  const Geolocation({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  @override
  List<Object?> get props => [latitude, longitude];

// we could even add a copyWith here
}