import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:threekm/Models/FeedPost/HomenewsBottomModel.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class NewsFeedProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  NewsFeedBottomModel? _newsFeedBottomModel;

  NewsFeedBottomModel? get newsFeedBottomModel => _newsFeedBottomModel;

  Future<NewsFeedBottomModel?> getBottomFeed({String? languageCode}) async {
    String requestJson =
        json.encode({"lat": 18.555217, "lng": 73.799742, "lang": languageCode});
    final response = await _apiProvider.post(feedApi, requestJson);
    if (response["status"] == "success") {
      print(response);
      _newsFeedBottomModel = NewsFeedBottomModel.fromJson(response);
      notifyListeners();
    }
  }
}
