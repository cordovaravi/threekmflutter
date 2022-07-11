import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:threekm/Custom_library/location2.0/lib/widgets/place_picker_new.dart';
import 'package:threekm/providers/Location/locattion_Provider.dart';
import 'package:threekm/utils/threekm_textstyles.dart';

class AddPostLocation extends StatefulWidget {
  @override
  State<AddPostLocation> createState() => _AddPostLocationState();
}

class _AddPostLocationState extends State<AddPostLocation> {
  bool? isLocationTurnedON;
  @override
  void initState() {
    super.initState();
    Geolocator.isLocationServiceEnabled().then((value) {
      setState(() {
        isLocationTurnedON = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final stream = context.read<LocationProvider>().serviceStatusStream;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add location", style: ThreeKmTextConstants.appBarTitleTextStyle),
          backgroundColor: ThreeKmTextConstants.white,
          foregroundColor: ThreeKmTextConstants.black,
          titleSpacing: 0,
          elevation: 1,
        ),
        body: isLocationTurnedON != null
            ? StreamBuilder<ServiceStatus>(
                initialData:
                    isLocationTurnedON ?? false ? ServiceStatus.enabled : ServiceStatus.disabled,
                stream: stream,
                builder: (_, AsyncSnapshot<ServiceStatus> snapshot) =>
                    snapshot.data == ServiceStatus.disabled ? noLocation : PlacePickerNew())
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget get noLocation => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Post needs a location",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600, color: ThreeKmTextConstants.black),
            ),
            SizedBox(height: 6),
            Text(
              "To add location to your post , turn on location services",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w400, color: ThreeKmTextConstants.grey3),
            ),
            SizedBox(height: 5),
            Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: ElevatedButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                  },
                  style: ElevatedButton.styleFrom(elevation: 0, shape: StadiumBorder()),
                  child: Text(
                    "Turn On Location",
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ThreeKmTextConstants.white),
                  )),
            )
          ],
        ),
      );
}
