import 'package:geocoding/geocoding.dart';

Future<String?> getAddressFromKlatlong(double lat, double long) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  return "${placemarks.first.street}, ${placemarks.first.subLocality}, ${placemarks.first.subAdministrativeArea} ${placemarks.first.thoroughfare} ${placemarks.first.administrativeArea}";
}
