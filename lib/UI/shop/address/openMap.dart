import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:threekm/Custom_library/GooleMapsWidget/src/place_picker.dart';
import 'package:threekm/UI/shop/address/new_address.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:provider/src/provider.dart';

class OpenMap {
  OpenMap(BuildContext context) {
    context.read<LocationProvider>().getLocation().whenComplete(() {
      final _locationProvider =
          context.read<LocationProvider>().getlocationData;
      final kInitialPosition =
          LatLng(_locationProvider!.latitude!, _locationProvider.longitude!);
      if (_locationProvider != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlacePicker(
                apiKey: GMap_Api_Key,
                // initialMapType: MapType.satellite,
                onPlacePicked: (result) {
                  //print(result.formattedAddress);
                  log(result.toString());
                  log('${result.geometry?.location.lat}');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => NewAddress(
                                locationResult: result,
                              )));

                  // Navigator.of(context).pop();
                },
                initialPosition: kInitialPosition,
                useCurrentLocation: true,
                selectInitialPosition: true,
                usePinPointingSearch: true,
                usePlaceDetailSearch: true,
              ),
            ));
      }
    });
  }
}
