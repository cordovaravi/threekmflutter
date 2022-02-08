import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreatorLocation extends StatelessWidget {
  const CreatorLocation({Key? key, this.initialTarget}) : super(key: key);
  final LatLng? initialTarget;

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition =
        CameraPosition(target: initialTarget!, zoom: 15);

    final Marker marker = Marker(
      markerId: MarkerId('marker_id_1'),
      position: initialTarget!,
      infoWindow: InfoWindow(title: '', snippet: '*'),
      onTap: () {
        //_onMarkerTapped(markerId);
      },
    );
    Map<MarkerId, Marker> markers = <MarkerId, Marker>{
      MarkerId('marker_id_1'): marker
    };
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: true, liteModeEnabled: true, indoorViewEnabled: true,
        zoomControlsEnabled: true, zoomGesturesEnabled: true,
        buildingsEnabled: true,
        initialCameraPosition: initialCameraPosition,
        // mapType: data,
        myLocationEnabled: true,
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {},
        onCameraIdle: () {},
        onCameraMoveStarted: () {},
        onCameraMove: (CameraPosition position) {},
      ),
    );
  }
}
