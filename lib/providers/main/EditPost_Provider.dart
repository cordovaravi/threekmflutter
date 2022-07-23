// author: Prateek Aher
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:threekm/Models/deepLinkPost.dart';
import 'package:threekm/networkservice/Api_Provider.dart';

class EditPostProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();

  int? postId;

  String _description = '';
  String get description => _description;
  set description(String text) {
    _description = text;
  }

  String _headline = '';
  String get headline => _headline;
  set headline(String text) {
    _headline = text;
  }

  List<String> tagsList = [];

  void addTag(String tag) {
    tagsList.add(tag);
    notifyListeners();
  }

  void removeTag(String tag) {
    tagsList.remove(tag);
    notifyListeners();
  }

  String? _selectedAddress;
  String? get selectedAddress => _selectedAddress;
  set selectedAddress(String? text) {
    _selectedAddress = text;
    notifyListeners();
  }

  Geometry? _geometry;
  Geometry? get geometry => _geometry;
  set geometry(Geometry? geometry) {
    _geometry = geometry;
    notifyListeners();
  }

  List<String> imageList = <String>[];
  void removeImage(int index) {
    imageList.removeAt(index);
    notifyListeners();
  }

  List<Video> videoList = <Video>[];
  void removeVideo(int index) {
    videoList.removeAt(index);
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
