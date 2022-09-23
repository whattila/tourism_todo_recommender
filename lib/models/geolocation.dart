import 'package:equatable/equatable.dart';
import 'dart:math';

/// Represents a geographical location by storing its latitude and longitude.
/// Masks the library behind geocoding, to detach the business layer from it.
/// Extends Equatable as a best practice.
class Geolocation extends Equatable {
  const Geolocation({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  /// Uses the Haversine formula to compute the distance between this location and another.
  double distanceTo(Geolocation destination) {
    const earthRadiusKm = 6372.8;

    final dLat = _toRadians(destination.latitude - latitude);
    final dLon = _toRadians(destination.longitude - longitude);
    final originLat = _toRadians(latitude);
    final destinationLat = _toRadians(destination.latitude);

    final a = pow(sin(dLat / 2), 2.toDouble()) + pow(sin(dLon / 2), 2.toDouble()) * cos(originLat) * cos(destinationLat);
    final c = 2 * asin(sqrt(a));
    return earthRadiusKm * c;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  @override
  List<Object?> get props => [latitude, longitude];

// we could even add a copyWith here
}