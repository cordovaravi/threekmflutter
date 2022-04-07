// To parse this JSON data, do
//
//     final newsFeedBottomModel = newsFeedBottomModelFromJson(jsonString);

import 'dart:convert';

NewsFeedBottomModel newsFeedBottomModelFromJson(String str) =>
    NewsFeedBottomModel.fromJson(json.decode(str));

//String newsFeedBottomModelToJson(NewsFeedBottomModel data) => json.encode(data.toJson());

class NewsFeedBottomModel {
  NewsFeedBottomModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory NewsFeedBottomModel.fromJson(Map<String, dynamic> json) =>
      NewsFeedBottomModel(
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
  List<dynamic>? tags;
  List<dynamic>? areas;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        posts: json["posts"] == null
            ? null
            : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        tags: json["tags"] == null
            ? null
            : List<dynamic>.from(json["tags"].map((x) => x)),
        areas: json["areas"] == null
            ? null
            : List<dynamic>.from(json["areas"].map((x) => x)),
      );

  // Map<String, dynamic> toJson() => {
  //     "posts": posts == null ? null : List<dynamic>.from(posts.map((x) => x.toJson())),
  //     "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
  //     "areas": areas == null ? null : List<dynamic>.from(areas.map((x) => x)),
  // };
}

class Post {
  Post({
    this.postId,
    this.headline,
    this.story,
    this.images,
    this.videos,
    this.type,
    this.likes,
    this.comments,
    this.createdDate,
    this.views,
    this.shares,
    this.impressions,
  });

  int? postId;
  String? headline;
  String? story;
  List<String>? images;
  List<Video>? videos;
  Type? type;
  int? likes;
  List<Comment>? comments;
  String? createdDate;
  int? views;
  int? shares;
  int? impressions;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"] == null ? null : json["post_id"],
        headline: json["headline"] == null ? null : json["headline"],
        story: json["story"] == null ? null : json["story"],
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"].map((x) => x)),
        videos: json["videos"] == null
            ? null
            : List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
        // type: json["type"] == null ? null : json["type"],
        likes: json["likes"] == null ? null : json["likes"],
        comments: json["comments"] == null
            ? null
            : List<Comment>.from(
                json["comments"].map((x) => Comment.fromJson(x))),
        createdDate: json["created_date"] == null ? null : json["created_date"],
        views: json["views"] == null ? null : json["views"],
        shares: json["shares"] == null ? null : json["shares"],
        impressions: json["impressions"] == null ? null : json["impressions"],
      );
}

class Comment {
  Comment({
    this.entityId,
    this.comment,
    this.id,
    this.commentId,
  });

  int? entityId;
  String? comment;
  String? id;
  String? commentId;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        entityId: json["entity_id"] == null ? null : json["entity_id"],
        comment: json["comment"] == null ? null : json["comment"],
        id: json["_id"] == null ? null : json["_id"],
        commentId: json["id"] == null ? null : json["id"],
      );
}

enum Type { POST }

final typeValues = EnumValues({"Post": Type.POST});

class Video {
  Video({
    this.src,
    this.thumbnail,
    this.player,
    this.vimeoUrl,
    this.width,
    this.height,
  });

  String? src;
  String? thumbnail;
  String? player;
  String? vimeoUrl;
  int? width;
  int? height;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        src: json["src"] == null ? null : json["src"],
        thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
        player: json["player"] == null ? null : json["player"],
        vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
        width: json["width"] == null ? null : json["width"],
        height: json["height"] == null ? null : json["height"],
      );

  Map<String, dynamic> toJson() => {
        "src": src == null ? null : src,
        "thumbnail": thumbnail == null ? null : thumbnail,
        //"player": player == null ? null : playerValues.reverse[player],
        "vimeo_url": vimeoUrl == null ? null : vimeoUrl,
        "width": width == null ? null : width,
        "height": height == null ? null : height,
      };
}

// enum Player { VIMEO }

// final playerValues = EnumValues({
//     "vimeo": Player.VIMEO
// });

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  // Map<T, String> get reverse {
  //     if (reverseMap == null) {
  //        // reverseMap = map.map((k, v) => new MapEntry(v, k));
  //     }
  //     return reverseMap;
  // }
}
