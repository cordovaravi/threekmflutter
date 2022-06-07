import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/providers/Global/logged_in_or_not.dart';
import 'package:threekm/utils/api_paths.dart';

class FCMProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();

  Future<Null> sendToken(requestJson) async {
    if (await getAuthStatus()) {
      log(attachTokenWithUser);
      final response =
          await _apiProvider.post(attachTokenWithUser, requestJson);
      if (response != null) {
        log(response.toString());
      }
    } else {
      log(attchToekn);
      final response = await _apiProvider.post(attchToekn, requestJson);
      if (response != null) {
        log(response.toString());
      }
    }
  }
}
