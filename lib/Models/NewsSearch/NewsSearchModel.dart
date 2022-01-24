// To parse this JSON data, do
//
//     final newsSearchModel = newsSearchModelFromJson(jsonString);

import 'dart:convert';

NewsSearchModel newsSearchModelFromJson(String str) =>
    NewsSearchModel.fromJson(json.decode(str));

class NewsSearchModel {
  NewsSearchModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory NewsSearchModel.fromJson(Map<String, dynamic> json) =>
      NewsSearchModel(
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
    this.posts,
    this.tags,
    this.areas,
  });

  List<Post>? posts;
  List<String>? tags;
  List<dynamic>? areas;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        posts: json["posts"] == null
            ? null
            : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
        areas: json["areas"] == null
            ? null
            : List<dynamic>.from(json["areas"].map((x) => x)),
      );
}

class Post {
  Post({
    this.postId,
    this.headline,
    this.story,
    this.images,
    this.videos,
    this.type,
    this.createdDate,
  });

  int? postId;
  String? headline;
  String? story;
  List<String>? images;
  List<dynamic>? videos;
  Type? type;
  String? createdDate;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"] == null ? null : json["post_id"],
        headline: json["headline"] == null ? null : json["headline"],
        story: json["story"] == null ? null : json["story"],
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"].map((x) => x)),
        videos: json["videos"] == null
            ? null
            : List<dynamic>.from(json["videos"].map((x) => x)),
        type: json["type"] == null ? null : typeValues.map[json["type"]],
        createdDate: json["created_date"] == null ? null : json["created_date"],
      );
}

enum Type { POST }

final typeValues = EnumValues({"Post": Type.POST});

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
