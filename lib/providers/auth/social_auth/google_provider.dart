import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:threekm/commenwidgets/CustomSnakBar.dart';
import 'package:threekm/commenwidgets/commenwidget.dart';
import 'package:threekm/networkservice/Api_Provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:threekm/utils/api_paths.dart';

class GoogleSignInprovider extends ChangeNotifier {
  ApiProvider _apiProvider = ApiProvider();
  String? accessToken;

  Future<dynamic> _signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: [
      'email',
      "https://www.googleapis.com/auth/userinfo.profile"
    ]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<dynamic> handleSignIn(context) async {
    try {
      showLoading();
      UserCredential? response = await _signInWithGoogle();
      if (response != null) {
        await response.user!.getIdTokenResult().then((value) {
          accessToken = value.token;
          notifyListeners();
        });
        String requestJson = json.encode({
          "platform": "google-plus",
          "platform_response": {
            "accessToken": accessToken,
            "expires": response.user!.metadata.creationTime!
                .add(Duration(days: 21))
                .toIso8601String(),
            "expires_in": "",
            "email": response.user!.email,
            "userId": response.user!.uid,
            "displayName": response.user!.displayName,
            "familyName": response.user!.displayName!.split(" ").last,
            "givenName": response.user!.displayName!.split(" ").first
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


























// static Future<User?> _signInWithGoogle() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user;

  //   final GoogleSignIn googleSignIn = GoogleSignIn();

  //   final GoogleSignInAccount? googleSignInAccount =
  //       await googleSignIn.signIn();

  //   if (googleSignInAccount != null) {
  //     final GoogleSignInAuthentication googleSignInAuthentication =
  //         await googleSignInAccount.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleSignInAuthentication.accessToken,
  //       idToken: googleSignInAuthentication.idToken,
  //     );

  //     try {
  //       final UserCredential userCredential =
  //           await auth.signInWithCredential(credential);

  //       user = userCredential.user;
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'account-exists-with-different-credential') {
  //         // handle the error here
  //       } else if (e.code == 'invalid-credential') {
  //         // handle the error here
  //       }
  //     } catch (e) {
  //       // handle the error here
  //     }
  //   }

  //   return user;
  // }
