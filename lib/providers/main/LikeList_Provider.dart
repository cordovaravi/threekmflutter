import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:threekm/Models/LikeListModel.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class LikeListProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  LikeListModel? _likeList;
  LikeListModel? get likeList => _likeList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<dynamic> showLikes(context, int postId) async {
    _isLoading = true;
    notifyListeners();
    try {
      String requestJson =
          json.encode({"module": "news_post", "entity_id": postId});
      final response = await _apiProvider.post(likes, requestJson);
      if (response != null) {
        _isLoading = false;
        if (response["status"] == "success") {
          _likeList = LikeListModel.fromJson(response);
          // notifyListeners();
          if (_likeList!.data!.result!.anonymousCount != 0) {
            // print(_likeList!.data!.result!.count! + 1);
            _likeList!.data!.result!.users!.add(
                //_likeList!.data!.result!.users!.length + 1,
                User(
                    isUnknown: true,
                    id: _likeList!.data!.result!.count! + 1,
                    name: "anonymous",
                    avatar:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Location_dot_black.svg/1200px-Location_dot_black.svg.png",
                    emotion: null));
          }
          print(likeList!.data!.result!.users!.length);
          notifyListeners();
        }
      }
    } on Exception catch (e) {
      _isLoading = false;
      notifyListeners();
      CustomSnackBar(context, Text("Error occured While Featching results"));
    }
  }
}
