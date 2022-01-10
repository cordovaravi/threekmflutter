import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:threekm/Models/ProfilePostModel.dart';
import 'package:threekm/Models/SelfProfile_Model.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class AutthorProfileProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  ProfilePostModel? _profilePostModel;
  ProfilePostModel? get profilePostData => _profilePostModel;

  Future<Null> getAuthorProfile() async {
    String requestJson = json.encode({
      "id": 286,
      "author_type": "user",
      "token": "60b5a1411c1a7d0e85370a83"
    });
    final response = await _apiProvider.post(Author_Profile, requestJson);
    if (response != null) {
      print(response);
      _profilePostModel = ProfilePostModel.fromJson(response);
    }
  }

  ////// self profile
  SelfProfileModel? _selfProfile;
  SelfProfileModel? get selfProfile => _selfProfile;
  bool _isGettingSelfProfile = false;
  bool get isGettingSelfProfile => _isGettingSelfProfile;
  Future<Null> getSelfProfile() async {
    _isGettingSelfProfile = true;
    notifyListeners();
    final response = await _apiProvider.get(Self_Profile);
    if (response != null && response["status"] == "success") {
      print("self profile \n\n$response");
      _selfProfile = SelfProfileModel.fromJson(response);
      _isGettingSelfProfile = false;
      notifyListeners();
    }
  }

  bool _updateLoading = false;
  bool get updateLoading => _updateLoading;
  void updateAbout(
      {required BuildContext context, required String about}) async {
    _updateLoading = true;
    notifyListeners();
    String requestJson = json.encode({"about": "$about"});
    try {
      final response = await _apiProvider.post(add_About, requestJson);
      if (response != null) {
        if (response["status"] == "success") {
          print(response);
          _updateLoading = false;
          _selfProfile!.data!.result!.author!.about = about;
          notifyListeners();
        }
      }
    } on Exception catch (e) {
      _updateLoading = false;
      CustomSnackBar(context, Text("Something went Wrong"));
    }
  }

  void editAgain() {
    _updateLoading == false;
    _selfProfile!.data!.result!.author!.about = null;
    notifyListeners();
  }

  Future<Null> postLike(String postId, String? emotion) async {
    String requestJson = json.encode(
        {"module": "news_post", "entity_id": postId, "emotion": "$emotion"});
    _selfProfile!.data!.result!.posts!.forEach((element) {
      if (element.postId.toString() == postId) {
        element.likes = element.likes! + 1;
        element.isLiked = true;
        notifyListeners();
      }
      //notifyListeners();
    });
    final response = await _apiProvider.post(like, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {}
  }

  Future<Null> postUnLike(String postId) async {
    String requestJson =
        json.encode({"module": "news_post", "entity_id": postId});
    _selfProfile!.data!.result!.posts!.forEach((element) {
      if (element.postId.toString() == postId) {
        element.isLiked = false;
        element.likes = element.likes! - 1;
        notifyListeners();
      }
    });
    final response = await _apiProvider.post(unlike, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {}
  }

  // Future<Null> followUser(int autherId) async {
  //   String requestJson =
  //       json.encode({"entity": "user", "type": "user", "entity_id": autherId});
  //   final response = await _apiProvider.post(follow_User, requestJson);
  //   print(response);
  //   notifyListeners();
  //   try {
  //     if (response != null && response["status"] == "success") {
  //       _selfProfile!.data!.result!.posts!.forEach((element) {
  //         if (element.author?.id == autherId) {
  //           element.author!.isFollowed = true;
  //           notifyListeners();
  //           print(element.author!.isFollowed);
  //         }
  //       });
  //       notifyListeners();
  //     } else {
  //       CustomSnackBar(navigatorKey.currentContext!,
  //           Text("Error occuered.Please try later.!"));
  //     }
  //   } on SocketException {
  //     print("socket Exception");
  //     CustomSnackBar(
  //         navigatorKey.currentContext!, Text("Check your internet Connection"));
  //   }
  // }

  // Future<Null> unfollowUser(int autherId) async {
  //   String requestJson =
  //       json.encode({"entity": "user", "type": "user", "entity_id": autherId});
  //   final response = await _apiProvider.post(unfollow_user, requestJson);
  //   print(response);
  //   if (response != null && response["status"] == "success") {
  //     _newsbyCategories!.data!.result!.posts!.forEach((element) {
  //       if (element.author?.id == autherId) {
  //         element.author!.isFollowed = false;
  //         notifyListeners();
  //         print(element.author!.isFollowed);
  //       }
  //     });
  //     //notifyListeners();
  //   }
  //   notifyListeners();
  // }
}
