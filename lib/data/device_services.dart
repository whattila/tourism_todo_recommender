import 'package:location/location.dart';
import 'package:tourism_todo_recommender/models/geolocation.dart';

import 'geocoder.dart';

class DeviceException implements Exception {
  const DeviceException([
    this.message = "An unknown exception occurred",
  ]);

  final String message;
}

class DeviceServices {
  Location location = Location();

  Future<Geolocation> getDeviceLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw const DeviceException("Enable location service on your device!");
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw const DeviceException("Accessing device location has been denied!");
      }
    }

    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      throw const InvalidLocation("Device location could not be obtained.");
    }
    return Geolocation(latitude: locationData.latitude!, longitude: locationData.longitude!);
  }
}