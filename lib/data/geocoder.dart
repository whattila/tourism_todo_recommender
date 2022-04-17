import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart';

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

/// Handles requests to the geocoding libary.
/// Detaches the upper layers from the used library.
class Geocoder {
  Future<Geolocation?> getLocationFromAddress(String address) async {
    List<Location> locations = [];
    try {
      locations = await locationFromAddress(address);
    } catch(e) {
      print(e.toString());
    }
    return locations.isNotEmpty ?
        Geolocation(latitude: locations[0].latitude, longitude: locations[0].longitude)
        : null;
  }
}