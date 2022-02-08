import 'package:flutter/material.dart';

class LocalPlayerProvider extends ChangeNotifier {
  String? _videoPath;
  String? get videoPath => this._videoPath;
  void pathChanged({required String path}) {
    _videoPath = path;
    notifyListeners();
  }
}
