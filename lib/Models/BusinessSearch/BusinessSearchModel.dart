// To parse this JSON data, do
//
//     final businessSearchModel = businessSearchModelFromJson(jsonString);

import 'dart:convert';

BusinessSearchModel businessSearchModelFromJson(String str) =>
    BusinessSearchModel.fromJson(json.decode(str));

class BusinessSearchModel {
  BusinessSearchModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory BusinessSearchModel.fromJson(Map<String, dynamic> json) =>
      BusinessSearchModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"],
        error: json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.result,
  });

  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );
}

class Result {
  Result({
    this.creators,
  });

  List<Creator>? creators;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        creators: json["creators"] == null
            ? null
            : List<Creator>.from(
                json["creators"].map((x) => Creator.fromJson(x))),
      );
}

class Creator {
  Creator({
    this.creatorId,
    this.firstname,
    this.lastname,
    this.businessName,
    this.image,
    this.tags,
    this.rating,
    this.star,
  });

  int? creatorId;
  String? firstname;
  String? lastname;
  String? businessName;
  String? image;
  List<String>? tags;
  String? rating;
  bool? star;

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        creatorId: json["creator_id"] == null ? null : json["creator_id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        businessName:
            json["business_name"] == null ? null : json["business_name"],
        image: json["image"] == null ? null : json["image"],
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
        rating: json["rating"] == null ? null : json["rating"],
        star: json["star"] == null ? null : json["star"],
      );
}
