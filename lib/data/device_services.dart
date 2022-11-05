import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
  // I create this eagerly for a future notification service
  final _location = Location();

  // I don't want things to be nullable because of a lazy creation
  final _imagePicker = ImagePicker();

  Future<Geolocation> getDeviceLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        throw const DeviceException("Enable location service on your device!");
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw const DeviceException("Accessing device location has been denied!");
      }
    }

    locationData = await _location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      throw const InvalidLocation("Device location could not be obtained.");
    }
    return Geolocation(latitude: locationData.latitude!, longitude: locationData.longitude!);
  }

  Future<List<XFile>> getImages(ImageSource source) async {
    List<XFile> images = [];
    switch (source) {
      case ImageSource.gallery:
        try {
          images.addAll(await _imagePicker.pickMultiImage());
        } catch (e) {
          throw DeviceException(e.toString());
        }
        break;
      case ImageSource.camera:
        try {
          final photo = await _imagePicker.pickImage(source: ImageSource.camera);
          images.add(photo!);
        } catch (e) {
          throw DeviceException(e.toString());
        }
        break;
    }
    return images;
  }
}