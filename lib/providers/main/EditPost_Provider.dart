// author: Prateek Aher
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:threekm/Models/deepLinkPost.dart';
import 'package:threekm/UI/main/AddPost/BottomSnack.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class EditPostProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();

  int? postId;

  String _description = '';
  String get description => _description;
  set description(String text) {
    _description = text;
    notifyListeners();
  }

  String _headline = '';
  String get headline => _headline;
  set headline(String text) {
    _headline = text;
    notifyListeners();
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

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> savePost() async {
    String requestJson = json.encode({
      "post_id": postId,
      "headline": "$_headline",
      "story": "$_description",
      "images": imageList.toList(),
      "videos": videoList.map((e) => e.src).toList(),
      "type": "Story",
      "tags": tagsList.toList(),
      // "areas":["kothrud", "karve nagar"],
      "latitude": _geometry?.location.lat,
      "longitude": _geometry?.location.lng,
      "location": "$_selectedAddress",
      "business": [],
      "products": []
    });
    isLoading = true;
    final response = await _apiProvider.post(update_post, requestJson);
    log(response.toString());
    if (response != null) {
      if (response["status"] == "success") {
        Fluttertoast.showToast(msg: "Saved", backgroundColor: Color(0xFF0044CE));
      } else {
        Fluttertoast.showToast(msg: response['error'], backgroundColor: Color(0xFF0044CE));
      }
    }
    isLoading = false;
  }

  @override
  void dispose() {
    videoList.clear();
    imageList.clear();
    geometry = null;
    selectedAddress = null;
    tagsList.clear();
    postId = null;
    _headline = _description = '';
    super.dispose();
  }
}
