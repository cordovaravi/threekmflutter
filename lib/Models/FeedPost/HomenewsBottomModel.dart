// // To parse this JSON data, do
// //
// //     final newsFeedBottomModel = newsFeedBottomModelFromJson(jsonString);

// import 'dart:convert';

// NewsFeedBottomModel newsFeedBottomModelFromJson(String str) =>
//     NewsFeedBottomModel.fromJson(json.decode(str));

// //String newsFeedBottomModelToJson(NewsFeedBottomModel data) => json.encode(data.toJson());

// class NewsFeedBottomModel {
//   NewsFeedBottomModel({
//     this.status,
//     this.message,
//     this.error,
//     this.data,
//   });

//   String? status;
//   dynamic message;
//   dynamic error;
//   Data? data;

//   factory NewsFeedBottomModel.fromJson(Map<String, dynamic> json) =>
//       NewsFeedBottomModel(
//         status: json["status"] == null ? null : json["status"],
//         message: json["message"],
//         error: json["error"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );
// }

// // class Data {
// //   Data({
// //     this.result,
// //   });

// //   Result? result;

// //   factory Data.fromJson(Map<String, dynamic> json) => Data(
// //         result: json["result"] == null ? null : Result.fromJson(json["result"]),
// //       );
// // }

// // class Result {
// //   Result({
// //     this.posts,
// //     this.tags,
// //     this.areas,
// //   });

// //   List<Post>? posts;
// //   List<dynamic>? tags;
// //   List<dynamic>? areas;

// //   factory Result.fromJson(Map<String, dynamic> json) => Result(
// //         posts: json["posts"] == null
// //             ? null
// //             : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
// //         tags: json["tags"] == null
// //             ? null
// //             : List<dynamic>.from(json["tags"].map((x) => x)),
// //         areas: json["areas"] == null
// //             ? null
// //             : List<dynamic>.from(json["areas"].map((x) => x)),
// //       );

// //   // Map<String, dynamic> toJson() => {
// //   //     "posts": posts == null ? null : List<dynamic>.from(posts.map((x) => x.toJson())),
// //   //     "tags": tags == null ? null : List<dynamic>.from(tags.map((x) => x)),
// //   //     "areas": areas == null ? null : List<dynamic>.from(areas.map((x) => x)),
// //   // };
// // }

// // class Post {
// //   Post({
// //     this.postId,
// //     this.headline,
// //     this.story,
// //     this.images,
// //     this.videos,
// //     this.type,
// //     this.likes,
// //     this.comments,
// //     this.createdDate,
// //     this.views,
// //     this.shares,
// //     this.impressions,
// //   });

// //   int? postId;
// //   String? headline;
// //   String? story;
// //   List<String>? images;
// //   List<Video>? videos;
// //   Type? type;
// //   int? likes;
// //   List<Comment>? comments;
// //   String? createdDate;
// //   int? views;
// //   int? shares;
// //   int? impressions;

// //   factory Post.fromJson(Map<String, dynamic> json) => Post(
// //         postId: json["post_id"] == null ? null : json["post_id"],
// //         headline: json["headline"] == null ? null : json["headline"],
// //         story: json["story"] == null ? null : json["story"],
// //         images: json["images"] == null
// //             ? null
// //             : List<String>.from(json["images"].map((x) => x)),
// //         videos: json["videos"] == null
// //             ? null
// //             : List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
// //         // type: json["type"] == null ? null : json["type"],
// //         likes: json["likes"] == null ? null : json["likes"],
// //         comments: json["comments"] == null
// //             ? null
// //             : List<Comment>.from(
// //                 json["comments"].map((x) => Comment.fromJson(x))),
// //         createdDate: json["created_date"] == null ? null : json["created_date"],
// //         views: json["views"] == null ? null : json["views"],
// //         shares: json["shares"] == null ? null : json["shares"],
// //         impressions: json["impressions"] == null ? null : json["impressions"],
// //       );
// // }

// // class Comment {
// //   Comment({
// //     this.entityId,
// //     this.comment,
// //     this.id,
// //     this.commentId,
// //   });

// //   int? entityId;
// //   String? comment;
// //   String? id;
// //   String? commentId;

// //   factory Comment.fromJson(Map<String, dynamic> json) => Comment(
// //         entityId: json["entity_id"] == null ? null : json["entity_id"],
// //         comment: json["comment"] == null ? null : json["comment"],
// //         id: json["_id"] == null ? null : json["_id"],
// //         commentId: json["id"] == null ? null : json["id"],
// //       );
// // }

// // enum Type { POST }

// // final typeValues = EnumValues({"Post": Type.POST});

// // class Video {
// //   Video({
// //     this.src,
// //     this.thumbnail,
// //     this.player,
// //     this.vimeoUrl,
// //     this.width,
// //     this.height,
// //   });

// //   String? src;
// //   String? thumbnail;
// //   String? player;
// //   String? vimeoUrl;
// //   int? width;
// //   int? height;

// //   factory Video.fromJson(Map<String, dynamic> json) => Video(
// //         src: json["src"] == null ? null : json["src"],
// //         thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
// //         player: json["player"] == null ? null : json["player"],
// //         vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
// //         width: json["width"] == null ? null : json["width"],
// //         height: json["height"] == null ? null : json["height"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "src": src == null ? null : src,
// //         "thumbnail": thumbnail == null ? null : thumbnail,
// //         //"player": player == null ? null : playerValues.reverse[player],
// //         "vimeo_url": vimeoUrl == null ? null : vimeoUrl,
// //         "width": width == null ? null : width,
// //         "height": height == null ? null : height,
// //       };
// // }

// // // enum Player { VIMEO }

// // // final playerValues = EnumValues({
// // //     "vimeo": Player.VIMEO
// // // });

// // class EnumValues<T> {
// //   Map<String, T>? map;
// //   Map<T, String>? reverseMap;

// //   EnumValues(this.map);

// //   // Map<T, String> get reverse {
// //   //     if (reverseMap == null) {
// //   //        // reverseMap = map.map((k, v) => new MapEntry(v, k));
// //   //     }
// //   //     return reverseMap;
// //   // }
// // }

// class Data {
//   Data({
//     this.result,
//   });

//   Result? result;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         result: json["result"] == null ? null : Result.fromJson(json["result"]),
//       );
// }

// class Result {
//   Result({
//     this.posts,
//     this.tags,
//     this.areas,
//   });

//   List<Post>? posts;
//   List<dynamic>? tags;
//   List<dynamic>? areas;

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         posts: json["posts"] == null
//             ? null
//             : List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
//         tags: json["tags"] == null
//             ? null
//             : List<dynamic>.from(json["tags"].map((x) => x)),
//         areas: json["areas"] == null
//             ? null
//             : List<dynamic>.from(json["areas"].map((x) => x)),
//       );
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
//     this.publishFrom,
//     this.author,
//     this.authorType,
//     this.authorClassification,
//     this.status,
//     this.originalLanguage,
//     this.impressions,
//     this.views,
//     this.postCreatedDate,
//     this.createdDate,
//     this.context,
//     this.isUgc,
//     this.likes,
//     this.comments,
//     this.locations,
//     this.userDetails,
//     this.creatorDetails,
//     this.id,
//     this.isVerified,
//     this.isLiked,
//     this.areas,
//     this.slugHeadline,
//     this.shares,
//     this.origHeadline,
//     this.origStory,
//     this.itemType,
//   });

//   int? postId;
//   String? submittedHeadline;
//   String? submittedStory;
//   String? headline;
//   String? story;
//   List<String>? images;
//   List<Video>? videos;
//   PostType? type;
//   List<String>? tags;
//   DateTime? publishFrom;
//   Author? author;
//   AuthorTypeEnum? authorType;
//   AuthorClassification? authorClassification;
//   Status? status;
//   String? originalLanguage;
//   int? impressions;
//   int? views;
//   DateTime? postCreatedDate;
//   String? createdDate;
//   dynamic context;
//   bool? isUgc;
//   int? likes;
//   int? comments;
//   List<Location>? locations;
//   List<UserDetail>? userDetails;
//   List<CreatorDetail>? creatorDetails;
//   dynamic id;
//   bool? isVerified;
//   bool? isLiked;
//   String? areas;
//   String? slugHeadline;
//   int? shares;
//   String? origHeadline;
//   String? origStory;
//   ItemType? itemType;

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
//         type: json["type"] == null ? null : postTypeValues.map[json["type"]],
//         tags: json["tags"] == null
//             ? null
//             : List<String>.from(json["tags"].map((x) => x)),
//         publishFrom: json["publish_from"] == null
//             ? null
//             : DateTime.parse(json["publish_from"]),
//         author: json["author"] == null ? null : Author.fromJson(json["author"]),
//         authorType: json["author_type"] == null
//             ? null
//             : authorTypeEnumValues.map[json["author_type"]],
//         authorClassification: json["author_classification"] == null
//             ? null
//             : authorClassificationValues.map[json["author_classification"]],
//         status:
//             json["status"] == null ? null : statusValues.map[json["status"]],
//         originalLanguage: json["original_language"] == null
//             ? null
//             : json["original_language"],
//         impressions: json["impressions"] == null ? null : json["impressions"],
//         views: json["views"] == null ? null : json["views"],
//         postCreatedDate: json["post_created_date"] == null
//             ? null
//             : DateTime.parse(json["post_created_date"]),
//         createdDate: json["created_date"] == null ? null : json["created_date"],
//         context: json["context"],
//         isUgc: json["is_ugc"] == null ? null : json["is_ugc"],
//         likes: json["likes"] == null ? null : json["likes"],
//         comments: json["comments"] == null ? null : json["comments"],
//         locations: json["locations"] == null
//             ? null
//             : List<Location>.from(
//                 json["locations"].map((x) => Location.fromJson(x))),
//         userDetails: json["user_details"] == null
//             ? null
//             : List<UserDetail>.from(
//                 json["user_details"].map((x) => UserDetail.fromJson(x))),
//         creatorDetails: json["creator_details"] == null
//             ? null
//             : List<CreatorDetail>.from(
//                 json["creator_details"].map((x) => CreatorDetail.fromJson(x))),
//         id: json["id"],
//         isVerified: json["is_verified"] == null ? null : json["is_verified"],
//         isLiked: json["is_liked"] == null ? null : json["is_liked"],
//         areas: json["areas"] == null ? null : json["areas"],
//         slugHeadline:
//             json["slug_headline"] == null ? null : json["slug_headline"],
//         shares: json["shares"] == null ? null : json["shares"],
//         origHeadline:
//             json["orig_headline"] == null ? null : json["orig_headline"],
//         origStory: json["orig_story"] == null ? null : json["orig_story"],
//         itemType: json["item_type"] == null
//             ? null
//             : itemTypeValues.map[json["item_type"]],
//       );
// }

// class Author {
//   Author({
//     this.id,
//     this.name,
//     this.image,
//     this.type,
//     this.isSelf,
//     this.isFollowed,
//     this.showFollow,
//     this.isVerified,
//   });

//   int? id;
//   String? name;
//   String? image;
//   AuthorType? type;
//   bool? isSelf;
//   bool? isFollowed;
//   bool? showFollow;
//   bool? isVerified;

//   factory Author.fromJson(Map<String, dynamic> json) => Author(
//         id: json["id"] == null ? null : json["id"],
//         name: json["name"] == null ? null : json["name"],
//         image: json["image"] == null ? null : json["image"],
//         type: json["type"] == null ? null : authorTypeValues.map[json["type"]],
//         isSelf: json["is_self"] == null ? null : json["is_self"],
//         isFollowed: json["is_followed"] == null ? null : json["is_followed"],
//         showFollow: json["show_follow"] == null ? null : json["show_follow"],
//         isVerified: json["is_verified"] == null ? null : json["is_verified"],
//       );
// }

// enum AuthorType {
//   TEAM_3_KM,
//   CONTRIBUTOR,
//   USER,
//   ASSOCIATE,
//   TYPE_TEAM_3_KM,
//   COLUMNIST,
//   TYPE_CONTRIBUTOR
// }

// final authorTypeValues = EnumValues({
//   "Associate": AuthorType.ASSOCIATE,
//   "Columnist": AuthorType.COLUMNIST,
//   "Contributor": AuthorType.CONTRIBUTOR,
//   "Team 3km": AuthorType.TEAM_3_KM,
//   "Contributor ": AuthorType.TYPE_CONTRIBUTOR,
//   "Team 3km ": AuthorType.TYPE_TEAM_3_KM,
//   "User": AuthorType.USER
// });

// enum AuthorClassification {
//   TEAM_3_KM,
//   CONTRIBUTOR,
//   REPORTER,
//   AUTHOR_CLASSIFICATION_TEAM_3_KM,
//   STRINGER,
//   COLUMNIST,
//   USER,
//   AUTHOR_CLASSIFICATION_CONTRIBUTOR
// }

// final authorClassificationValues = EnumValues({
//   "contributor ": AuthorClassification.AUTHOR_CLASSIFICATION_CONTRIBUTOR,
//   "Team 3km ": AuthorClassification.AUTHOR_CLASSIFICATION_TEAM_3_KM,
//   "Columnist": AuthorClassification.COLUMNIST,
//   "Contributor": AuthorClassification.CONTRIBUTOR,
//   "Reporter": AuthorClassification.REPORTER,
//   "Stringer": AuthorClassification.STRINGER,
//   "Team 3km": AuthorClassification.TEAM_3_KM,
//   "User": AuthorClassification.USER
// });

// enum AuthorTypeEnum { ADMIN, USER, CREATOR }

// final authorTypeEnumValues = EnumValues({
//   "admin": AuthorTypeEnum.ADMIN,
//   "creator": AuthorTypeEnum.CREATOR,
//   "user": AuthorTypeEnum.USER
// });

// class CreatorDetail {
//   CreatorDetail({
//     this.creatorId,
//     this.userId,
//     this.id,
//     this.creatorUserData,
//     this.creatorDetailId,
//   });

//   int? creatorId;
//   int? userId;
//   String? id;
//   UserDetail? creatorUserData;
//   String? creatorDetailId;

//   factory CreatorDetail.fromJson(Map<String, dynamic> json) => CreatorDetail(
//         creatorId: json["creator_id"] == null ? null : json["creator_id"],
//         userId: json["user_id"] == null ? null : json["user_id"],
//         id: json["_id"] == null ? null : json["_id"],
//         creatorUserData: json["creator_user_data"] == null
//             ? null
//             : UserDetail.fromJson(json["creator_user_data"]),
//         creatorDetailId: json["id"] == null ? null : json["id"],
//       );
// }

// class UserDetail {
//   UserDetail({
//     this.userId,
//     this.isVerified,
//     this.id,
//     this.userDetailId,
//   });

//   int? userId;
//   bool? isVerified;
//   String? id;
//   String? userDetailId;

//   factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
//         userId: json["user_id"] == null ? null : json["user_id"],
//         isVerified: json["is_verified"] == null ? null : json["is_verified"],
//         id: json["_id"] == null ? null : json["_id"],
//         userDetailId: json["id"] == null ? null : json["id"],
//       );
// }

// enum ItemType { POST }

// final itemTypeValues = EnumValues({"post": ItemType.POST});

// class Location {
//   Location({
//     this.postId,
//     this.area,
//     this.city,
//     this.state,
//     this.isDeleted,
//     this.id,
//     this.locationId,
//   });

//   int? postId;
//   String? area;
//   City? city;
//   State? state;
//   bool? isDeleted;
//   String? id;
//   String? locationId;

//   factory Location.fromJson(Map<String, dynamic> json) => Location(
//         postId: json["post_id"] == null ? null : json["post_id"],
//         area: json["area"] == null ? null : json["area"],
//         city: json["city"] == null ? null : cityValues.map[json["city"]],
//         state: json["state"] == null ? null : stateValues.map[json["state"]],
//         isDeleted: json["is_deleted"] == null ? null : json["is_deleted"],
//         id: json["_id"] == null ? null : json["_id"],
//         locationId: json["id"] == null ? null : json["id"],
//       );
// }

// enum City { PUNE, EMPTY, CITY_PUNE, PIMPRI_CHINCHWAD, HINGOLI }

// final cityValues = EnumValues({
//   " Pune": City.CITY_PUNE,
//   "": City.EMPTY,
//   "Hingoli": City.HINGOLI,
//   " Pimpri-Chinchwad": City.PIMPRI_CHINCHWAD,
//   "Pune": City.PUNE
// });

// enum State { MAHARASHTRA, EMPTY, STATE_MAHARASHTRA }

// final stateValues = EnumValues({
//   "": State.EMPTY,
//   "Maharashtra": State.MAHARASHTRA,
//   " Maharashtra": State.STATE_MAHARASHTRA
// });

// enum Status { APPROVED }

// final statusValues = EnumValues({"approved": Status.APPROVED});

// enum PostType { POST }

// final postTypeValues = EnumValues({"Post": PostType.POST});

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
//   Player? player;
//   String? vimeoUrl;
//   int? width;
//   int? height;

//   factory Video.fromJson(Map<String, dynamic> json) => Video(
//         src: json["src"] == null ? null : json["src"],
//         thumbnail: json["thumbnail"] == null ? null : json["thumbnail"],
//         player:
//             json["player"] == null ? null : playerValues.map[json["player"]],
//         vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
//         width: json["width"] == null ? null : json["width"],
//         height: json["height"] == null ? null : json["height"],
//       );
// }

// enum Player { VIMEO }

// final playerValues = EnumValues({"vimeo": Player.VIMEO});

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

// To parse this JSON data, do
//
//     final newsFeedBottomModel = newsFeedBottomModelFromJson(jsonString);

import 'dart:convert';

NewsFeedBottomModel newsFeedBottomModelFromJson(String str) =>
    NewsFeedBottomModel.fromJson(json.decode(str));

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

  factory NewsFeedBottomModel.fromJson(Map<String, dynamic> json) => NewsFeedBottomModel(
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
        tags: json["tags"] == null ? null : List<dynamic>.from(json["tags"].map((x) => x)),
        areas: json["areas"] == null ? null : List<dynamic>.from(json["areas"].map((x) => x)),
      );
}

class Post {
  Post({
    this.postId,
    this.submittedHeadline,
    this.submittedStory,
    this.headline,
    this.story,
    this.images,
    this.videos,
    this.type,
    this.tags,
    this.publishFrom,
    this.author,
    this.authorType,
    this.authorClassification,
    this.status,
    this.originalLanguage,
    this.impressions,
    this.views,
    this.postCreatedDate,
    this.createdDate,
    this.context,
    this.isUgc,
    this.likes,
    this.comments,
    this.locations,
    this.userDetails,
    this.creatorDetails,
    this.id,
    this.isVerified,
    this.isLiked,
    this.areas,
    this.slugHeadline,
    this.shares,
    this.origHeadline,
    this.origStory,
    this.itemType,
    this.preheaderLike,
    this.preheaderComment,
    this.latestComment,
    this.emotion,
  });

  int? postId;
  String? submittedHeadline;
  String? submittedStory;
  String? headline;
  String? story;
  List<String>? images;
  List<Video>? videos;
  String? type;
  List<String>? tags;
  DateTime? publishFrom;
  Author? author;
  String? authorType;
  String? authorClassification;
  String? status;
  String? originalLanguage;
  int? impressions;
  int? views;
  DateTime? postCreatedDate;
  String? createdDate;
  dynamic context;
  bool? isUgc;
  int? likes;
  int? comments;
  List<Location>? locations;
  List<UserDetail>? userDetails;
  List<dynamic>? creatorDetails;
  dynamic id;
  bool? isVerified;
  bool? isLiked;
  String? areas;
  String? slugHeadline;
  int? shares;
  String? origHeadline;
  String? origStory;
  String? itemType;
  String? preheaderLike;
  String? preheaderComment;
  LatestComment? latestComment;
  String? emotion;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"] == null ? null : json["post_id"],
        submittedHeadline: json["submitted_headline"] == null
            ? null
            : json["submitted_headline"],
        submittedStory:
            json["submitted_story"] == null ? null : json["submitted_story"],
        headline: json["headline"] == null ? null : json["headline"],
        story: json["story"] == null ? null : json["story"],
        images: json["images"] == null
            ? null
            : List<String>.from(json["images"].map((x) => x)),
        videos: json["videos"] == null
            ? null
            : List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
        type: json["type"] == null ? null : json["type"],
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
        publishFrom: json["publish_from"] == null
            ? null
            : DateTime.parse(json["publish_from"]),
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        authorType: json["author_type"] == null ? null : json["author_type"],
        authorClassification: json["author_classification"] == null
            ? null
            : json["author_classification"],
        status: json["status"] == null ? null : json["status"],
        originalLanguage: json["original_language"] == null
            ? null
            : json["original_language"],
        impressions: json["impressions"] == null ? null : json["impressions"],
        views: json["views"] == null ? null : json["views"],
        postCreatedDate: json["post_created_date"] == null
            ? null
            : DateTime.parse(json["post_created_date"]),
        createdDate: json["created_date"] == null ? null : json["created_date"],
        context: json["context"],
        isUgc: json["is_ugc"] == null ? null : json["is_ugc"],
        likes: json["likes"] == null ? null : json["likes"],
        comments: json["comments"] == null ? null : json["comments"],
        locations: json["locations"] == null
            ? null
            : List<Location>.from(
                json["locations"].map((x) => Location.fromJson(x))),
        userDetails: json["user_details"] == null
            ? null
            : List<UserDetail>.from(
                json["user_details"].map((x) => UserDetail.fromJson(x))),
        creatorDetails: json["creator_details"] == null
            ? null
            : List<dynamic>.from(json["creator_details"].map((x) => x)),
        id: json["id"],
        isVerified: json["is_verified"] == null ? null : json["is_verified"],
        isLiked: json["is_liked"] == null ? null : json["is_liked"],
        areas: json["areas"] == null ? null : json["areas"],
        slugHeadline:
            json["slug_headline"] == null ? null : json["slug_headline"],
        shares: json["shares"] == null ? null : json["shares"],
        origHeadline:
            json["orig_headline"] == null ? null : json["orig_headline"],
        origStory: json["orig_story"] == null ? null : json["orig_story"],
        itemType: json["item_type"] == null ? null : json["item_type"],
        preheaderLike: json["preheader_like"],
        preheaderComment: json["preheader_comment"],
        latestComment: LatestComment.fromJson(json['latest_comment']),
        emotion: json["emotion"] ?? "",
      );
}

class Author {
  Author({
    this.id,
    this.name,
    this.image,
    this.type,
    this.isSelf,
    this.isFollowed,
    this.showFollow,
  });

  int? id;
  String? name;
  String? image;
  String? type;
  bool? isSelf;
  bool? isFollowed;
  bool? showFollow;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        image: json["image"] == null ? null : json["image"],
        type: json["type"] == null ? null : json["type"],
        isSelf: json["is_self"] == null ? null : json["is_self"],
        isFollowed: json["is_followed"] == null ? null : json["is_followed"],
        showFollow: json["show_follow"] == null ? null : json["show_follow"],
      );
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
        postId: json["post_id"] == null ? null : json["post_id"],
        area: json["area"] == null ? null : json["area"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        isDeleted: json["is_deleted"] == null ? null : json["is_deleted"],
        id: json["_id"] == null ? null : json["_id"],
        locationId: json["id"] == null ? null : json["id"],
      );
}

class UserDetail {
  UserDetail({
    this.userId,
    this.isVerified,
    this.id,
    this.userDetailId,
  });

  int? userId;
  bool? isVerified;
  String? id;
  String? userDetailId;

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
        userId: json["user_id"] == null ? null : json["user_id"],
        isVerified: json["is_verified"] == null ? null : json["is_verified"],
        id: json["_id"] == null ? null : json["_id"],
        userDetailId: json["id"] == null ? null : json["id"],
      );
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
}

class LatestComment {
  LatestComment({
    this.comment,
    this.user,
  });
  String? comment;
  User? user;

  LatestComment.fromJson(Map<String, dynamic> json) {
    comment = json['comment'] ?? "";
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['comment'] = comment;
    _data['user'] = user?.toJson();
    return _data;
  }
}

class User {
  User({
    required this.userId,
    required this.name,
    required this.avatar,
  });
  late final int userId;
  late final String name;
  late final String avatar;

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['name'] = name;
    _data['avatar'] = avatar;
    return _data;
  }
}
