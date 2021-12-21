import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  double? _lattitude;
  double? _longitude;
  double? get getLatitude => _lattitude;
  double? get getLangitude => _longitude;
  bool _ispermmitionGranted = false;
  bool get ispermitionGranted => _ispermmitionGranted;
  Future<dynamic> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    try {
      _serviceEnabled = await location.serviceEnabled();
      if (_serviceEnabled == true) {
        _ispermmitionGranted = true;
        notifyListeners();
      }
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
        } else if (_ispermmitionGranted == PermissionStatus.granted) {
          _ispermmitionGranted = true;
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
