import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:threekm/Models/deepLinkPost.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class SinglePostProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  DeepLinkPost? _deepLinkPost;
  DeepLinkPost? get postDetails => _deepLinkPost;
  Future<Null> getPostDetails(postId, mounted, lang) async {
    _isLoading = true;
    notifyListeners();
    String _token = await _apiProvider.getToken() ?? "";
    if (mounted) {
      try {
        var response =
            await _apiProvider.get(post_details + "$postId" + "&token=$_token" + "&lang=$lang");
        print(response);
        if (response != null) {
          _deepLinkPost = DeepLinkPost.fromJson(response);
          _isLoading = false;
          notifyListeners();
        }
      } on Exception catch (e) {
        log(e.toString());
        _isLoading = false;
      }
    }
  }

  Future<Null> postLike(String postId, String? emotion) async {
    String token = await _apiProvider.getToken();
    print(token);

    String requestJson = json.encode({
      "module": "news_post",
      "entity_id": postId,
      "emotion": "$emotion"
    }); //"emotion": "$emotion"s
    _deepLinkPost!.data!.result!.post!.isLiked = true;
    _deepLinkPost!.data!.result!.post!.likes = _deepLinkPost!.data!.result!.post!.likes! + 1;
    _deepLinkPost?.data?.result?.post?.emotion = emotion;
    notifyListeners();

    final response = await _apiProvider.post(like, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {}
  }

  Future<Null> postUnLike(String postId) async {
    String requestJson = json.encode({"module": "news_post", "entity_id": postId});
    _deepLinkPost!.data!.result!.post!.isLiked = false;
    _deepLinkPost!.data!.result!.post!.likes = _deepLinkPost!.data!.result!.post!.likes! - 1;
    notifyListeners();
    final response = await _apiProvider.post(unlike, requestJson);
    print(response);
    if (response != null && response["status"] == "success") {}
  }

  void resetRefresh() {
    _isLoading = true;
    notifyListeners();
  }
}
