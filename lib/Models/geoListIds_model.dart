// To parse this JSON data, do
//
//     final geoListIds = geoListIdsFromJson(jsonString);

import 'dart:convert';

GeoListIds geoListIdsFromJson(String str) =>
    GeoListIds.fromJson(json.decode(str));

class GeoListIds {
  GeoListIds({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory GeoListIds.fromJson(Map<String, dynamic> json) => GeoListIds(
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
    this.posts,
    this.tags,
    this.areas,
  });

  List<Post>? posts;
  List<String>? tags;
  List<Area>? areas;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        tags: List<String>.from(json["tags"].map((x) => x)),
        areas: List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
      );
}

class Area {
  Area({
    this.id,
    this.area,
    this.latitude,
    this.longitude,
    this.dis,
  });

  String? id;
  String? area;
  double? latitude;
  double? longitude;
  double? dis;

  factory Area.fromJson(Map<String, dynamic> json) => Area(
        id: json["_id"],
        area: json["area"],
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        dis: json["dis"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "area": area,
        "latitude": latitude,
        "longitude": longitude,
        "dis": dis,
      };
}

class Post {
  Post({
    this.postId,
  });

  int? postId;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
      };
}
