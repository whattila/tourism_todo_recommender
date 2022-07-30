import 'package:geocoding/geocoding.dart';
import '../models/geolocation.dart';

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