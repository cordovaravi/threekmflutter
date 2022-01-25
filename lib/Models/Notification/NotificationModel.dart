// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  NotificationModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  NotificationModelData? data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"],
        error: json["error"],
        data: json["data"] == null
            ? null
            : NotificationModelData.fromJson(json["data"]),
      );
}

class NotificationModelData {
  NotificationModelData({
    this.result,
  });

  Result? result;

  factory NotificationModelData.fromJson(Map<String, dynamic> json) =>
      NotificationModelData(
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );
}

class Result {
  Result({
    this.notifications,
  });

  List<NotificationClass>? notifications;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        notifications: json["notifications"] == null
            ? null
            : List<NotificationClass>.from(json["notifications"]
                .map((x) => NotificationClass.fromJson(x))),
      );
}

class NotificationClass {
  NotificationClass({
    this.title,
    this.body,
    this.image,
    this.type,
    this.data,
    this.date,
  });

  String? title;
  String? body;
  String? image;
  Type? type;
  NotificationData? data;
  String? date;

  factory NotificationClass.fromJson(Map<String, dynamic> json) =>
      NotificationClass(
        title: json["title"] == null ? null : json["title"],
        body: json["body"] == null ? null : json["body"],
        image: json["image"] == null ? null : json["image"],
        type: json["type"] == null ? null : typeValues.map[json["type"]],
        data: json["data"] == null
            ? null
            : NotificationData.fromJson(json["data"]),
        date: json["date"] == null ? null : json["date"],
      );
}

class NotificationData {
  NotificationData({
    this.postId,
  });

  String? postId;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        postId: json["post_id"] == null ? null : json["post_id"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId == null ? null : postId,
      };
}

enum Type { POST }

final typeValues = EnumValues({"post": Type.POST});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
