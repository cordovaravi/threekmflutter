import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as webService;
import 'package:provider/provider.dart';
import 'package:threekm/Custom_library/location2.0/lib/widgets/pick_from_map.dart';
import 'package:threekm/Custom_library/location2.0/lib/widgets/place_api_provider.dart';
import 'package:threekm/Custom_library/location2.0/lib/widgets/prediction_list_loading.dart';
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
  webService.PlacesDetailsResponse? place;

  StreamController<List<Prediction>> predictionsStreamController =
      StreamController<List<Prediction>>();
  late Stream<List<Prediction>> stream = predictionsStreamController.stream;
  List<Prediction> list = <Prediction>[];

  TextEditingController _textController = TextEditingController();

  bool listLoading = false;

  @override
  Widget build(BuildContext context) {
    final md = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: md.width * 0.05, vertical: md.height * 0.03),
      child: Column(
        children: [
          _searchField(md),
          SizedBox(height: 10),
          _buildPredictionsList,
          _locateOnMapButton,
        ],
      ),
    );
  }

  TextFormField _searchField(Size md) {
    return TextFormField(
      controller: _textController,
      autofocus: true,
      onChanged: (text) async {
        if (text.isNotEmpty && text.length > 1) {
          setState(() {
            listLoading = true;
          });
          final List<Prediction> list = await PlaceApiProvider.fetchSuggestions(text);
          predictionsStreamController.add(list);
          setState(() {
            listLoading = false;
          });
        } else {
          setState(() {
            list.clear();
          });
        }
      },
      textAlignVertical: TextAlignVertical.center,
      cursorColor: ThreeKmTextConstants.black,
      decoration: InputDecoration(
          // contentPadding: EdgeInsets.zero,
          hintText: "Search for a location",
          hintStyle: GoogleFonts.poppins(
              fontSize: 16, fontWeight: FontWeight.w400, color: ThreeKmTextConstants.grey3),
          prefixIcon: Icon(
            Icons.search,
            color: ThreeKmTextConstants.grey3,
            size: 16,
          ),
          suffixIcon: _textController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    predictionsStreamController.add(list);
                    _textController.clear();
                  },
                  icon: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Icon(
                      Icons.close,
                      color: ThreeKmTextConstants.grey3,
                      size: 16,
                    ),
                  )),
          isDense: true,
          filled: true,
          fillColor: ThreeKmTextConstants.grey4,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(md.height * 0.03), borderSide: BorderSide.none)),
    );
  }

  Expanded get _buildPredictionsList {
    return Expanded(
      child: listLoading
          ? PredictionListLoading()
          : Scrollbar(
              child: ListView.separated(
                itemCount: list.length,
                itemBuilder: (context, index) => ListTile(
                  onTap: () async {
                    await _onTileTap(context, index);
                  },
                  leading: Icon(Icons.location_on_rounded),
                  title: Text(list[index].structuredFormatting?.mainText ?? '',
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500)),
                  subtitle: Text(list[index].structuredFormatting?.secondaryText ?? '',
                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400)),
                ),
                separatorBuilder: (_, __) => Divider(
                  color: ThreeKmTextConstants.grey1,
                ),
              ),
            ),
    );
  }

  TextButton get _locateOnMapButton {
    return TextButton.icon(
        onPressed: _locateOnMap,
        icon: Image.asset("assets/locate.png", height: 16),
        label: Text(
          "Locate on Map",
          style: GoogleFonts.poppins(
              color: ThreeKmTextConstants.black, fontWeight: FontWeight.w500, fontSize: 16),
        ));
  }

  void _locateOnMap() async {
    double latitude;
    double longitude;
    await context.read<LocationProvider>().getLocation();
    if (context.read<LocationProvider>().ispermitionGranted) {
      latitude = context.read<LocationProvider>().getLatitude ?? 18.546379;
      longitude = context.read<LocationProvider>().getLongitude ?? 73.820245;
      webService.PlacesDetailsResponse? _details = await Navigator.push(
          context,
          MaterialPageRoute<webService.PlacesDetailsResponse>(
              builder: (context) => PickFromMap(LatLng(latitude, longitude))));

      if (_details != null) {
        context.read<AddPostProvider>()
          ..selectedAddress =
              (_details.result.name) + '\n' + (_details.result.formattedAddress ?? '')
          ..geometry = _details.result.geometry;
        Navigator.pop(context);
      }
    }
  }

  Future<void> _onTileTap(BuildContext context, int index) async {
    FocusScope.of(context).unfocus();
    webService.GoogleMapsPlaces places = webService.GoogleMapsPlaces(
      apiKey: GMap_Api_Key,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    webService.PlacesDetailsResponse _details =
        await places.getDetailsByPlaceId(list[index].placeId!);
    context.read<AddPostProvider>()
      ..selectedAddress = (_details.result.name) + '\n' + (_details.result.formattedAddress ?? '')
      ..geometry = _details.result.geometry;
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    stream.listen((event) {
      setState(() {
        list.clear();
        list.addAll(event);
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
