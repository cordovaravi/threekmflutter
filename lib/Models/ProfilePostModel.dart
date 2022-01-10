class ProfilePostModel {
  ProfilePostModel({
    required this.status,
    this.message,
    this.error,
    required this.data,
  });
  late final String status;
  late final Null message;
  late final Null error;
  late final Data data;

  ProfilePostModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = null;
    error = null;
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['error'] = error;
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.result,
  });
  late final Result result;

  Data.fromJson(Map<String, dynamic> json) {
    result = Result.fromJson(json['result']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result.toJson();
    return _data;
  }
}

class Result {
  Result({
    required this.posts,
    required this.totalPosts,
    required this.follow,
    required this.selfUser,
  });
  late final List<Posts> posts;
  late final int totalPosts;
  late final bool follow;
  late final bool selfUser;

  Result.fromJson(Map<String, dynamic> json) {
    posts = List.from(json['posts']).map((e) => Posts.fromJson(e)).toList();
    totalPosts = json['total_posts'];
    follow = json['follow'];
    selfUser = json['self_user'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['posts'] = posts.map((e) => e.toJson()).toList();
    _data['total_posts'] = totalPosts;
    _data['follow'] = follow;
    _data['self_user'] = selfUser;
    return _data;
  }
}

class Posts {
  Posts({
    required this.postId,
    required this.submittedHeadline,
    required this.submittedStory,
    required this.headline,
    required this.story,
    required this.images,
    required this.videos,
    required this.type,
    required this.tags,
    required this.author,
    required this.authorType,
    required this.authorClassification,
    required this.status,
    required this.impressions,
    required this.views,
    required this.postCreatedDate,
    required this.createdDate,
    this.context,
    required this.isUgc,
    required this.likes,
    this.id,
    required this.isLiked,
    required this.shares,
    required this.itemType,
    required this.shararableDate,
  });
  late final int postId;
  late final String submittedHeadline;
  late final String submittedStory;
  late final String headline;
  late final String story;
  late final List<String> images;
  late final List<Videos> videos;
  late final String type;
  late final List<String> tags;
  late final Author author;
  late final String authorType;
  late final String authorClassification;
  late final String status;
  late final int impressions;
  late final int views;
  late final String postCreatedDate;
  late final String createdDate;
  late final Null context;
  late final bool isUgc;
  late final int likes;
  late final Null id;
  late final bool isLiked;
  late final int shares;
  late final String itemType;
  late final String shararableDate;

  Posts.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    submittedHeadline = json['submitted_headline'];
    submittedStory = json['submitted_story'];
    headline = json['headline'];
    story = json['story'];
    images = List.castFrom<dynamic, String>(json['images']);
    videos = List.from(json['videos']).map((e) => Videos.fromJson(e)).toList();
    type = json['type'];
    tags = List.castFrom<dynamic, String>(json['tags']);
    author = Author.fromJson(json['author']);
    authorType = json['author_type'];
    authorClassification = json['author_classification'];
    status = json['status'];
    impressions = json['impressions'];
    views = json['views'];
    postCreatedDate = json['post_created_date'];
    createdDate = json['created_date'];
    context = null;
    isUgc = json['is_ugc'];
    likes = json['likes'];
    id = null;
    isLiked = json['is_liked'];
    shares = json['shares'];
    itemType = json['item_type'];
    shararableDate = json['shararable_date'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['post_id'] = postId;
    _data['submitted_headline'] = submittedHeadline;
    _data['submitted_story'] = submittedStory;
    _data['headline'] = headline;
    _data['story'] = story;
    _data['images'] = images;
    _data['videos'] = videos.map((e) => e.toJson()).toList();
    _data['type'] = type;
    _data['tags'] = tags;
    _data['author'] = author.toJson();
    _data['author_type'] = authorType;
    _data['author_classification'] = authorClassification;
    _data['status'] = status;
    _data['impressions'] = impressions;
    _data['views'] = views;
    _data['post_created_date'] = postCreatedDate;
    _data['created_date'] = createdDate;
    _data['context'] = context;
    _data['is_ugc'] = isUgc;
    _data['likes'] = likes;
    _data['id'] = id;
    _data['is_liked'] = isLiked;
    _data['shares'] = shares;
    _data['item_type'] = itemType;
    _data['shararable_date'] = shararableDate;
    return _data;
  }
}

class Videos {
  Videos({
    required this.src,
    required this.thumbnail,
    required this.player,
    required this.vimeoUrl,
    required this.width,
    required this.height,
  });
  late final String src;
  late final String thumbnail;
  late final String player;
  late final String vimeoUrl;
  late final int width;
  late final int height;

  Videos.fromJson(Map<String, dynamic> json) {
    src = json['src'];
    thumbnail = json['thumbnail'];
    player = json['player'];
    vimeoUrl = json['vimeo_url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['src'] = src;
    _data['thumbnail'] = thumbnail;
    _data['player'] = player;
    _data['vimeo_url'] = vimeoUrl;
    _data['width'] = width;
    _data['height'] = height;
    return _data;
  }
}

class Author {
  Author({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
  });
  late final int id;
  late final String name;
  late final String image;
  late final String type;

  Author.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['image'] = image;
    _data['type'] = type;
    return _data;
  }
}
