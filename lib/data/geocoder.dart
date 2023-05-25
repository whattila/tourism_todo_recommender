import 'package:geocoding/geocoding.dart';
import '../models/geolocation.dart';

class LocationException implements Exception {
  const LocationException([
    this.message = "An unknown exception occurred while obtaining a location or address",
  ]);

  final String message;
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

  Future<String> getAddressFromLocation(Geolocation location) async {
    try {
      final addresses = await placemarkFromCoordinates(location.latitude, location.longitude);
      if (addresses.isNotEmpty) {
        // TODO: Placemark contains many things. What would be the best to return? Unit tests would make a good use here...
        return "${addresses[0].locality}, ${addresses[0].street}";
      }
      throw const LocationException("Address could not be obtained from the given coordinates");
    } catch (e) {
      throw const LocationException();
    }
  }
}