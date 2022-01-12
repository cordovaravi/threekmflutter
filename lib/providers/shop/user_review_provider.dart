import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:threekm_test/commenwidgets/commenwidget.dart';
import 'package:threekm_test/networkservice/Api_Provider.dart';
import 'package:threekm_test/Models/shopModel/review_model.dart';
import 'package:threekm_test/utils/api_paths.dart';

class UserReviewProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();
  String? _state;
  String? get state => _state;

  UserReviewModel _userReview = UserReviewModel();

  UserReviewModel get userReviewDetail => _userReview;

  Future<void> postUserReview(mounted, entity_id, rating, title, description,
      images, delivery_rating) async {
    if (mounted) {
      showLoading();
      try {
        var uri = Uri.parse(baseUrl + userReview);
        var request = MultipartRequest('POST', uri);
        // String token = await _apiProvider.getToken();
        for (int i = 0; i < images.length; i++) {
          MultipartFile mFile =
              //await MultipartFile.fromPath('images', images[i].path);
            MultipartFile(
              'images',
              File(images[i].path).readAsBytes().asStream(),
              File(images[i].path).lengthSync(),
              filename: images[i].path.split("/").last);
          request.files.add(mFile);
        }
        request.headers['Authorization'] = '5ed25e0696d24658f93d8a9a';
        request.fields['module'] = 'catalog';
        request.fields['entity_id'] = entity_id.toString();
        request.fields['rating'] = rating.toString();
        request.fields['title'] = title;
        request.fields['description'] = description;
        request.fields['delivery_rating'] = delivery_rating.toString();

        final response = await request.send();
        print('${response.statusCode}');
        print(response.toString());
        response.stream.transform(utf8.decoder).listen((value) {
          print(value.toString());
        });
        // if (response != null) {
        //   hideLoading();
        //   _userReview = UserReviewModel.fromJson(Response.fromStream(response.stream));
        //   _state = 'loaded';
        //   notifyListeners();
        // }
      } catch (e) {
        hideLoading();
        _state = 'error';
        notifyListeners();
      }
    }
  }

  // Future<void> onRefresh(mounted, requestJson) async {
  //   await postUserReview(mounted, requestJson)
  //       .whenComplete(() => notifyListeners());
  // }
}
