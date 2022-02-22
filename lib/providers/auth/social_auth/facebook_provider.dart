import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:threekm/UI/main/navigation.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:threekm/utils/api_paths.dart';

class FaceAuthProvider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  String? accessToken;

  Future<UserCredential?> _signInWithFacebook(context) async {
    // Trigger the sign-in flow
    // try {
    //   final LoginResult loginResult = await FacebookAuth.instance
    //       .login(loginBehavior: LoginBehavior.webOnly);

    //   // Create a credential from the access token
    //   final OAuthCredential facebookAuthCredential =
    //       FacebookAuthProvider.credential(loginResult.accessToken?.token??"");

    //   // Once signed in, return the UserCredential
    //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    // } on FirebaseAuthException catch (e) {
    //   // TODO
    //   hideLoading();
    //   CustomSnackBar(context, Text("Error from FB API"));
    // }
    // return null;

    //changelog Feb
    final LoginResult result = await FacebookAuth.instance.login();
    if (result.status == LoginStatus.success) {
      // Create a credential from the access token
      final OAuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
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
        if (response != null) {
          SharedPreferences _prefs = await SharedPreferences.getInstance();
          _prefs.setString(
              "userfname", response.user!.displayName!.split(" ").first);
          _prefs.setString(
              "userlname", response.user!.displayName!.split(" ").last);
          _prefs.setString("user_email", response.user!.email.toString());
          _prefs.setString("avatar", response.user?.photoURL ?? "");
          log("${response.user?.photoURL}");
        }
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
            //CustomSnackBar(context, Text("User Registered successfully"));
            final prefs = await SharedPreferences.getInstance();
            prefs.setString("token",
                registerResponse['data']['result']['user_data']['token'] ?? "");
            prefs.setString(
                "userlname",
                registerResponse['data']['result']['user_data']['lastname'] ??
                    "");
            prefs.setString(
                "userfname",
                registerResponse['data']['result']['user_data']['firstname'] ??
                    "");
            // prefs.setString(
            //     "avatar",
            //     registerResponse['data']['result']['user_data']['avatar'] ??
            //         "");
            prefs.setString(
                "gender",
                registerResponse['data']['result']['user_data']['gender'] ??
                    "");
            prefs.setString("email",
                registerResponse['data']['result']['user_data']['email'] ?? "");
            // prefs.setString("dob",
            //     registerResponse['data']['result']['user_data']['dob'] ?? "");
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => TabBarNavigation()),
                (route) => false);
          } else {
            CustomSnackBar(context, Text("Google Api error"));
          }
        }
      }
    } on Exception catch (e) {
      log(e.toString());
      if (e.toString() ==
          "[firebase_auth/account-exists-with-different-credential] An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address.") {
        CustomSnackBar(
            context,
            Text(
                "Your Email is Already registered with us with Google login, Please Login with google"),
            duration: Duration(seconds: 7));
      }
      hideLoading();
    }
  }
}
