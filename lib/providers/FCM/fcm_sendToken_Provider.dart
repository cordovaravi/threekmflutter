import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class FCMProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();

  Future<Null> sendToken(requestJson) async {
    final response = await _apiProvider.post(attchToekn, requestJson);
    if (response != null) {
      log(response.toString());
    }
  }
}
