import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String? thisdeviceId;
  // getDeviceId() async {
  //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  //   if (Platform.isAndroid) {
  //     await deviceInfo.androidInfo.then((value) {
  //       thisdeviceId = value.androidId;
  //     });
  //   } else if (Platform.isIOS) {
  //     await deviceInfo.iosInfo.then((value) {
  //       thisdeviceId = value.identifierForVendor;
  //     });
  //   }
  // }

  Future<NewsFeedBottomModel?> getBottomFeed({String? languageCode}) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    //loading is true
    _isLoading = true;
    notifyListeners();

    //request json
    String requestJson = json.encode({
      "lat": 18.555217,
      "lng": 73.799742,
      "lang": languageCode,
      //"device": _prefs.getString('deviceID'),
      "token": _prefs.getString("token")
    });
    if (await _apiProvider.getConnectivityStatus()) {
      //you are online
      final response = await _apiProvider.post(feedApi, requestJson);
      if (response["status"] == "success") {
        _newsFeedBottomModel = await NewsFeedBottomModel.fromJson(response);

        print(response['data']['result']['posts'][0]);
        _isLoading = false;
        notifyListeners();
        ////Offline data sync
        ///
        ///
        _prefs.remove("feedModel");
        String offlineStringObj = json.encode(response);
        _prefs.setString("feedModel", offlineStringObj);
      }
    } else {
      // you are offline
      Fluttertoast.showToast(
          toastLength: Toast.LENGTH_LONG,
          msg: "No InterNet connection! You are seeing offline Data");
      String? rawModel = _prefs.getString("feedModel");
      if (rawModel != null) {
        _newsFeedBottomModel =
            NewsFeedBottomModel.fromJson(json.decode(rawModel));
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<Null> postLike(String postId, String? emotion) async {
    String requestJson = json.encode(
        {"module": "news_post", "entity_id": postId, "emotion": "$emotion"});
    _newsFeedBottomModel?.data?.result?.posts?.forEach((element) {
      if (element.postId.toString() == postId && element.isLiked == false) {
        element.likes = element.likes! + 1;
        element.isLiked = true;
        element.emotion = emotion;
        if (emotion != null &&
            emotion != "" &&
            !element.listEmotions!.contains(emotion))
          element.listEmotions?.add(emotion);
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
    _newsFeedBottomModel?.data?.result?.posts?.forEach((element) {
      if (element.postId.toString() == postId && element.isLiked == true) {
        element.isLiked = false;
        element.likes = element.likes! - 1;
        element.emotion = null;
        if (element.likes == 1) {
          element.listEmotions = [];
          element.listEmotions?.clear();
        }
        ;
      }
      notifyListeners();
    });

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
