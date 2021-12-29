import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/main.dart';
import 'package:threekm/utils/api_paths.dart';

class AddPostProvider extends ChangeNotifier {
  List<String> _tagsList = [];
  List<String> get tagsList => _tagsList;

  Future<Null> addTags(String tagItem) async {
    _tagsList.add(tagItem);
    notifyListeners();
  }

  Future<Null> deletTag(int index) async {
    _tagsList.removeAt(index);
    notifyListeners();
  }

  void removeTag(String tag) {
    _tagsList.remove(tag);
    notifyListeners();
  }

  /// Images
  List<File> _moreImages = [];
  List<File> get getMoreImages => _moreImages;

  void addImages(File image) {
    _moreImages.add(image);
    notifyListeners();
  }

  void removeImages(int Index) {
    _moreImages.removeAt(Index);
    notifyListeners();
  }

  void asignImages(images) {
    List<XFile> tempimages = images;
    //_moreImages = images;
    tempimages.forEach((element) {
      _moreImages.add(File(element.path));
    });
    notifyListeners();
  }

  void insertImage(int index, File image) {
    _moreImages.insert(index, image);
  }

  Future<Null> uploadPng() async {
    final httpResponse = await http.post(Uri.parse(upload_Imagefile));
    if (httpResponse.statusCode == 200) {
      final response = json.decode(httpResponse.body);
    } else {
      CustomSnackBar(navigatorKey.currentContext!, Text("Upload Failed.!"));
    }
  }
}
