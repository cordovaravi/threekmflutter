import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Custom_library/location2.0/lib/widgets/pick_from_map.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/providers/main/AddPost_Provider.dart';
import 'package:threekm/utils/api_paths.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class PlacePickerNew extends StatefulWidget {
  const PlacePickerNew({Key? key}) : super(key: key);

  @override
  State<PlacePickerNew> createState() => _PlacePickerNewState();
}

class _PlacePickerNewState extends State<PlacePickerNew> {
  final Mode _mode = Mode.fullscreen;
  PlacesDetailsResponse? place;
  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: md.width * 0.05, vertical: md.height * 0.03),
      child: Column(
        children: [
          TextFormField(
            onTap: () async {
              FocusScope.of(context).unfocus();
              PlacesDetailsResponse? response = await showPlaceAutoCompletePage();
              context.read<AddPostProvider>()
                ..selectedAddress = (response?.result.name ?? '') +
                    (response != null ? ', ' : '') +
                    (response?.result.formattedAddress ?? '')
                ..geometry = response?.result.geometry;
              Navigator.pop(context);
            },
            readOnly: true,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
                // contentPadding: EdgeInsets.zero,
                hintText: "Search for a location",
                hintStyle: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w400, color: ThreeKmTextConstants.grey3),
                prefixIcon: Icon(
                  Icons.search,
                  color: ThreeKmTextConstants.grey3,
                  // size: 20,
                ),
                isDense: true,
                filled: true,
                fillColor: ThreeKmTextConstants.grey4,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(md.height * 0.03),
                    borderSide: BorderSide.none)),
          ),
          SizedBox(height: 30),
          if (place != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place!.result.name,
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text(
                  place!.result.formattedAddress!,
                  style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          Spacer(),
          TextButton.icon(
              onPressed: () async {
                double latitude;
                double longitude;
                await context.read<LocationProvider>().getLocation();
                if (context.read<LocationProvider>().ispermitionGranted) {
                  latitude = context.read<LocationProvider>().getLatitude ?? 18.546379;
                  longitude = context.read<LocationProvider>().getLongitude ?? 73.820245;
                  PlacesDetailsResponse? _details = await Navigator.push(
                      context,
                      MaterialPageRoute<PlacesDetailsResponse>(
                          builder: (context) => PickFromMap(LatLng(latitude, longitude))));
                  // setState(() {
                  //   place = _details;
                  // });
                  context.read<AddPostProvider>()
                    ..selectedAddress = (_details?.result.name ?? '') +
                        (_details != null ? ', ' : '') +
                        (_details?.result.formattedAddress ?? '')
                    ..geometry = _details?.result.geometry;
                  Navigator.pop(context);
                }
              },
              icon: Image.asset("assets/locate.png", height: 16),
              label: Text(
                "Locate on Map",
                style: GoogleFonts.poppins(
                    color: ThreeKmTextConstants.black, fontWeight: FontWeight.w500, fontSize: 16),
              )),
        ],
      ),
    );
  }

  void onError(PlacesAutocompleteResponse value) {
    Fluttertoast.showToast(msg: value.errorMessage ?? '');
  }

  Future<PlacesDetailsResponse?> showPlaceAutoCompletePage() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: GMap_Api_Key,
      onError: onError,
      mode: _mode,
      language: "en",
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: "Search for a location",
        hintStyle: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w400, color: ThreeKmTextConstants.grey3),
        // isDense: true,

        filled: true,
        fillColor: ThreeKmTextConstants.white,
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(40), borderSide: BorderSide.none)
      ),
      components: [Component(Component.country, "in")],
    );
    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: GMap_Api_Key,
        apiHeaders: await const GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse _details = await places.getDetailsByPlaceId(p.placeId!);
      // setState(() {
      //   place = _details;
      // });
      return _details;
    } else {
      return null;
    }
    FocusScope.of(context).unfocus();
  }
}
