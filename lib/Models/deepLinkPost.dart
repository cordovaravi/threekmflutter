// To parse this JSON data, do
//
//     final deepLinkPost = deepLinkPostFromJson(jsonString);

import 'dart:convert';

DeepLinkPost deepLinkPostFromJson(String str) =>
    DeepLinkPost.fromJson(json.decode(str));

class DeepLinkPost {
  DeepLinkPost({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory DeepLinkPost.fromJson(Map<String, dynamic> json) => DeepLinkPost(
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
    this.post,
  });

  Post? post;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        post: Post.fromJson(json["post"]),
      );
}

class Post {
  Post(
      {this.postId,
      this.submittedHeadline,
      this.submittedStory,
      this.headline,
      this.story,
      this.images,
      this.videos,
      this.type,
      this.tags,
      this.areas,
      this.cities,
      this.states,
      this.latitude,
      this.longitude,
      this.location,
      this.author,
      this.authorType,
      this.authorClassification,
      this.approver,
      this.business,
      this.products,
      this.impressions,
      this.views,
      this.postCreatedDate,
      this.isUgc,
      this.likes,
      this.comments,
      this.locations,
      this.id,
      this.isLiked,
      this.shares,
      this.attachedBusiness,
      this.itemType,
      this.slugHeadline,
      this.displayDate,
      this.emotion,
      this.listEmotions});

  int? postId;
  String? submittedHeadline;
  String? submittedStory;
  String? headline;
  String? story;
  List<String>? images;
  List<Video>? videos;
  String? type;
  List<String>? tags;
  String? areas;
  List<dynamic>? cities;
  List<dynamic>? states;
  double? latitude;
  double? longitude;
  String? location;
  Author? author;
  String? authorType;
  String? authorClassification;
  Approver? approver;
  List<dynamic>? business;
  List<dynamic>? products;
  int? impressions;
  int? views;
  DateTime? postCreatedDate;
  String? displayDate;
  bool? isUgc;
  int? likes;
  List<Comment>? comments;
  List<Location>? locations;
  dynamic id;
  bool? isLiked;
  int? shares;
  List<dynamic>? attachedBusiness;
  String? itemType;
  String? slugHeadline;
  String? emotion;
  List<String>? listEmotions;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
      postId: json["post_id"],
      submittedHeadline: json["submitted_headline"],
      submittedStory: json["submitted_story"],
      headline: json["headline"],
      story: json["story"],
      images: List<String>.from(json["images"].map((x) => x)),
      videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
      type: json["type"],
      tags: List<String>.from(json["tags"].map((x) => x)),
      areas: json["areas"],
      cities: List<dynamic>.from(json["cities"].map((x) => x)),
      states: List<dynamic>.from(json["states"].map((x) => x)),
      latitude: json["latitude"] != null ? json["latitude"].toDouble() : null,
      longitude:
          json["longitude"] != null ? json["longitude"].toDouble() : null,
      location: json["location"],
      author: Author.fromJson(json["author"]),
      authorType: json["author_type"],
      authorClassification: json["author_classification"],
      //approver: Approver.fromJson(json["approver"]),
      business: List<dynamic>.from(json["business"].map((x) => x)),
      products: List<dynamic>.from(json["products"].map((x) => x)),
      impressions: json["impressions"],
      views: json["views"],
      postCreatedDate: DateTime.parse(json["post_created_date"]),
      displayDate: json["display_date"],
      isUgc: json["is_ugc"],
      likes: json["likes"],
      comments:
          List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
      locations: List<Location>.from(
          json["locations"].map((x) => Location.fromJson(x))),
      id: json["id"],
      isLiked: json["is_liked"],
      shares: json["shares"],
      attachedBusiness:
          List<dynamic>.from(json["attached_business"].map((x) => x)),
      itemType: json["item_type"],
      slugHeadline: json["slug_headline"],
      emotion: json["emotion"] ?? "",
      listEmotions: json["list_emotions"] != null
          ? List<String>.from(json["list_emotions"].map((x) => x))
          : []);
}

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
        "src": src,
        "thumbnail": thumbnail,
        "player": player,
        "vimeo_url": vimeoUrl,
        "width": width,
        "height": height,
      };
}

class Approver {
  Approver({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Approver.fromJson(Map<String, dynamic> json) => Approver(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Author {
  Author({
    this.id,
    this.name,
    this.image,
    this.type,
  });

  int? id;
  String? name;
  String? image;
  String? type;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
      };
}

class Comment {
  Comment({
    this.entityId,
    this.comment,
    this.userId,
    this.id,
    this.commentId,
    this.username,
    this.avatar,
  });

  int? entityId;
  String? comment;
  int? userId;
  String? id;
  String? commentId;
  String? username;
  String? avatar;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        entityId: json["entity_id"],
        comment: json["comment"],
        userId: json["user_id"],
        id: json["_id"],
        commentId: json["id"],
        username: json["username"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "entity_id": entityId,
        "comment": comment,
        "user_id": userId,
        "_id": id,
        "id": commentId,
        "username": username,
        "avatar": avatar,
      };
}

class Location {
  Location({
    this.postId,
    this.area,
    this.city,
    this.state,
    this.isDeleted,
    this.id,
    this.locationId,
  });

  int? postId;
  String? area;
  String? city;
  String? state;
  bool? isDeleted;
  String? id;
  String? locationId;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        postId: json["post_id"],
        area: json["area"],
        city: json["city"],
        state: json["state"],
        isDeleted: json["is_deleted"],
        id: json["_id"],
        locationId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "area": area,
        "city": city,
        "state": state,
        "is_deleted": isDeleted,
        "_id": id,
        "id": locationId,
      };
}
