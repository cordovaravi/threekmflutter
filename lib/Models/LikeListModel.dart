// To parse this JSON data, do
//
//     final likeListModel = likeListModelFromJson(jsonString);

import 'dart:convert';

LikeListModel likeListModelFromJson(String str) =>
    LikeListModel.fromJson(json.decode(str));

class LikeListModel {
  LikeListModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory LikeListModel.fromJson(Map<String, dynamic> json) => LikeListModel(
        status: json["status"],
        message: json["message"],
        error: json["error"],
        data: Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.result,
  });

  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: Result.fromJson(json["result"]),
      );
}

class Result {
  Result({
    this.count,
    this.users,
    this.anonymousCount,
  });

  int? count;
  List<User>? users;
  int? anonymousCount;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        count: json["count"],
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
        anonymousCount: json["anonymous_count"],
      );
}

class User {
  User(
      {this.id,
      this.name,
      this.avatar,
      this.emotion,
      this.isUnknown,
      this.userType});

  int? id;
  String? name;
  String? avatar;
  String? emotion;
  bool? isUnknown;
  String? userType;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
        emotion: json["emotion"] ?? null,
        isUnknown: json["is_unknown"],
        userType: json["user_type"],
      );
}
