import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Custom_library/location2.0/lib/entities/address_component.dart';
import 'package:threekm/Custom_library/location2.0/lib/entities/location_result.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:http/http.dart' as http;
import 'package:threekm/utils/threekm_textstyles.dart';

class PickFromMap extends StatefulWidget {
  const PickFromMap(this.latLng, {Key? key}) : super(key: key);
  final LatLng latLng;
  @override
  State<PickFromMap> createState() => _PickFromMapState();
}

class _PickFromMapState extends State<PickFromMap> {
  late final CameraPosition initialCameraPosition;
  Set<Marker> markers = {};

  PlacesDetailsResponse? _details;

  /// Result returned after user completes selection
  LocationResult? locationResult;
  late GoogleMapsPlaces places;
  late GoogleMapController _mapController;
  @override
  void initState() {
    super.initState();
    initialCameraPosition = CameraPosition(target: widget.latLng, zoom: 14.0);
    markers.clear();
    markers.add(Marker(markerId: MarkerId("selected-location"), position: widget.latLng));

    getPlace();
  }

  getPlace() async {
    places = GoogleMapsPlaces(
      apiKey: GMap_Api_Key,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesSearchResponse response =
        await places.searchByText("${widget.latLng.latitude},${widget.latLng.longitude}");
    _details = await places.getDetailsByPlaceId(response.results.first.placeId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: ThreeKmTextConstants.black,
        backgroundColor: ThreeKmTextConstants.white,
        title: Text(
          "Locate on Map",
          style: ThreeKmTextConstants.appBarTitleTextStyle,
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context, _details);
              },
              icon: Icon(Icons.done))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              markers: markers,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(CameraPosition(target: widget.latLng, zoom: 15.0)),
                );
              },
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onTap: (latLng) async {
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(CameraPosition(target: latLng, zoom: 15.0)),
                );
                setState(() {
                  markers.clear();
                  markers.add(Marker(markerId: MarkerId("selected-location"), position: latLng));
                });

                // reverseGeocodeLatLng(latLng);

                PlacesSearchResponse response =
                    await places.searchByText("${latLng.latitude},${latLng.longitude}");
                PlacesDetailsResponse _details =
                    await places.getDetailsByPlaceId(response.results.first.placeId);
                this._details = _details;
                setState(() {});
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _details?.result.name ?? '',
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.w600, color: ThreeKmTextConstants.black),
                ),
                Text(
                  _details?.result.formattedAddress ?? '',
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w500, color: ThreeKmTextConstants.grey3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // void reverseGeocodeLatLng(LatLng latLng) async {
  //   try {
  //     final url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?"
  //         "latlng=${latLng.latitude},${latLng.longitude}&"
  //         "language=en&"
  //         "key=${GMap_Api_Key}");
  //
  //     final response = await http.get(url);
  //
  //     if (response.statusCode != 200) {
  //       throw Error();
  //     }
  //
  //     final responseJson = jsonDecode(response.body);
  //
  //     if (responseJson['results'] == null) {
  //       throw Error();
  //     }
  //
  //     final result = responseJson['results'][0];
  //     log("rsult from google map api call : ${result}");
  //
  //     setState(() {
  //       String? name,
  //           locality,
  //           postalCode,
  //           country,
  //           administrativeAreaLevel1,
  //           administrativeAreaLevel2,
  //           city,
  //           subLocalityLevel1,
  //           subLocalityLevel2;
  //       bool isOnStreet = false;
  //       if (result['address_components'] is List<dynamic> &&
  //           result['address_components'].length != null &&
  //           result['address_components'].length > 0) {
  //         for (var i = 0; i < result['address_components'].length; i++) {
  //           var tmp = result['address_components'][i];
  //           var types = tmp["types"] as List<dynamic>?;
  //           var shortName = tmp['short_name'];
  //           if (types == null) {
  //             continue;
  //           }
  //           if (i == 0) {
  //             // [street_number]
  //             name = shortName;
  //             isOnStreet = types.contains('street_number');
  //             // other index 0 types
  //             // [establishment, point_of_interest, subway_station, transit_station]
  //             // [premise]
  //             // [route]
  //           } else if (i == 1 && isOnStreet) {
  //             if (types.contains('route')) {
  //               name = (name ?? "") + ", $shortName";
  //             }
  //           } else {
  //             if (types.contains("sublocality_level_1")) {
  //               subLocalityLevel1 = shortName;
  //             } else if (types.contains("sublocality_level_2")) {
  //               subLocalityLevel2 = shortName;
  //             } else if (types.contains("locality")) {
  //               locality = shortName;
  //             } else if (types.contains("administrative_area_level_2")) {
  //               administrativeAreaLevel2 = shortName;
  //             } else if (types.contains("administrative_area_level_1")) {
  //               administrativeAreaLevel1 = shortName;
  //             } else if (types.contains("country")) {
  //               country = shortName;
  //             } else if (types.contains('postal_code')) {
  //               postalCode = shortName;
  //             }
  //           }
  //         }
  //       }
  //       locality = locality ?? administrativeAreaLevel1;
  //       city = locality;
  //       this.locationResult = LocationResult()
  //         ..name = name
  //         ..locality = locality
  //         ..latLng = latLng
  //         ..formattedAddress = result['formatted_address']
  //         ..placeId = result['place_id']
  //         ..postalCode = postalCode
  //         ..country = AddressComponent(name: country, shortName: country)
  //         ..administrativeAreaLevel1 =
  //             AddressComponent(name: administrativeAreaLevel1, shortName: administrativeAreaLevel1)
  //         ..administrativeAreaLevel2 =
  //             AddressComponent(name: administrativeAreaLevel2, shortName: administrativeAreaLevel2)
  //         ..city = AddressComponent(name: city, shortName: city)
  //         ..subLocalityLevel1 =
  //             AddressComponent(name: subLocalityLevel1, shortName: subLocalityLevel1)
  //         ..subLocalityLevel2 =
  //             AddressComponent(name: subLocalityLevel2, shortName: subLocalityLevel2);
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
