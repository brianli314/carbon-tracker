import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier{
  DateTime lastUpdated = DateTime.now();
  final locationController = Location();
  LocationData? lastLocation;

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await locationController.serviceEnabled();

    if (serviceEnabled){
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied){
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    locationController.onLocationChanged.listen((location){
      if (location.latitude != null && location.longitude != null){
        print(location);
      }
    });
  }
}