import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:threekm/providers/Location/getAddress.dart';

class LocationProvider extends ChangeNotifier {
  double? _lattitude;
  double? _longitude;
  double? get getLatitude => _lattitude;
  double? get getLangitude => _longitude;
  LocationData? _getlocationData;
  LocationData? get getlocationData => _getlocationData;
  bool _ispermmitionGranted = false;
  bool get ispermitionGranted => _ispermmitionGranted;

  String? _address;
  String? get AddressFromCordinate => _address;

  Future<Null> getLocation() async {
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
      print(_locationData);
      print("locatio is :${_locationData.latitude}");
      print(_locationData.longitude);
      if (_locationData != null) {
        _getlocationData = _locationData;
        _lattitude = _locationData.latitude;
        _longitude = _locationData.longitude;
        notifyListeners();
      }
      _address = await getAddressFromKlatlong(
          _locationData.latitude ?? 18.569910,
          _locationData.longitude ?? 73.897530);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}
