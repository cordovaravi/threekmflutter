// To parse this JSON data, do
//
//     final selfProfileModel = selfProfileModelFromJson(jsonString);

import 'dart:convert';

import 'dart:developer';

import 'package:threekm/Models/newsByCategories_model.dart';

SelfProfileModel selfProfileModelFromJson(String str) =>
    SelfProfileModel.fromJson(json.decode(str));

class SelfProfileModel {
  SelfProfileModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory SelfProfileModel.fromJson(Map<String, dynamic> json) =>
      SelfProfileModel(
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
    this.author,
    this.posts,
  });

  Author? author;
  List<Post>? posts;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        posts: json["posts"] == null
            ? null
            : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
      );
}

class Author {
  Author({
    this.id,
    this.name,
    this.image,
    this.type,
    this.isVerified,
    this.about,
    this.followers,
    this.following,
    this.totalPosts,
  });

  int? id;
  String? name;
  String? image;
  String? type;
  bool? isVerified;
  String? about;
  int? followers;
  int? following;
  int? totalPosts;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        type: json["type"] == null ? null : json["type"],
        isVerified: json["is_verified"] == null ? null : json["is_verified"],
        about: json["about"],
        followers: json["followers"] == null ? null : json["followers"],
        following: json["following"] == null ? null : json["following"],
        totalPosts: json["total_posts"] == null ? null : json["total_posts"],
      );
}

// enum AuthorClassificationEnum { USER, TYPE_USER }

// final authorClassificationEnumValues = EnumValues({
//   "User": AuthorClassificationEnum.TYPE_USER,
//   "user": AuthorClassificationEnum.USER
// });

// class Post {
//   Post({
//     this.postId,
//     this.submittedHeadline,
//     this.submittedStory,
//     this.headline,
//     this.story,
//     this.images,
//     this.videos,
//     this.type,
//     this.tags,
//     this.author,
//     this.authorType,
//     this.authorClassification,
//     this.status,
//     this.views,
//     this.createdDate,
//     this.context,
//     this.likes,
//     this.comments,
//     this.id,
//     this.preheaderLike,
//     this.preheaderComment,
//     this.latestComment,
//     this.isVerified,
//     this.isLiked,
//     this.emotion,
//     this.itemType,
//   });

//   int? postId;
//   String? submittedHeadline;
//   String? submittedStory;
//   String? headline;
//   String? story;
//   List<String>? images;
//   List<Video>? videos;
//   PurpleType? type;
//   List<String>? tags;
//   Author? author;
//   AuthorClassificationEnum? authorType;
//   AuthorClassificationEnum? authorClassification;
//   Status? status;
//   int? views;
//   String? createdDate;
//   dynamic context;
//   int? likes;
//   int? comments;
//   int? id;
//   String? preheaderLike;
//   String? preheaderComment;
//   LatestComment? latestComment;
//   bool? isVerified;
//   bool? isLiked;
//   ItemType? itemType;

//   String? emotion;

//   factory Post.fromJson(Map<String, dynamic> json) => Post(
//         postId: json["post_id"] == null ? null : json["post_id"],
//         submittedHeadline: json["submitted_headline"] == null
//             ? null
//             : json["submitted_headline"],
//         submittedStory:
//             json["submitted_story"] == null ? null : json["submitted_story"],
//         headline: json["headline"] == null ? null : json["headline"],
//         story: json["story"] == null ? null : json["story"],
//         images: json["images"] == null
//             ? null
//             : List<String>.from(json["images"].map((x) => x)),
//         videos: json["videos"] == null
//             ? null
//             : List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
//         type: json["type"] == null ? null : purpleTypeValues.map[json["type"]],
//         tags: json["tags"] == null
//             ? null
//             : List<String>.from(json["tags"].map((x) => x)),
//         author: json["author"] == null ? null : Author.fromJson(json["author"]),
//         authorType: json["author_type"] == null
//             ? null
//             : authorClassificationEnumValues.map[json["author_type"]],
//         authorClassification: json["author_classification"] == null
//             ? null
//             : authorClassificationEnumValues.map[json["author_classification"]],
//         status:
//             json["status"] == null ? null : statusValues.map[json["status"]],
//         views: json["views"] == null ? null : json["views"],
//         createdDate: json["created_date"] == null ? null : json["created_date"],
//         context: json["context"],
//         likes: json["likes"] == null ? null : json["likes"],
//         comments: json["comments"] == null ? null : json["comments"],
//         id: json["id"],
//         preheaderLike:
//             json["preheader_like"] == null ? null : json["preheader_like"],
//         preheaderComment: json["preheader_comment"] == null
//             ? null
//             : json["preheader_comment"],
//         latestComment: json["latest_comment"] == null
//             ? null
//             : LatestComment.fromJson(json["latest_comment"]),
//         isVerified: json["is_verified"] == null ? null : json["is_verified"],
//         isLiked: json["is_liked"] == null ? null : json["is_liked"],
//         emotion: json["emotion"] ?? "",
//         itemType: json["item_type"] == null
//             ? null
//             : itemTypeValues.map[json["item_type"]],
//       );
// }

// enum ItemType { POST }

// final itemTypeValues = EnumValues({"post": ItemType.POST});

// class LatestComment {
//   LatestComment();

//   factory LatestComment.fromJson(Map<String, dynamic> json) => LatestComment();

//   Map<String, dynamic> toJson() => {};
// }

// enum Status { SUBMITTED, REJECTED }

// final statusValues =
//     EnumValues({"rejected": Status.REJECTED, "submitted": Status.SUBMITTED});

// enum PurpleType { POST }

// final purpleTypeValues = EnumValues({"Post": PurpleType.POST});

// class Video {
//   Video({
//     this.src,
//     this.player,
//     this.thumbnail,
//     this.vimeoUrl,
//     this.width,
//     this.height,
//   });

//   dynamic src;
//   String? player;
//   String? thumbnail;
//   String? vimeoUrl;
//   int? width;
//   int? height;

//   factory Video.fromJson(Map<String, dynamic> json) => Video(
//         src: json["src"],
//         player: json["player"] == null ? null : json["player"],
//         thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
//         vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
//         width: json["width"] == null ? null : json["width"],
//         height: json["height"] == null ? null : json["height"],
//       );
// }

// class SrcClass {
//   SrcClass({
//     this.thumbnail,
//   });

//   String? thumbnail;

//   factory SrcClass.fromJson(Map<String, dynamic> json) => SrcClass(
//         thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
//       );

//   Map<String, dynamic> toJson() => {
//         "thumbnail": thumbnail == null ? null : thumbnail,
//       };
// }

// class EnumValues<T> {
//   Map<String, T> map;
//   Map<T, String>? reverseMap;

//   EnumValues(this.map);

//   Map<T, String> get reverse {
//     if (reverseMap == null) {
//       reverseMap = map.map((k, v) => new MapEntry(v, k));
//     }
//     return reverseMap!;
//   }
// }

// class Post {
//   Post({
//     this.postId,
//     this.submittedHeadline,
//     this.submittedStory,
//     this.headline,
//     this.story,
//     this.images,
//     this.videos,
//     this.type,
//     this.tags,
//     this.author,
//     this.authorType,
//     this.authorClassification,
//     this.status,
//     this.views,
//     this.createdDate,
//     this.context,
//     this.likes,
//     this.comments,
//     this.id,
//     this.isVerified,
//     this.isLiked,
//     this.itemType,
//     this.preheaderLike,
//     this.preheaderComment,
//     this.latestComment,
//     this.emotion,
//   });

//   int? postId;
//   String? submittedHeadline;
//   String? submittedStory;
//   String? headline;
//   String? story;
//   List<String>? images;
//   List<Video>? videos;
//   String? type;
//   List<String>? tags;
//   Author? author;
//   String? authorType;
//   String? authorClassification;
//   String? status;
//   int? views;
//   String? createdDate;
//   dynamic context;
//   int? likes;
//   int? comments;
//   dynamic id;
//   bool? isVerified;
//   bool? isLiked;
//   String? itemType;
//   String? preheaderLike;
//   String? preheaderComment;
//   LatestComment? latestComment;
//   String? emotion;

//   factory Post.fromJson(Map<String, dynamic> json) {
//     log('${json["post_id"]}================');

//     return Post(
//       postId: json["post_id"] == null ? null : json["post_id"],
//       submittedHeadline: json["submitted_headline"] == null
//           ? null
//           : json["submitted_headline"],
//       submittedStory:
//           json["submitted_story"] == null ? null : json["submitted_story"],
//       headline: json["headline"] == null ? null : json["headline"],
//       story: json["story"] == null ? null : json["story"],
//       images: json["images"] == null
//           ? null
//           : List<String>.from(json["images"].where((x) => x is String)),
//       videos: json["videos"] == null
//           ? null
//           : List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
//       type: json["type"] == null ? null : json["type"],
//       tags: json["tags"] == null
//           ? null
//           : List<String>.from(json["tags"].map((x) => x)),
//       author: json["author"] == null ? null : Author.fromJson(json["author"]),
//       authorType: json["author_type"] == null ? null : json["author_type"],
//       authorClassification: json["author_classification"] == null
//           ? null
//           : json["author_classification"],
//       status: json["status"] == null ? null : json["status"],
//       views: json["views"] == null ? null : json["views"],
//       createdDate: json["created_date"] == null ? null : json["created_date"],
//       context: json["context"],
//       likes: json["likes"] == null ? null : json["likes"],
//       comments: json["comments"] == null ? null : json["comments"],
//       id: json["id"],
//       isVerified: json["is_verified"] == null ? null : json["is_verified"],
//       isLiked: json["is_liked"] == null ? null : json["is_liked"],
//       itemType: json["item_type"] == null ? null : json["item_type"],
//       preheaderLike: json["preheader_like"],
//       preheaderComment: json["preheader_comment"],
//       latestComment: json['latest_comment'] == null
//           ? null
//           : LatestComment.fromJson(json['latest_comment']),
//       emotion: json['emotion'] ?? "",
//     );
//   }
// }

// class Video {
//   Video({
//     this.src,
//     this.thumbnail,
//     this.player,
//     this.vimeoUrl,
//     this.width,
//     this.height,
//   });

//   String? src;
//   String? thumbnail;
//   String? player;
//   String? vimeoUrl;
//   int? width;
//   int? height;

//   factory Video.fromJson(Map<String, dynamic> json) => Video(
//         src: json["src"] == null ? null : json["src"],
//         thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
//         player: json["player"] == null ? null : json["player"],
//         vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
//         width: json["width"] == null ? null : json["width"],
//         height: json["height"] == null ? null : json["height"],
//       );
// }

// class LatestComment {
//   LatestComment({
//     this.comment,
//     this.user,
//   });
//   String? comment;
//   User? user;

//   LatestComment.fromJson(Map<String, dynamic> json) {
//     comment = json['comment'] ?? "";
//     user = json['user'] != null ? User.fromJson(json['user']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['comment'] = comment;
//     _data['user'] = user?.toJson();
//     return _data;
//   }
// }

// class User {
//   User({
//     required this.userId,
//     required this.name,
//     required this.avatar,
//   });
//   late final int userId;
//   late final String name;
//   late final String avatar;

//   User.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     name = json['name'];
//     avatar = json['avatar'];
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['user_id'] = userId;
//     _data['name'] = name;
//     _data['avatar'] = avatar;
//     return _data;
//   }
// }
