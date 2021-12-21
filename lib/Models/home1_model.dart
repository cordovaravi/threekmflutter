// To parse this JSON data, do
//
//     final newsHomeModel = newsHomeModelFromJson(jsonString);

import 'dart:convert';

NewsHomeModel newsHomeModelFromJson(String str) =>
    NewsHomeModel.fromJson(json.decode(str));

class NewsHomeModel {
  NewsHomeModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory NewsHomeModel.fromJson(Map<String, dynamic> json) => NewsHomeModel(
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
    this.finalposts,
  });

  List<Finalpost>? finalposts;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        finalposts: List<Finalpost>.from(
            json["finalposts"].map((x) => Finalpost.fromJson(x))),
      );
}

class Finalpost {
  Finalpost(
      {this.type,
      this.bannertype,
      this.banners,
      this.category,
      this.business,
      this.quiz,
      this.quizCarosal});

  String? type;
  String? bannertype;
  List<Banner>? banners;
  Category? category;
  Quiz? quiz;
  QuizCarosal? quizCarosal;
  Business? business;

  factory Finalpost.fromJson(Map<String, dynamic> json) => Finalpost(
        type: json["type"],
        bannertype: json["bannertype"] == null ? null : json["bannertype"],
        banners: json["banners"] == null
            ? null
            : List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        quiz: json["quiz"] == null
            ? null
            : json["type"] == "quiz"
                ? Quiz.fromJson(json["quiz"])
                : null,
        quizCarosal: json["quiz_carousel"] == null
            ? null
            : json["type"] == "quiz_carousel"
                ? QuizCarosal.fromJson(json["quiz"])
                : null,
        business: json["business"] == null
            ? null
            : Business.fromJson(json["business"]),
      );
}

class Banner {
  Banner({
    this.advId,
    this.images,
    this.videos,
    this.type,
    this.id,
    this.itemType,
    this.imageswcta,
    this.advType,
  });

  int? advId;
  List<String>? images;
  List<dynamic>? videos;
  String? type;
  dynamic id;
  String? itemType;
  List<Imageswcta>? imageswcta;
  String? advType;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        advId: json["adv_id"],
        images: List<String>.from(json["images"].map((x) => x)),
        videos: List<dynamic>.from(json["videos"].map((x) => x)),
        type: json["type"],
        id: json["id"],
        itemType: json["item_type"],
        imageswcta: List<Imageswcta>.from(
            json["imageswcta"].map((x) => Imageswcta.fromJson(x))),
        advType: json["adv_type"],
      );
}

class Imageswcta {
  Imageswcta({
    this.image,
    this.type,
    this.player,
    this.postId,
    this.video,
    this.vimeoUrl,
    this.header,
    this.post,
    this.business,
    this.website,
    this.product,
    this.phone,
  });

  String? image;
  String? type;
  String? player;
  int? postId;
  String? video;
  String? vimeoUrl;
  String? header;
  List<int>? post;
  String? business;
  String? website;
  String? product;
  String? phone;

  factory Imageswcta.fromJson(Map<String, dynamic> json) => Imageswcta(
        image: json["image"] == null ? null : json["image"],
        type: json["type"] == null ? null : json["type"],
        player: json["player"] == null ? null : json["player"],
        postId: json["post_id"] == null ? null : json["post_id"],
        video: json["video"] == null ? null : json["video"],
        vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
        header: json["header"] == null ? null : json["header"],
        post: json["post"] == null
            ? null
            : List<int>.from(json["post"].map((x) => x)),
        business: json["business"] == null ? null : json["business"],
        website: json["website"] == null ? null : json["website"],
        product: json["product"] == null ? null : json["product"],
        phone: json["phone"] == null ? null : json["phone"],
      );
}

class Category {
  Category({
    this.categoryId,
    this.name,
    this.tags,
    this.icon,
    this.id,
    this.posts,
  });

  int? categoryId;
  String? name;
  List<String>? tags;
  String? icon;
  dynamic id;
  List<Post>? posts;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        name: json["name"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        icon: json["icon"],
        id: json["id"],
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
      );
}

class Post {
  Post({
    this.postId,
    this.headline,
    this.author,
    this.postCreatedDate,
    this.id,
    this.image,
    this.video,
    this.player,
    this.vimeoUrl,
  });

  int? postId;
  String? headline;
  Author? author;
  String? postCreatedDate;
  dynamic id;
  String? image;
  String? video;
  dynamic player;
  String? vimeoUrl;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"],
        headline: json["headline"],
        author: Author.fromJson(json["author"]),
        postCreatedDate: json["post_created_date"],
        id: json["id"],
        image: json["image"],
        video: json["video"],
        player: json["player"] == null ? null : json["player"],
        vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
      );
}

class Author {
  Author({
    this.id,
    this.name,
    this.image,
    this.type,
    this.isVerified,
  });

  int? id;
  String? name;
  String? image;
  String? type;
  bool? isVerified;

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        isVerified: json["is_verified"] == null ? null : json["is_verified"],
      );
}

class Business {
  Business({
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
    this.business,
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
  List<dynamic>? images;
  List<Video>? videos;
  String? type;
  List<String>? tags;
  DateTime? publishFrom;
  BusinessAuthor? author;
  String? authorType;
  String? authorClassification;
  List<int>? business;
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
  dynamic? id;
  bool? isVerified;
  bool? isLiked;
  String? areas;
  int? shares;
  String? origHeadline;
  String? origStory;
  String? itemType;

  factory Business.fromJson(Map<String, dynamic> json) => Business(
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
            : List<dynamic>.from(json["images"].map((x) => x)),
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
        author: json["author"] == null
            ? null
            : BusinessAuthor.fromJson(json["author"]),
        authorType: json["author_type"] == null ? null : json["author_type"],
        authorClassification: json["author_classification"] == null
            ? null
            : json["author_classification"],
        business: json["business"] == null
            ? null
            : List<int>.from(json["business"].map((x) => x)),
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

class BusinessAuthor {
  BusinessAuthor({
    this.id,
    this.name,
    this.image,
    this.type,
    this.isSelf,
    this.showFollow,
  });

  int? id;
  String? name;
  String? image;
  String? type;
  bool? isSelf;
  bool? showFollow;

  factory BusinessAuthor.fromJson(Map<String, dynamic> json) => BusinessAuthor(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        isSelf: json["is_self"],
        showFollow: json["show_follow"],
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
        src: json["src"],
        thumbnail: json["thumbnail"],
        player: json["player"],
        vimeoUrl: json["vimeo_url"],
        width: json["width"],
        height: json["height"],
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
        userId: json["user_id"],
        isVerified: json["is_verified"],
        id: json["_id"],
        userDetailId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "is_verified": isVerified,
        "_id": id,
        "id": userDetailId,
      };
}

class Product {
  Product({
    this.catalogId,
    this.name,
    this.image,
    this.id,
  });

  int? catalogId;
  String? name;
  String? image;
  dynamic id;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        catalogId: json["catalog_id"],
        name: json["name"],
        image: json["image"],
        id: json["id"],
      );
}

// To parse this JSON data, do
//
//     final quiz = quizFromJson(jsonString);

List<QuizCarosal> quizQuizCarosalFromJson(String str) => List<QuizCarosal>.from(
    json.decode(str).map((x) => QuizCarosal.fromJson(x)));

class QuizCarosal {
  QuizCarosal({
    this.quizId,
    this.question,
    this.image,
    this.type,
    this.options,
    this.answer,
    this.answers,
    this.context,
    this.id,
    this.itemType,
    this.isAnswered,
    this.style,
  });

  int? quizId;
  String? question;
  String? image;
  String? type;
  List<Option>? options;
  String? answer;
  List<Answer>? answers;
  Context? context;
  int? id;
  String? itemType;
  bool? isAnswered;
  String? style;

  factory QuizCarosal.fromJson(Map<String, dynamic> json) => QuizCarosal(
        quizId: json["quiz_id"] == null ? null : json["quiz_id"],
        question: json["question"] == null ? null : json["question"],
        image: json["image"] == null ? null : json["image"],
        type: json["type"] == null ? null : json["type"],
        options: json["options"] == null
            ? null
            : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        answer: json["answer"] == null ? null : json["answer"],
        answers: json["answers"] == null
            ? null
            : List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        context:
            json["context"] == null ? null : Context.fromJson(json["context"]),
        id: json["id"] == null ? null : json["id"],
        itemType: json["item_type"] == null ? null : json["item_type"],
        isAnswered: json["is_answered"] == null ? null : json["is_answered"],
        style: json["style"] == null ? null : json["style"],
      );
}

class Answer {
  Answer({
    this.userId,
    this.selectedOption,
  });

  int? userId;
  String? selectedOption;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        userId: json["user_id"] == null ? null : json["user_id"],
        selectedOption:
            json["selected_option"] == null ? null : json["selected_option"],
      );
}

class Context {
  Context({
    this.image,
    this.description,
    this.title,
    this.longAnswer,
  });

  String? image;
  String? description;
  String? title;
  bool? longAnswer;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        image: json["image"] == null ? null : json["image"],
        description: json["description"] == null ? null : json["description"],
        title: json["title"] == null ? null : json["title"],
        longAnswer: json["long_answer"] == null ? null : json["long_answer"],
      );
}

class Option {
  Option({
    this.text,
    this.percent,
    this.count,
    this.bullets,
    this.dPercent,
  });

  String? text;
  int? percent;
  int? count;
  String? bullets;
  String? dPercent;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        text: json["text"] == null ? null : json["text"],
        percent: json["percent"] == null ? null : json["percent"],
        count: json["count"] == null ? null : json["count"],
        bullets: json["bullets"] == null ? null : json["bullets"],
        dPercent: json["d_percent"] == null ? null : json["d_percent"],
      );
}

// To parse this JSON data, do
//
//     final quiz = quizFromJson(jsonString);

Quiz quizFromJson(String str) => Quiz.fromJson(json.decode(str));

class Quiz {
  Quiz({
    this.quizId,
    this.question,
    this.image,
    this.type,
    this.options,
    this.answer,
    this.answers,
    this.context,
    this.id,
    this.itemType,
    this.isAnswered,
  });

  int? quizId;
  String? question;
  String? image;
  String? type;
  List<Option>? options;
  String? answer;
  List<Answer>? answers;
  Context? context;
  int? id;
  String? itemType;
  bool? isAnswered;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        quizId: json["quiz_id"] == null ? null : json["quiz_id"],
        question: json["question"] == null ? null : json["question"],
        image: json["image"] == null ? null : json["image"],
        type: json["type"] == null ? null : json["type"],
        options: json["options"] == null
            ? null
            : List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        answer: json["answer"] == null ? null : json["answer"],
        answers: json["answers"] == null
            ? null
            : List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        context:
            json["context"] == null ? null : Context.fromJson(json["context"]),
        id: json["id"] == null ? null : json["id"],
        itemType: json["item_type"] == null ? null : json["item_type"],
        isAnswered: json["is_answered"] == null ? null : json["is_answered"],
      );
}




// final playerValues = EnumValues({
//     "vimeo": Player.VIMEO
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         if (reverseMap == null) {
//             reverseMap = map.map((k, v) => new MapEntry(v, k));
//         }
//         return reverseMap;
//     }
// }

