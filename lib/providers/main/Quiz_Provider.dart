import 'package:flutter/material.dart';

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

  Future<void> checkAns(int selectedIndex, int correctAnsIndex) async {
    _isAnsnwred = true;
    // if (selectedIndex == correctAnsIndex) {
    //   _isCorectAns == true;
    //   notifyListeners();
    // }
    _selecctedIndex = selectedIndex;
    _answredIndex = correctAnsIndex;
    notifyListeners();
  }
}
