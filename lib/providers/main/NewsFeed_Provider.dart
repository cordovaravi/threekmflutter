import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:threekm/Models/FeedPost/HomenewsBottomModel.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

import '../../main.dart';

class NewsFeedProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  NewsFeedBottomModel? _newsFeedBottomModel;

  NewsFeedBottomModel? get newsFeedBottomModel => _newsFeedBottomModel;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<NewsFeedBottomModel?> getBottomFeed({String? languageCode}) async {
    _isLoading = true;
    notifyListeners();
    String requestJson =
        json.encode({"lat": 18.555217, "lng": 73.799742, "lang": languageCode});
    final response = await _apiProvider.post(feedApi, requestJson);
    if (response["status"] == "success") {
      _newsFeedBottomModel = await NewsFeedBottomModel.fromJson(response);
      print(response['data']['result']['posts'][0]);
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Null> postLike(String postId, String? emotion) async {
    String requestJson = json.encode(
        {"module": "news_post", "entity_id": postId, "emotion": "$emotion"});
    _newsFeedBottomModel!.data!.result!.posts!.forEach((element) {
      if (element.postId.toString() == postId && element.isLiked == false) {
        element.likes = element.likes! + 1;
        element.isLiked = true;
      }
      //notifyListeners();
    });
    notifyListeners();
    final response = await _apiProvider.post(like, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {
      // notifyListeners();
    }
  }

  Future<Null> postUnLike(String postId) async {
    String requestJson =
        json.encode({"module": "news_post", "entity_id": postId});
    _newsFeedBottomModel!.data!.result!.posts!.forEach((element) {
      if (element.postId.toString() == postId && element.isLiked == true) {
        element.isLiked = false;
        element.likes = element.likes! - 1;
      }
    });
    notifyListeners();
    final response = await _apiProvider.post(unlike, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {}
  }

  Future<Null> followUser(int autherId) async {
    String _token = await _apiProvider.getToken();
    String requestJson = json.encode({
      "entity": "user",
      "type": "user",
      "entity_id": autherId,
      "token": "$_token"
    });
    final response = await _apiProvider.post(follow_User, requestJson);
    print(response);
    //  notifyListeners();
    try {
      if (response != null && response["status"] == "success") {
        // _newsFeedBottomModel!.data!.result!.posts!.forEach((element) {
        //   if (element.author?.id == autherId) {
        //     element.author!.isFollowed = true;
        //     notifyListeners();
        //     print(element.author!.isFollowed);
        //   }
        // });
        notifyListeners();
      } else {
        CustomSnackBar(navigatorKey.currentContext!,
            Text("Error occuered.Please try later.!"));
      }
    } on SocketException {
      print("socket Exception");
      CustomSnackBar(
          navigatorKey.currentContext!, Text("Check your internet Connection"));
    }
  }

  Future<Null> unfollowUser(int autherId) async {
    String requestJson =
        json.encode({"entity": "user", "type": "user", "entity_id": autherId});
    final response = await _apiProvider.post(unfollow_user, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {
      _newsFeedBottomModel!.data!.result!.posts!.forEach((element) {
        if (element.author?.id == autherId) {
          element.author!.isFollowed = false;
          notifyListeners();
          print(element.author!.isFollowed);
        }
      });
      //notifyListeners();
    }
    notifyListeners();
  }
}
