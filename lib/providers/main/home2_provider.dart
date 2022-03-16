import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class HomeSecondProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  NewsHomeModel? _homeModel;
  NewsHomeModel? get homeNews => _homeModel;

  Future<Null> getNewsSecond(requestJson) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (await _apiProvider.getConnectivityStatus()) {
      try {
        // _homeModel = null;
        notifyListeners();
        showLoading();
        final response =
            await _apiProvider.post(getHomePage + "second", requestJson);
        if (response != null) {
          hideLoading();
          _homeModel = NewsHomeModel.fromJson(response);
          _prefs.remove("homeModel2");
          String offlineStringObj = json.encode(response);
          _prefs.setString("homeModel2", offlineStringObj);
          notifyListeners();
        }
      } on Exception catch (e) {
        hideLoading();
        // TODO
      }
    } else {
      Fluttertoast.showToast(msg: "No InterNet connection");
      String? rawModel = _prefs.getString("homeModel2");
      if (rawModel != null) {
        _homeModel = NewsHomeModel.fromJson(json.decode(rawModel));
        notifyListeners();
      }
    }
  }

  void submitQuiz({required int quizId}) {
    _homeModel?.data?.result?.finalposts?.forEach((element) {
      log("message of quiz ${element.quiz?.quizId} ${quizId} ");
      // element.quiz?.isAnswered = true;
      notifyListeners();
      if (element.quiz?.quizId == quizId) {
        element.quiz?.isAnswered = true;
        log("this is quiz submited ${element.quiz!.isAnswered}");
        notifyListeners();
      }
    });
  }

  Future<void> onRefresh(requestJson) async {
    await getNewsSecond(requestJson).whenComplete(() => notifyListeners());
  }

  void pollSubmitted({required int pollId, required String answer}) {
    _homeModel?.data?.result?.finalposts?.forEach((element) {
      // element.quiz?.isAnswered = true;
      notifyListeners();
      if (element.quiz?.quizId == pollId) {
        element.quiz?.isAnswered = true;
        element.quiz?.answer = answer;
        notifyListeners();
      }
    });
  }
}
