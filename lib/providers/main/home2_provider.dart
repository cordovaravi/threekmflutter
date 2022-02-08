import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:threekm/Models/home1_model.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class HomeSecondProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  NewsHomeModel? _homeModel;
  NewsHomeModel? get homeNews => _homeModel;

  Future<Null> getNewsSecond(requestJson) async {
    try {
      // _homeModel = null;
      notifyListeners();
      showLoading();
      final response =
          await _apiProvider.post(getHomePage + "second", requestJson);
      if (response != null) {
        hideLoading();
        _homeModel = NewsHomeModel.fromJson(response);
        print(_homeModel);
        notifyListeners();
      }
    } on Exception catch (e) {
      hideLoading();
      // TODO
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
}
