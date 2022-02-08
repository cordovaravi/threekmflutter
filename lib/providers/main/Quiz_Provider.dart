import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class QuizProvider extends ChangeNotifier {
  bool? _isCorectAns;
  bool? get isCorrectAns => _isCorectAns;

  Future<void> update(String isSelectedAns, String rightAns, int index) async {
    if (isSelectedAns == rightAns) {
      _isCorectAns = true;
      notifyListeners();
    } else if (isSelectedAns != rightAns) {
      _isCorectAns = false;
      notifyListeners();
    }
  }

  /// method to check ans is wrong or right
  bool _isAnsnwred = false;
  bool get isAnswred => this._isAnsnwred;

  int? _answredIndex;
  int? get answredIndex => _answredIndex;

  int? _selecctedIndex;
  int? get selectedIndex => _selecctedIndex;

  bool _shake = false;
  bool get shake => this._shake;

  bool _showBlast = false;
  bool get showBlast => this._showBlast;

  Future<void> checkAns(int selectedIndex, int correctAnsIndex) async {
    _isAnsnwred = true;
    if (selectedIndex == correctAnsIndex) {
      _isCorectAns == true;
      _showBlast = true;

      notifyListeners();
    } else {
      _shake = true;
      notifyListeners();
    }
    _selecctedIndex = selectedIndex;
    _answredIndex = correctAnsIndex;
    notifyListeners();
    Future.delayed(Duration(seconds: 1), () {
      _shake = false;
      _showBlast = false;
      notifyListeners();
    });
    log("ans index is = $_answredIndex");
    log("ans index is = $_selecctedIndex");
  }

  //// serivice calls

  ApiProvider _apiProvider = ApiProvider();

  Future<Null> submitQuiz(int quizId, String submittedAns) async {
    String _token = await _apiProvider.getToken();
    String _requestJson = json.encode(
        {"quiz_id": quizId, "selected_option": submittedAns, "token": _token});
    final response = await _apiProvider.post(submitQuizAnswer, _requestJson);
    if (response != null) {
      print(response);
    }
  }

  // bool _ispollAnswred = false;
  // bool get ispollAnswred => _ispollAnswred;

  void submitPollAnswer({required int quizId, required String answer}) async {
    String _token = await _apiProvider.getToken();
    String _requestJson = json.encode(
        {"quiz_id": quizId, "selected_option": "$answer", "token": "$_token"});
    final response = await _apiProvider.post(poll_Submit_Answer, _requestJson);
    if (response != null) {
      print(response);
      if (response["StatusCode"] == "200") {}
    }
  }
}
