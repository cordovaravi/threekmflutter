// author: Prateek Aher
import 'package:flutter/material.dart';

import '../../networkservice/Api_Provider.dart';

class EditPostProvider extends ChangeNotifier {
  final ApiProvider _apiProvider = ApiProvider();

  TextEditingController _headlineController = TextEditingController();
  TextEditingController _storyController = TextEditingController();

  @override
  void dispose() {
    _headlineController.dispose();
    _storyController.dispose();
    super.dispose();
  }
}
