import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  double? _lattitude;
  double? _longitude;
  double? get getLat => _lattitude;
  double? get getLang => _longitude;
  Future<Null> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      _locationData = await location.getLocation();
      if (_locationData != null) {
        _lattitude = _locationData.latitude;
        _longitude = _locationData.longitude;
        notifyListeners();
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}
