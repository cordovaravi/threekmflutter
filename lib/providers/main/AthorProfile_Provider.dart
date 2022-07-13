import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:threekm/Models/ProfilePostModel.dart';
import 'package:threekm/Models/SelfProfile_Model.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/main.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class AutthorProfileProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();

  ////// self profile
  SelfProfileModel? _selfProfile;
  SelfProfileModel? get selfProfile => _selfProfile;
  bool _isGettingSelfProfile = false;
  bool get isGettingSelfProfile => _isGettingSelfProfile;
  Future<Null> getSelfProfile() async {
    try {
      _isGettingSelfProfile = true;
      notifyListeners();
      final response = await _apiProvider.get(Self_Profile);
      if (response != null) {
        //notifyListeners();
        if (response["status"] == "success") {
          print("self profile \n$response");
          _selfProfile = SelfProfileModel.fromJson(response);
          _isGettingSelfProfile = false;
          notifyListeners();
          print("this is selfmodel $_selfProfile");
        } else {
          _isGettingSelfProfile = false;
          notifyListeners();
          Fluttertoast.showToast(
              msg: "error while getteing profile",
              backgroundColor: Colors.redAccent);
        }
      }
    } catch (e) {
      log("${e.toString()}");
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
        element.emotion = emotion;
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
        if (element.isLiked == true) {
          element.likes = element.likes! - 1;
        }
        element.isLiked = false;
        element.emotion = null;
        notifyListeners();
      }
    });
    final response = await _apiProvider.post(unlike, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {}
  }

  //////////// author profile providers

  // void getfollowers({required int authorId}) async {
  //   String _token = await _apiProvider.getToken();
  //   String requestJson = json.encode({
  //     {"id": authorId, "author_type": "user", "token": "$_token"}
  //   });
  //   final response = await _apiProvider.post(get_Follows, requestJson);
  //   if (response != null) {
  //     if (response["status"] == "sucess") {}
  //   }
  // }

  //postmodel gettr
  ProfilePostModel? _authorProfilePostModel;
  ProfilePostModel? get authorProfilePostData => _authorProfilePostModel;

  // Floowing getter
  bool _followLoading = false;
  bool get followLoading => this._followLoading;

  //getting authorprofile getter
  bool _gettingAuthorprofile = false;
  bool get gettingAuthorprofile => _gettingAuthorprofile;

  clearAuthorProfileData() {
    _authorProfilePostModel = null;
  }

  // get Author profile data and post
  Future<Null> getAuthorProfile(
      {required int authorId, String? authorType, String? language}) async {
    _authorProfilePostModel = null;
    _gettingAuthorprofile = true;
    notifyListeners();
    String? _token = await _apiProvider.getToken();
    String requestJson = json.encode({
      "id": authorId,
      "author_type": authorType ?? "user",
      "token": _token ?? "",
      "lang": language
    });
    final response = await _apiProvider.post(Author_Profile, requestJson);
    if (response != null) {
      //print(response);
      if (response["status"] == "success") {
        // log("athor profile response is ${response}");
        _authorProfilePostModel = ProfilePostModel.fromJson(response);
        _gettingAuthorprofile = false;
        notifyListeners();
      }
    }
  }

  // followathor
  Future<Null> followAuthor(int autherId) async {
    _followLoading = true;
    notifyListeners();
    String requestJson =
        json.encode({"entity": "user", "type": "user", "entity_id": autherId});
    final response = await _apiProvider.post(follow_User, requestJson);
    print(response);
    notifyListeners();
    try {
      if (response != null && response["status"] == "success") {
        _authorProfilePostModel!.data.result!.author!.isFollowed = true;
        _authorProfilePostModel!.data.result!.author!.followers =
            _authorProfilePostModel!.data.result!.author!.followers! + 1;
        _followLoading = false;
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

  //Unfollow author

  Future<Null> unfollowAuthor(int autherId) async {
    _followLoading = true;
    notifyListeners();
    String requestJson =
        json.encode({"entity": "user", "type": "user", "entity_id": autherId});
    final response = await _apiProvider.post(unfollow_user, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {
      _authorProfilePostModel!.data.result!.author!.isFollowed = false;
      _authorProfilePostModel!.data.result!.author!.followers =
          _authorProfilePostModel!.data.result!.author!.followers! - 1;
      _followLoading = false;
      notifyListeners();
    }
    //notifyListeners();
  }

  Future<Null> authorPostLike(String postId, String? emotion) async {
    String requestJson = json.encode(
        {"module": "news_post", "entity_id": postId, "emotion": "$emotion"});
    _authorProfilePostModel!.data.result!.posts!.forEach((element) {
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

  Future<Null> authorPostUnLike(String postId) async {
    String requestJson =
        json.encode({"module": "news_post", "entity_id": postId});
    _authorProfilePostModel!.data.result!.posts!.forEach((element) {
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
}
