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
  String? _state;
  String? get state => _state;

  bool _isLoadingPoll = false;
  bool get isLoadingPoll => _isLoadingPoll;

  SinglePoll? _SinglePollModel;
  SinglePoll? get singlePollModel => _SinglePollModel;

  Future<Null> getNewsSecond(requestJson) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (await _apiProvider.getConnectivityStatus()) {
      try {
        // _homeModel = null;
        if (_homeModel == null) {
          _state = 'loading';
        }
        notifyListeners();
        // showLoading();

        final response =
            await _apiProvider.post(getHomePage + "second", requestJson);
        if (response != null) {
          // hideLoading();
          if (_homeModel == null) {
            _state = 'loaded';
          }
          _homeModel = NewsHomeModel.fromJson(response);
          _prefs.remove("homeModel2");
          String offlineStringObj = json.encode(response);
          _prefs.setString("homeModel2", offlineStringObj);
          notifyListeners();
        }
      } on Exception catch (e) {
        _state = 'error';
        // hideLoading();
        // TODO
      }
    } else {
      Fluttertoast.showToast(msg: "No InterNet connection");
      String? rawModel = _prefs.getString("homeModel2");
      if (rawModel != null) {
        _homeModel = NewsHomeModel.fromJson(json.decode(rawModel));
        _state = 'loaded';
        notifyListeners();
      }
    }
  }

  Future<Null> getActivePoll({required String pollId}) async {
    String requestJson = json
        .encode({"poll_id": pollId, "token": await _apiProvider.getToken()});
    _isLoadingPoll = true;
    notifyListeners();
    final response = await _apiProvider.post(activePollApi, requestJson);
    if (response["status"] == "success") {
      log(response.toString());
      _SinglePollModel = SinglePoll.fromJson(response);
      _isLoadingPoll = false;
      //log(response["Result"]["quiz"]);
      notifyListeners();
    } else {
      log("call on else");
      _isLoadingPoll = false;
      // notifyListeners();
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
