// To parse this JSON data, do
//
//     final newsbyCategoryModel = newsbyCategoryModelFromJson(jsonString);

import 'dart:convert';

NewsbyCategoryModel newsbyCategoryModelFromJson(String str) =>
    NewsbyCategoryModel.fromJson(json.decode(str));

class NewsbyCategoryModel {
  NewsbyCategoryModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory NewsbyCategoryModel.fromJson(Map<String, dynamic> json) =>
      NewsbyCategoryModel(
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
  });

  List<Post>? posts;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
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
    this.shares,
    this.origHeadline,
    this.origStory,
    this.itemType,
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
  int? shares;
  String? origHeadline;
  String? origStory;
  String? itemType;

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
        shares: json["shares"] == null ? null : json["shares"],
        origHeadline:
            json["orig_headline"] == null ? null : json["orig_headline"],
        origStory: json["orig_story"] == null ? null : json["orig_story"],
        itemType: json["item_type"] == null ? null : json["item_type"],
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
  Video(
      {this.src,
      this.thumbnail,
      this.player,
      this.vimeoUrl,
      this.height,
      this.width});

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


// import 'dart:convert';

// NewsbyCategoryModel newsbyCategoryModelFromJson(String str) =>
//     NewsbyCategoryModel.fromJson(json.decode(str));

// class NewsbyCategoryModel {
//   NewsbyCategoryModel({
//     this.status,
//     this.message,
//     this.error,
//     this.data,
//   });

//   String? status;
//   dynamic message;
//   dynamic error;
//   Data? data;

//   factory NewsbyCategoryModel.fromJson(Map<String, dynamic> json) =>
//       NewsbyCategoryModel(
//         status: json["status"],
//         message: json["message"],
//         error: json["error"],
//         data: Data.fromJson(json["data"]),
//       );
// }

// class Data {
//   Data({
//     this.result,
//   });

//   Result? result;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         result: Result.fromJson(json["result"]),
//       );
// }

// class Result {
//   Result({
//     this.posts,
//   });

//   List<Posts>? posts;

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         posts: List<Posts>.from(json["posts"].map((x) => Posts.fromJson(x))),
//       );
// }

// class Posts {
//   Posts({
//     this.quizId,
//     this.question,
//     this.image,
//     this.type,
//     this.options,
//     this.answer,
//     this.answers,
//     this.context,
//     this.id,
//     this.itemType,
//     this.isAnswered,
//     this.longAnswer,
//     this.postId,
//     this.submittedHeadline,
//     this.submittedStory,
//     this.headline,
//     this.story,
//     this.images,
//     this.videos,
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
//     this.isUgc,
//     this.likes,
//     this.comments,
//     this.locations,
//     this.userDetails,
//     this.creatorDetails,
//     this.isVerified,
//     this.isLiked,
//     this.areas,
//     this.shares,
//     this.origHeadline,
//     this.origStory,
//     this.advId,
//     this.imageswcta,
//     this.advType,
//   });

//   int? quizId;
//   String? question;
//   String? image;
//   String? type;
//   List<Option>? options;
//   String? answer;
//   List<Answer>? answers;
//   Context? context;
//   int? id;
//   ItemType? itemType;
//   bool? isAnswered;
//   bool? longAnswer;
//   int? postId;
//   String? submittedHeadline;
//   String? submittedStory;
//   String? headline;
//   String? story;
//   List<String>? images;
//   List<Video>? videos;
//   List<String>? tags;
//   DateTime? publishFrom;
//   Author? author;
//   AuthorType? authorType;
//   String? authorClassification;
//   Status? status;
//   String? originalLanguage;
//   int? impressions;
//   int? views;
//   DateTime? postCreatedDate;
//   String? createdDate;
//   bool? isUgc;
//   int? likes;
//   int? comments;
//   List<Location>? locations;
//   List<UserDetail>? userDetails;
//   List<CreatorDetail>? creatorDetails;
//   bool? isVerified;
//   bool? isLiked;
//   String? areas;
//   int? shares;
//   String? origHeadline;
//   String? origStory;
//   int? advId;
//   List<Imageswcta>? imageswcta;
//   String? advType;

//   factory Posts.fromJson(Map<String, dynamic> json) => Posts(
//         quizId: json["quiz_id"] == null ? null : json["quiz_id"],
//         question: json["question"] == null ? null : json["question"],
//         image: json["image"] == null ? null : json["image"],
//         type: json["type"],
//         options: json["options"] == null
//             ? null
//             : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
//         answer: json["answer"] == null ? null : json["answer"],
//         answers: json["answers"] == null
//             ? null
//             : List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
//         context:
//             json["context"] == null ? null : Context.fromJson(json["context"]),
//         id: json["id"] == null ? null : json["id"],
//         itemType: itemTypeValues.map[json["item_type"]],
//         isAnswered: json["is_answered"] == null ? null : json["is_answered"],
//         longAnswer: json["long_answer"] == null ? null : json["long_answer"],
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
//         tags: json["tags"] == null
//             ? null
//             : List<String>.from(json["tags"].map((x) => x)),
//         publishFrom: json["publish_from"] == null
//             ? null
//             : DateTime.parse(json["publish_from"]),
//         author: json["author"] == null ? null : Author.fromJson(json["author"]),
//         authorType: json["author_type"] == null
//             ? null
//             : authorTypeValues.map[json["author_type"]],
//         authorClassification: json["author_classification"] == null
//             ? null
//             : json["author_classification"],
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
//         isVerified: json["is_verified"] == null ? null : json["is_verified"],
//         isLiked: json["is_liked"] == null ? null : json["is_liked"],
//         areas: json["areas"] == null ? null : json["areas"],
//         shares: json["shares"] == null ? null : json["shares"],
//         origHeadline:
//             json["orig_headline"] == null ? null : json["orig_headline"],
//         origStory: json["orig_story"] == null ? null : json["orig_story"],
//         advId: json["adv_id"] == null ? null : json["adv_id"],
//         imageswcta: json["imageswcta"] == null
//             ? null
//             : List<Imageswcta>.from(
//                 json["imageswcta"].map((x) => Imageswcta.fromJson(x))),
//         advType: json["adv_type"] == null ? null : json["adv_type"],
//       );
// }

// class Answer {
//   Answer({
//     this.userId,
//     this.selectedOption,
//   });

//   int? userId;
//   String? selectedOption;

//   factory Answer.fromJson(Map<String, dynamic> json) => Answer(
//         userId: json["user_id"],
//         selectedOption: json["selected_option"],
//       );
// }

// class Author {
//   Author({
//     this.id,
//     this.name,
//     this.image,
//     this.type,
//     this.isVerified,
//     this.isSelf,
//     this.isFollowed,
//     this.showFollow,
//   });

//   int? id;
//   String? name;
//   String? image;
//   String? type;
//   bool? isVerified;
//   bool? isSelf;
//   bool? isFollowed;
//   bool? showFollow;

//   factory Author.fromJson(Map<String, dynamic> json) => Author(
//         id: json["id"],
//         name: json["name"],
//         image: json["image"],
//         type: json["type"],
//         isVerified: json["is_verified"] == null ? null : json["is_verified"],
//         isSelf: json["is_self"],
//         isFollowed: json["is_followed"] == null ? null : json["is_followed"],
//         showFollow: json["show_follow"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//         "type": type,
//         "is_verified": isVerified == null ? null : isVerified,
//         "is_self": isSelf,
//         "is_followed": isFollowed == null ? null : isFollowed,
//         "show_follow": showFollow,
//       };
// }

// enum AuthorType { CREATOR, USER, ADMIN }

// final authorTypeValues = EnumValues({
//   "admin": AuthorType.ADMIN,
//   "creator": AuthorType.CREATOR,
//   "user": AuthorType.USER
// });

// class Context {
//   Context({
//     this.image,
//     this.description,
//     this.title,
//     this.longAnswer,
//   });

//   String? image;
//   String? description;
//   String? title;
//   bool? longAnswer;

//   factory Context.fromJson(Map<String, dynamic> json) => Context(
//         image: json["image"],
//         description: json["description"],
//         title: json["title"],
//         longAnswer: json["long_answer"],
//       );

//   Map<String, dynamic> toJson() => {
//         "image": image,
//         "description": description,
//         "title": title,
//         "long_answer": longAnswer,
//       };
// }

// enum CreatedDate { THE_2_DAYS_AGO }

// final createdDateValues =
//     EnumValues({"2 days ago": CreatedDate.THE_2_DAYS_AGO});

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
//         creatorId: json["creator_id"],
//         userId: json["user_id"],
//         id: json["_id"],
//         creatorUserData: UserDetail.fromJson(json["creator_user_data"]),
//         creatorDetailId: json["id"],
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
//         userId: json["user_id"],
//         isVerified: json["is_verified"],
//         id: json["_id"],
//         userDetailId: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "user_id": userId,
//         "is_verified": isVerified,
//         "_id": id,
//         "id": userDetailId,
//       };
// }

// class Imageswcta {
//   Imageswcta({
//     this.image,
//     this.business,
//     this.website,
//     this.product,
//     this.phone,
//   });

//   String? image;
//   int? business;
//   String? website;
//   String? product;
//   String? phone;

//   factory Imageswcta.fromJson(Map<String, dynamic> json) => Imageswcta(
//         image: json["image"],
//         business: json["business"],
//         website: json["website"],
//         product: json["product"],
//         phone: json["phone"],
//       );

//   Map<String, dynamic> toJson() => {
//         "image": image,
//         "business": business,
//         "website": website,
//         "product": product,
//         "phone": phone,
//       };
// }

// enum ItemType { QUIZ, POST, ADVERTISEMENT }

// final itemTypeValues = EnumValues({
//   "advertisement": ItemType.ADVERTISEMENT,
//   "post": ItemType.POST,
//   "quiz": ItemType.QUIZ
// });

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
//         postId: json["post_id"],
//         area: json["area"],
//         city: cityValues.map[json["city"]],
//         state: stateValues.map[json["state"]],
//         isDeleted: json["is_deleted"],
//         id: json["_id"],
//         locationId: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "post_id": postId,
//         "area": area,
//         "city": cityValues.reverse[city],
//         "state": stateValues.reverse[state],
//         "is_deleted": isDeleted,
//         "_id": id,
//         "id": locationId,
//       };
// }

// enum City { PUNE, CITY_PUNE }

// final cityValues = EnumValues({"Pune": City.CITY_PUNE, " Pune": City.PUNE});

// enum State { MAHARASHTRA, STATE_MAHARASHTRA }

// final stateValues = EnumValues({
//   " Maharashtra": State.MAHARASHTRA,
//   "Maharashtra": State.STATE_MAHARASHTRA
// });

// class Option {
//   Option({
//     this.text,
//     this.percent,
//     this.count,
//     this.dPercent,
//   });

//   String? text;
//   int? percent;
//   int? count;
//   String? dPercent;

//   factory Option.fromJson(Map<String, dynamic> json) => Option(
//         text: json["text"],
//         percent: json["percent"],
//         count: json["count"],
//         dPercent: json["d_percent"],
//       );

//   Map<String, dynamic> toJson() => {
//         "text": text,
//         "percent": percent,
//         "count": count,
//         "d_percent": dPercent,
//       };
// }

// enum Status { APPROVED }

// final statusValues = EnumValues({"approved": Status.APPROVED});

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
//         src: json["src"],
//         thumbnail: json["thumbnail"],
//         player: json["player"] == null ? null : json["player"],
//         vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
//         width: json["width"] == null ? null : json["width"],
//         height: json["height"] == null ? null : json["height"],
//       );

//   Map<String, dynamic> toJson() => {
//         "src": src,
//         "thumbnail": thumbnail,
//         "player": player == null ? null : player,
//         "vimeo_url": vimeoUrl == null ? null : vimeoUrl,
//         "width": width == null ? null : width,
//         "height": height == null ? null : height,
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






// To parse this JSON data, do
//
//     final newsbyCategoryModel = newsbyCategoryModelFromJson(jsonString);

// import 'dart:convert';

// NewsbyCategoryModel newsbyCategoryModelFromJson(String str) =>
//     NewsbyCategoryModel.fromJson(json.decode(str));

// class NewsbyCategoryModel {
//   NewsbyCategoryModel({
//     this.status,
//     this.message,
//     this.error,
//     this.data,
//   });

//   String? status;
//   dynamic message;
//   dynamic error;
//   Data? data;

//   factory NewsbyCategoryModel.fromJson(Map<String, dynamic> json) =>
//       NewsbyCategoryModel(
//         status: json["status"],
//         message: json["message"],
//         error: json["error"],
//         data: Data.fromJson(json["data"]),
//       );
// }

// class Data {
//   Data({
//     this.result,
//   });

//   Result? result;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         result: Result.fromJson(json["result"]),
//       );
// }

// class Result {
//   Result({
//     this.posts,
//   });

//   List<Post>? posts;

//   factory Result.fromJson(Map<String, dynamic> json) => Result(
//         posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
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
//     this.shares,
//     this.origHeadline,
//     this.origStory,
//     this.itemType,
//     this.advId,
//     this.imageswcta,
//     this.advType,
//   });

//   int? postId;
//   String? submittedHeadline;
//   String? submittedStory;
//   String? headline;
//   String? story;
//   List<String>? images;
//   List<Video>? videos;
//   Type? type;
//   List<String>? tags;
//   DateTime? publishFrom;
//   Author? author;
//   AuthorType? authorType;
//   String? authorClassification;
//   Status? status;
//   String? originalLanguage;
//   int? impressions;
//   int? views;
//   DateTime? postCreatedDate;
//   CreatedDate? createdDate;
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
//   int? shares;
//   String? origHeadline;
//   String? origStory;
//   ItemType? itemType;
//   int? advId;
//   List<Imageswcta>? imageswcta;
//   String? advType;

//   factory Post.fromJson(Map<String, dynamic> json) => Post(
//         postId: json["post_id"] == null ? null : json["post_id"],
//         submittedHeadline: json["submitted_headline"] == null
//             ? null
//             : json["submitted_headline"],
//         submittedStory:
//             json["submitted_story"] == null ? null : json["submitted_story"],
//         headline: json["headline"] == null ? null : json["headline"],
//         story: json["story"] == null ? null : json["story"],
//         images: json['images'] = List<String>.from(json["images"].map((x) => x)),
//         videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
//         type: typeValues.map[json["type"]],
//         tags: json["tags"] == null
//             ? null
//             : List<String>.from(json["tags"].map((x) => x)),
//         publishFrom: json["publish_from"] == null
//             ? null
//             : DateTime.parse(json["publish_from"]),
//         author: json["author"] == null ? null : Author.fromJson(json["author"]),
//         authorType: json["author_type"] == null
//             ? null
//             : authorTypeValues.map[json["author_type"]],
//         authorClassification: json["author_classification"] == null
//             ? null
//             : json["author_classification"],
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
//         createdDate: json["created_date"] == null
//             ? null
//             : createdDateValues.map[json["created_date"]],
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
//         shares: json["shares"] == null ? null : json["shares"],
//         origHeadline:
//             json["orig_headline"] == null ? null : json["orig_headline"],
//         origStory: json["orig_story"] == null ? null : json["orig_story"],
//         itemType: itemTypeValues.map[json["item_type"]],
//         advId: json["adv_id"] == null ? null : json["adv_id"],
//         imageswcta: json["imageswcta"] == null
//             ? null
//             : List<Imageswcta>.from(
//                 json["imageswcta"].map((x) => Imageswcta.fromJson(x))),
//         advType: json["adv_type"] == null ? null : json["adv_type"],
//       );
// }

// class Author {
//   Author({
//     this.id,
//     this.name,
//     this.image,
//     this.type,
//     this.isVerified,
//     this.isSelf,
//     this.isFollowed,
//     this.showFollow,
//   });

//   int? id;
//   String? name;
//   String? image;
//   String? type;
//   bool? isVerified;
//   bool? isSelf;
//   bool? isFollowed;
//   bool? showFollow;

//   factory Author.fromJson(Map<String, dynamic> json) => Author(
//         id: json["id"],
//         name: json["name"],
//         image: json["image"],
//         type: json["type"],
//         isVerified: json["is_verified"] == null ? null : json["is_verified"],
//         isSelf: json["is_self"],
//         isFollowed: json["is_followed"] == null ? null : json["is_followed"],
//         showFollow: json["show_follow"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//         "type": type,
//         "is_verified": isVerified == null ? null : isVerified,
//         "is_self": isSelf,
//         "is_followed": isFollowed == null ? null : isFollowed,
//         "show_follow": showFollow,
//       };
// }

// enum AuthorType { CREATOR, USER, ADMIN }

// final authorTypeValues = EnumValues({
//   "admin": AuthorType.ADMIN,
//   "creator": AuthorType.CREATOR,
//   "user": AuthorType.USER
// });

// enum CreatedDate { THE_2_DAYS_AGO }

// final createdDateValues =
//     EnumValues({"2 days ago": CreatedDate.THE_2_DAYS_AGO});

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
//         creatorId: json["creator_id"],
//         userId: json["user_id"],
//         id: json["_id"],
//         creatorUserData: UserDetail.fromJson(json["creator_user_data"]),
//         creatorDetailId: json["id"],
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
//         userId: json["user_id"],
//         isVerified: json["is_verified"],
//         id: json["_id"],
//         userDetailId: json["id"],
//       );
// }

// class Imageswcta {
//   Imageswcta({
//     this.image,
//     this.business,
//     this.website,
//     this.product,
//     this.phone,
//   });

//   String? image;
//   int? business;
//   String? website;
//   String? product;
//   String? phone;

//   factory Imageswcta.fromJson(Map<String, dynamic> json) => Imageswcta(
//         image: json["image"],
//         business: json["business"],
//         website: json["website"],
//         product: json["product"],
//         phone: json["phone"],
//       );
// }

// enum ItemType { POST, ADVERTISEMENT }

// final itemTypeValues = EnumValues(
//     {"advertisement": ItemType.ADVERTISEMENT, "post": ItemType.POST});

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
//         postId: json["post_id"],
//         area: json["area"],
//         city: cityValues.map[json["city"]],
//         state: stateValues.map[json["state"]],
//         isDeleted: json["is_deleted"],
//         id: json["_id"],
//         locationId: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "post_id": postId,
//         "area": area,
//         "city": cityValues.reverse[city],
//         "state": stateValues.reverse[state],
//         "is_deleted": isDeleted,
//         "_id": id,
//         "id": locationId,
//       };
// }

// enum City { PUNE, CITY_PUNE }

// final cityValues = EnumValues({"Pune": City.CITY_PUNE, " Pune": City.PUNE});

// enum State { MAHARASHTRA, STATE_MAHARASHTRA }

// final stateValues = EnumValues({
//   " Maharashtra": State.MAHARASHTRA,
//   "Maharashtra": State.STATE_MAHARASHTRA
// });

// enum Status { APPROVED }

// final statusValues = EnumValues({"approved": Status.APPROVED});

// enum Type { POST, RWC, RNC }

// final typeValues =
//     EnumValues({"Post": Type.POST, "RNC": Type.RNC, "RWC": Type.RWC});

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
//         src: json["src"],
//         thumbnail: json["thumbnail"],
//         player: json["player"] == null ? null : json["player"],
//         vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
//         width: json["width"] == null ? null : json["width"],
//         height: json["height"] == null ? null : json["height"],
//       );

//   Map<String, dynamic> toJson() => {
//         "src": src,
//         "thumbnail": thumbnail,
//         "player": player == null ? null : player,
//         "vimeo_url": vimeoUrl == null ? null : vimeoUrl,
//         "width": width == null ? null : width,
//         "height": height == null ? null : height,
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
