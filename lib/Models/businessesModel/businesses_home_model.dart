class BusinessesHomeModel {
  int? statusCode;
  Result? result;

  BusinessesHomeModel({this.statusCode, this.result});

  BusinessesHomeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    if (result != null) {
      data['Result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  Slider? slider;
  Categories? categories;
  List<Advertisements>? advertisements;
  List<Businesses>? businesses;
  List<BaseAdd>? baseAdd;
  List<Advertisements>? businessesAdd;

  Result({
    this.slider,
    this.categories,
    this.advertisements,
    this.businesses,
    this.baseAdd,
  });

  Result.fromJson(Map<String, dynamic> json) {
    slider = json['slider'] != null ? Slider.fromJson(json['slider']) : null;
    categories = json['categories'] != null
        ? Categories.fromJson(json['categories'])
        : null;
    if (json['advertisements'] != null) {
      advertisements = <Advertisements>[];
      json['advertisements'].forEach((v) {
        advertisements!.add(Advertisements.fromJson(v));
      });
    }
    if (json['businesses'] != null) {
      businesses = <Businesses>[];
      businessesAdd = <Advertisements>[];
      json['businesses'].forEach((v) {
        v['type'] == 'buss_slider'
            ? businesses!.add(Businesses.fromJson(v))
            : businessesAdd?.add(Advertisements.fromJson(v));
      });
    }
    if (json['base_add'] != null) {
      baseAdd = <BaseAdd>[];
      json['base_add'].forEach((v) {
        baseAdd!.add(BaseAdd.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (slider != null) {
      data['slider'] = slider!.toJson();
    }
    if (categories != null) {
      data['categories'] = categories!.toJson();
    }
    if (advertisements != null) {
      data['advertisements'] = advertisements!.map((v) => v.toJson()).toList();
    }
    if (businesses != null) {
      data['businesses'] = businesses!.map((v) => v.toJson()).toList();
    }
    if (baseAdd != null) {
      data['base_add'] = baseAdd!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slider {
  int? statusCode;
  List<Advertisements>? result;

  Slider({this.statusCode, this.result});

  Slider.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    if (json['Result'] != null) {
      result = <Advertisements>[];
      json['Result'].forEach((v) {
        result!.add(Advertisements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['StatusCode'] = statusCode;
    if (result != null) {
      data['Result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  Categories({
    required this.StatusCode,
    required this.Result,
  });
  late final int StatusCode;
  late final List<CResult> Result;

  Categories.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];

    Result = <CResult>[];
    json['Result'].forEach((e) => Result.add(CResult.fromJson(e)));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = StatusCode;
    _data['Result'] = Result.map((e) => e.toJson()).toList();
    return _data;
  }
}

class CResult {
  CResult({
    required this.categoryId,
    required this.name,
    required this.imageLink,
    this.id,
  });
  late final int categoryId;
  late final String name;
  late final String imageLink;
  late final Null id;

  CResult.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    imageLink = json['image_link'];
    id = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['category_id'] = categoryId;
    _data['name'] = name;
    _data['image_link'] = imageLink;
    _data['id'] = id;
    return _data;
  }
}

class Businesses {
  Businesses({
    required this.type,
    required this.name,
    required this.desc,
    required this.tags,
    required this.searchText,
    required this.business,
  });
  late final String type;
  late final String name;
  late final String desc;
  late final List<String> tags;
  late final String searchText;
  late final List<Business> business;

  Businesses.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    name = json['name'];
    desc = json['desc'];
    tags = List.castFrom<dynamic, String>(json['tags']);
    searchText = json['search_text'];
    business =
        List.from(json['business']).map((e) => Business.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['type'] = type;
    _data['name'] = name;
    _data['desc'] = desc;
    _data['tags'] = tags;
    _data['search_text'] = searchText;
    _data['business'] = business.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Business {
  Business({
    required this.creatorId,
    required this.firstname,
    required this.lastname,
    required this.businessName,
    required this.image,
    required this.tags,
    required this.rating,
    required this.star,
  });
  late final int creatorId;
  late final String firstname;
  late final String lastname;
  late final String businessName;
  late final String image;
  late final List<String> tags;
  late final String rating;
  late final bool star;

  Business.fromJson(Map<String, dynamic> json) {
    creatorId = json['creator_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    businessName = json['business_name'];
    image = json['image'];
    tags = List.castFrom<dynamic, String>(json['tags']);
    rating = json['rating'];
    star = json['star'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['creator_id'] = creatorId;
    _data['firstname'] = firstname;
    _data['lastname'] = lastname;
    _data['business_name'] = businessName;
    _data['image'] = image;
    _data['tags'] = tags;
    _data['rating'] = rating;
    _data['star'] = star;
    return _data;
  }
}

class Imageswcta {
  String? image;
  String? business;
  String? website;
  String? product;
  String? phone;

  Imageswcta(
      {this.image, this.business, this.website, this.product, this.phone});

  Imageswcta.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    business = json['business'];
    website = json['website'];
    product = json['product'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['business'] = this.business;
    data['website'] = this.website;
    data['product'] = this.product;
    data['phone'] = this.phone;
    return data;
  }
}

class BaseAdd {
  BaseAdd({
    required this.name,
    required this.image,
    required this.tagLine,
  });
  late final String name;
  late final String image;
  late final String tagLine;

  BaseAdd.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    tagLine = json['tag_line'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['image'] = image;
    _data['tag_line'] = tagLine;
    return _data;
  }
}

class Advertisements {
  Advertisements(
      {required this.advId,
      this.id,
      required this.images,
      required this.type,
      required this.videos,
      this.AdvType,
      this.imagesWcta});
  late final int advId;
  late final Null id;
  late final List<String> images;
  late final String type;
  late final List<dynamic> videos;
  List<Imageswcta>? imagesWcta;
  String? AdvType;

  Advertisements.fromJson(Map<String, dynamic> json) {
    advId = json['adv_id'] ?? 0;
    id = null;
    images = List.castFrom<dynamic, String>(json['images']);
    type = json['type'];
    videos = List.castFrom<dynamic, dynamic>(json['videos']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['adv_id'] = advId;
    _data['id'] = id;
    _data['images'] = images;
    _data['type'] = type;
    _data['videos'] = videos;
    return _data;
  }
}
