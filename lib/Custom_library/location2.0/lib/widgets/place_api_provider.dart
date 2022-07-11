import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:threekm/Custom_library/location2.0/lib/uuid.dart';
import 'package:threekm/utils/api_paths.dart';

// We will use this util class to fetch the auto complete result and get the details of the place.
class PlaceApiProvider {
  PlaceApiProvider();

  static Future<List<Prediction>> fetchSuggestions(String input) async {
    http.Request createGetRequest(String url) => http.Request('GET', Uri.parse(url));
    final apiKey = GMap_Api_Key;
    final String sessionToken = Uuid().generateV4();
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\"$input\"&components=country:in&key=$apiKey&sessiontoken=$sessionToken';
    var request = createGetRequest(url);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final data = await response.stream.bytesToString();
      final result = json.decode(data);

      print(result);

      if (result['status'] == 'OK') {
        return result['predictions'].map<Prediction>((p) => Prediction.fromJson(p)).toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return <Prediction>[];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  // Future<PlaceDetail> getPlaceDetailFromId(String placeId) async {
  //   final url =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_address,name,geometry/location&key=$apiKey&sessiontoken=$sessionToken';
  //   var request = createGetRequest(url);
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     final data = await response.stream.bytesToString();
  //     final result = json.decode(data);
  //     print(result);
  //
  //     if (result['status'] == 'OK') {
  //       // build result
  //       final place = PlaceDetail();
  //       place.address = result['result']['formatted_address'];
  //       place.latitude = result['result']['geometry']['location']['lat'];
  //       place.longitude = result['result']['geometry']['location']['lng'];
  //       place.name = result['result']['geometry']['name'];
  //       return place;
  //     }
  //     throw Exception(result['error_message']);
  //   } else {
  //     throw Exception('Failed to fetch suggestion');
  //   }
  // }
}

//----------------------------------------------------------------------------

class Prediction {
  Prediction({
    this.description,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.types = const <String>[],
  });

  String? description;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<String> types;

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json["description"] == null ? null : json["description"],
        placeId: json["place_id"] == null ? null : json["place_id"],
        reference: json["reference"] == null ? null : json["reference"],
        structuredFormatting: json["structured_formatting"] == null
            ? null
            : StructuredFormatting.fromJson(json["structured_formatting"]),
        types: json["types"] == null ? <String>[] : List<String>.from(json["types"].map((x) => x)),
      );
}

class StructuredFormatting {
  StructuredFormatting({
    this.mainText = '',
    this.secondaryText = '',
  });

  String mainText;
  String secondaryText;

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) => StructuredFormatting(
        mainText: json["main_text"] == null ? 'null' : json["main_text"],
        secondaryText: json["secondary_text"] == null ? null : json["secondary_text"],
      );
}
