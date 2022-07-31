import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:threekm/Custom_library/location2.0/lib/entities/location_result.dart';
import 'package:threekm/utils/api_paths.dart';
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
              tooltip: "Save Location",
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
                setState(() {});
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(CameraPosition(target: widget.latLng, zoom: 16.0)),
                );
              },
              myLocationButtonEnabled: true,
              compassEnabled: true,
              liteModeEnabled: false,
              mapToolbarEnabled: false,
              myLocationEnabled: true,
              onTap: (latLng) async {
                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                      CameraPosition(target: latLng, zoom: await _mapController.getZoomLevel())),
                );
                setState(() {
                  markers.clear();
                  markers.add(Marker(markerId: MarkerId("selected-location"), position: latLng));
                });

                PlacesSearchResponse response =
                    await places.searchByText("${latLng.latitude},${latLng.longitude}");
                PlacesDetailsResponse _details =
                    await places.getDetailsByPlaceId(response.results.first.placeId);
                this._details = _details;
                setState(() {});
              },
            ),
          ),
          AnimatedContainer(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            color: Colors.white,
            // height: MediaQuery.of(context).size.height * 0.15,
            duration: Duration(milliseconds: 800),
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
}
