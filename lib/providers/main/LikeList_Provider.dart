import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:threekm/Models/LikeListModel.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class LikeListProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  LikeListModel? _likeList;
  LikeListModel? get likeList => _likeList;

  List<User> get users => _likeList?.data?.result?.users ?? <User>[];
  int? get usersCount => users.length;

  List<User> get likeUsers =>
      _likeList?.data?.result?.users?.where((element) => element.emotion == 'like').toList() ??
      <User>[];
  int? get likeCount => likeUsers.length;

  List<User> get loveUsers =>
      _likeList?.data?.result?.users?.where((element) => element.emotion == 'love').toList() ??
      <User>[];
  int? get loveCount => loveUsers.length;

  List<User> get careUsers =>
      _likeList?.data?.result?.users?.where((element) => element.emotion == 'care').toList() ??
      <User>[];
  int? get careCount => careUsers.length;

  List<User> get laughUsers =>
      _likeList?.data?.result?.users?.where((element) => element.emotion == 'laugh').toList() ??
      <User>[];
  int? get laughCount => laughUsers.length;

  List<User> get sadUsers =>
      _likeList?.data?.result?.users?.where((element) => element.emotion == 'sad').toList() ??
      <User>[];
  int? get sadCount => sadUsers.length;

  List<User> get angryUsers =>
      _likeList?.data?.result?.users?.where((element) => element.emotion == 'angry').toList() ??
      <User>[];
  int get angryCount => angryUsers.length;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<dynamic> showLikes(context, int postId) async {
    _isLoading = true;
    notifyListeners();
    try {
      String requestJson = json.encode({"module": "news_post", "entity_id": postId});
      final response = await _apiProvider.post(likes, requestJson);
      if (response != null) {
        _isLoading = false;
        if (response["status"] == "success") {
          _likeList = LikeListModel.fromJson(response);
          notifyListeners();
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
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      CustomSnackBar(context, Text("Error occured While Featching results"));
    }
  }
}
