import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class FaceAuthProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  String? accessToken;

  Future<dynamic> _signInWithFacebook(context) async {
    // Trigger the sign-in flow
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      // TODO
      hideLoading();
      CustomSnackBar(context, Text("Error from FB API"));
    }
    return null;
  }

  Future<dynamic> handleSignIn(context) async {
    try {
      showLoading();
      UserCredential? response = await _signInWithFacebook(context);
      if (response != null) {
        await response.user!.getIdTokenResult().then((value) {
          accessToken = value.token;
          notifyListeners();
        });
        String requestJson = json.encode({
          "platform": "facebook",
          "platform_response": {
            "email": response.user!.email,
            "first_name": response.user!.displayName!.split(" ").first,
            "id": response.user!.uid,
            "last_name": response.user!.displayName!.split(" ").last,
            "name": response.user!.displayName
          }
        });
        final registerResponse =
            await _apiProvider.auth(social_login, requestJson);
        if (registerResponse != null) {
          hideLoading();
          if (registerResponse['status'] == 'success') {
            CustomSnackBar(context, Text("User Registered successfully"));
          } else {
            CustomSnackBar(context, Text("Google Api error"));
          }
        }
      }
    } on Exception catch (e) {
      hideLoading();
    }
  }
}
