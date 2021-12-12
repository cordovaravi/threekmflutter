// To parse this JSON data, do
//
//     final newsHomeSecondModel = newsHomeSecondModelFromJson(jsonString);

import 'dart:convert';

NewsHomeSecondModel newsHomeSecondModelFromJson(String str) =>
    NewsHomeSecondModel.fromJson(json.decode(str));

class NewsHomeSecondModel {
  NewsHomeSecondModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory NewsHomeSecondModel.fromJson(Map<String, dynamic> json) =>
      NewsHomeSecondModel(
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
  Finalpost({
    this.type,
    this.quiz,
    this.category,
    this.products,
    this.business,
  });

  String? type;
  Quiz? quiz;
  Category? category;
  List<Product>? products;
  Business? business;

  factory Finalpost.fromJson(Map<String, dynamic> json) => Finalpost(
        type: json["type"],
        quiz: json["quiz"] == null ? null : Quiz.fromJson(json["quiz"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        business: json["business"] == null
            ? null
            : Business.fromJson(json["business"]),
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
  dynamic? context;
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
        postId: json["post_id"],
        submittedHeadline: json["submitted_headline"],
        submittedStory: json["submitted_story"],
        headline: json["headline"],
        story: json["story"],
        images: List<dynamic>.from(json["images"].map((x) => x)),
        videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
        type: json["type"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        publishFrom: DateTime.parse(json["publish_from"]),
        author: BusinessAuthor.fromJson(json["author"]),
        authorType: json["author_type"],
        authorClassification: json["author_classification"],
        business: List<int>.from(json["business"].map((x) => x)),
        status: json["status"],
        originalLanguage: json["original_language"],
        impressions: json["impressions"],
        views: json["views"],
        postCreatedDate: DateTime.parse(json["post_created_date"]),
        createdDate: json["created_date"],
        context: json["context"],
        isUgc: json["is_ugc"],
        likes: json["likes"],
        comments: json["comments"],
        locations: List<Location>.from(
            json["locations"].map((x) => Location.fromJson(x))),
        userDetails: List<UserDetail>.from(
            json["user_details"].map((x) => UserDetail.fromJson(x))),
        creatorDetails:
            List<dynamic>.from(json["creator_details"].map((x) => x)),
        id: json["id"],
        isVerified: json["is_verified"],
        isLiked: json["is_liked"],
        areas: json["areas"],
        shares: json["shares"],
        origHeadline: json["orig_headline"],
        origStory: json["orig_story"],
        itemType: json["item_type"],
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "type": type,
        "is_self": isSelf,
        "show_follow": showFollow,
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

  Map<String, dynamic> toJson() => {
        "src": src,
        "thumbnail": thumbnail,
        "player": player,
        "vimeo_url": vimeoUrl,
        "width": width,
        "height": height,
      };
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
  PostAuthor? author;
  String? postCreatedDate;
  dynamic? id;
  String? image;
  String? video;
  String? player;
  String? vimeoUrl;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"],
        headline: json["headline"],
        author: PostAuthor.fromJson(json["author"]),
        postCreatedDate: json["post_created_date"],
        id: json["id"],
        image: json["image"],
        video: json["video"],
        player: json["player"] == null ? null : json["player"],
        vimeoUrl: json["vimeo_url"] == null ? null : json["vimeo_url"],
      );
}

class PostAuthor {
  PostAuthor({
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

  factory PostAuthor.fromJson(Map<String, dynamic> json) => PostAuthor(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        type: json["type"],
        isVerified: json["is_verified"] == null ? null : json["is_verified"],
      );
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
        quizId: json["quiz_id"],
        question: json["question"],
        image: json["image"],
        type: json["type"],
        options:
            List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        answer: json["answer"],
        answers:
            List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
        context: Context.fromJson(json["context"]),
        id: json["id"],
        itemType: json["item_type"],
        isAnswered: json["is_answered"],
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
        userId: json["user_id"],
        selectedOption: json["selected_option"],
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
        image: json["image"],
        description: json["description"],
        title: json["title"],
        longAnswer: json["long_answer"] == null ? null : json["long_answer"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "description": description,
        "title": title,
        "long_answer": longAnswer == null ? null : longAnswer,
      };
}

class Option {
  Option({
    this.text,
    this.percent,
    this.count,
    this.dPercent,
    this.bullets,
  });

  String? text;
  int? percent;
  int? count;
  String? dPercent;
  String? bullets;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
        text: json["text"],
        percent: json["percent"] == null ? null : json["percent"],
        count: json["count"] == null ? null : json["count"],
        dPercent: json["d_percent"],
        bullets: json["bullets"] == null ? null : json["bullets"],
      );
}
