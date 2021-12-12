import 'package:threekm/Models/home1_model.dart';

class Posts {
  Posts({
    this.quizId,
    this.question,
    this.image,
    this.type,
    //this.options,
    this.answer,
    // this.answers,
    // this.context,
    this.id,
    //this.itemType,
    this.isAnswered,
    this.longAnswer,
    this.postId,
    this.submittedHeadline,
    this.submittedStory,
    this.headline,
    this.story,
    this.images,
    this.videos,
    this.tags,
    this.publishFrom,
    this.author,
    //this.authorType,
    this.authorClassification,
    //this.status,
    this.originalLanguage,
    this.impressions,
    this.views,
    this.postCreatedDate,
    this.createdDate,
    this.isUgc,
    this.likes,
    this.comments,
    this.locations,
    this.userDetails,
    // this.creatorDetails,
    this.isVerified,
    this.isLiked,
    this.areas,
    this.shares,
    this.origHeadline,
    this.origStory,
    this.advId,
    this.imageswcta,
    this.advType,
  });

  int? quizId;
  String? question;
  String? image;
  String? type;
  //List<Option>? options;
  String? answer;
  //List<Answer>? answers;
  //Context? context;
  int? id;
  //ItemType? itemType;
  bool? isAnswered;
  bool? longAnswer;
  int? postId;
  String? submittedHeadline;
  String? submittedStory;
  String? headline;
  String? story;
  List<String>? images;
  List<Video>? videos;
  List<String>? tags;
  DateTime? publishFrom;
  Author? author;
  //AuthorType? authorType;
  String? authorClassification;
  //Status? status;
  String? originalLanguage;
  int? impressions;
  int? views;
  DateTime? postCreatedDate;
  String? createdDate;
  bool? isUgc;
  int? likes;
  int? comments;
  List<Location>? locations;
  List<UserDetail>? userDetails;
  //List<CreatorDetail>? creatorDetails;
  bool? isVerified;
  bool? isLiked;
  String? areas;
  int? shares;
  String? origHeadline;
  String? origStory;
  int? advId;
  List<Imageswcta>? imageswcta;
  String? advType;

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        quizId: json["quiz_id"] == null ? null : json["quiz_id"],
        question: json["question"] == null ? null : json["question"],
        image: json["image"] == null ? null : json["image"],
        type: json["type"],

        answer: json["answer"] == null ? null : json["answer"],
        id: json["id"] == null ? null : json["id"],
        //   itemType: itemTypeValues.map[json["item_type"]],
        isAnswered: json["is_answered"] == null ? null : json["is_answered"],
        longAnswer: json["long_answer"] == null ? null : json["long_answer"],
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
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
        publishFrom: json["publish_from"] == null
            ? null
            : DateTime.parse(json["publish_from"]),
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        // authorType: json["author_type"] == null
        //     ? null
        //     : authorTypeValues.map[json["author_type"]],
        authorClassification: json["author_classification"] == null
            ? null
            : json["author_classification"],
        // status:
        //     json["status"] == null ? null : statusValues.map[json["status"]],
        // originalLanguage: json["original_language"] == null
        //     ? null
        //     : json["original_language"],
        impressions: json["impressions"] == null ? null : json["impressions"],
        views: json["views"] == null ? null : json["views"],
        postCreatedDate: json["post_created_date"] == null
            ? null
            : DateTime.parse(json["post_created_date"]),
        createdDate: json["created_date"] == null ? null : json["created_date"],
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
        // creatorDetails: json["creator_details"] == null
        //     ? null
        //     : List<CreatorDetail>.from(
        //         json["creator_details"].map((x) => CreatorDetail.fromJson(x))),
        isVerified: json["is_verified"] == null ? null : json["is_verified"],
        isLiked: json["is_liked"] == null ? null : json["is_liked"],
        areas: json["areas"] == null ? null : json["areas"],
        shares: json["shares"] == null ? null : json["shares"],
        origHeadline:
            json["orig_headline"] == null ? null : json["orig_headline"],
        origStory: json["orig_story"] == null ? null : json["orig_story"],
        advId: json["adv_id"] == null ? null : json["adv_id"],
        imageswcta: json["imageswcta"] == null
            ? null
            : List<Imageswcta>.from(
                json["imageswcta"].map((x) => Imageswcta.fromJson(x))),
        advType: json["adv_type"] == null ? null : json["adv_type"],
      );
}
