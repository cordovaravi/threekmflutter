class ShopHomeModel {
  int? statusCode;
  Result? result;

  ShopHomeModel({this.statusCode, this.result});

  ShopHomeModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['StatusCode'] = statusCode;
    if (result != null) {
      data['Result'] = result?.toJson();
    }
    return data;
  }
}

class Result {
  List<String>? tags;
  List<Trending> trending = [];
  List<Advertisements>? advertisements;
  List<Shops>? shops;
  List<ShopAdv>? shopAdv;

  Result({
    this.tags,
    required this.trending,
    this.advertisements,
    this.shops,
    this.shopAdv,
  });

  Result.fromJson(Map<String, dynamic> json) {
    tags = json['tags'].cast<String>();
    if (json['trending'] != null) {
      trending = <Trending>[];
      json['trending'].forEach((v) {
        trending.add(Trending.fromJson(v));
      });
    }
    if (json['advertisements'] != null) {
      advertisements = <Advertisements>[];
      json['advertisements'].forEach((v) {
        advertisements?.add(Advertisements.fromJson(v));
      });
    }
    if (json['shops'] != null) {
      shops = <Shops>[];
      shopAdv = <ShopAdv>[];
      json['shops'].forEach((v) {
        v['type'] == "products"
            ? shops?.add(Shops.fromJson(v))
            : shopAdv?.add(ShopAdv.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['tags'] = tags;
    if (trending != null) {
      data['trending'] = trending.map((v) => v.toJson()).toList();
    }
    if (advertisements != null) {
      data['advertisements'] = advertisements?.map((v) => v.toJson()).toList();
    }
    if (shops != null) {
      data['shops'] = shops?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trending {
  String? name;
  late String image;
  int? category;

  Trending({this.name, required this.image, this.category});

  Trending.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['image'] = image;
    data['category'] = category;
    return data;
  }
}

class Advertisements {
  int? advId;
  List<String>? images;
  List? videos;
  String? type;
  var id;
  List<Imageswcta>? imageswcta;
  String? advType;

  Advertisements(
      {this.advId,
      this.images,
      this.videos,
      this.type,
      this.id,
      this.imageswcta,
      this.advType});

  Advertisements.fromJson(Map<String, dynamic> json) {
    advId = json['adv_id'];
    images = json['images'].cast<String>();
    if (json['videos'] != null) {
      videos = [];
      json['videos'].forEach((v) {
        videos?.add(v);
      });
    }
    type = json['type'];
    id = json['id'];
    if (json['imageswcta'] != null) {
      imageswcta = <Imageswcta>[];
      json['imageswcta'].forEach((v) {
        imageswcta?.add(Imageswcta.fromJson(v));
      });
    }
    advType = json['adv_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['adv_id'] = advId;
    data['images'] = images;
    if (videos != null) {
      data['videos'] = videos?.map((v) => v.toJson()).toList();
    }
    data['type'] = type;
    data['id'] = id;
    if (imageswcta != null) {
      data['imageswcta'] = imageswcta?.map((v) => v.toJson()).toList();
    }
    data['adv_type'] = advType;
    return data;
  }
}

class Imageswcta {
  String? image;
  var business;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['image'] = image;
    data['business'] = business;
    data['website'] = website;
    data['product'] = product;
    data['phone'] = phone;
    return data;
  }
}

class Shops {
  int? advId;
  List<String>? images;
  List<String>? videos;
  String? type;
  String? id;
  List<Imageswcta>? imageswcta;
  String? advType;
  String? name;
  int? category;
  List<Products>? products;

  Shops(
      {this.advId,
      this.images,
      this.videos,
      this.type,
      this.id,
      this.imageswcta,
      this.advType,
      this.name,
      this.category,
      this.products});

  Shops.fromJson(Map<String, dynamic> json) {
    advId = json['adv_id'];

    images =
        json['images'] == null ? [] : (json['images'] as List).cast<String>();
    if (json['videos'] != null) {
      videos = <String>[];
      json['videos'].forEach((v) {
        videos?.add(v);
      });
    }
    type = json['type'];
    id = json['id'];
    if (json['imageswcta'] != null) {
      imageswcta = <Imageswcta>[];
      json['imageswcta'].forEach((v) {
        imageswcta?.add(Imageswcta.fromJson(v));
      });
    }
    advType = json['adv_type'];
    name = json['name'];
    category = json['category'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['adv_id'] = advId;
    data['images'] = images;
    if (videos != null) {
      data['videos'] = videos?.map((v) => v);
    }
    data['type'] = type;
    data['id'] = id;
    if (imageswcta != null) {
      data['imageswcta'] = imageswcta?.map((v) => v.toJson()).toList();
    }
    data['adv_type'] = advType;
    data['name'] = name;
    data['category'] = category;
    if (products != null) {
      data['products'] = products?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? catalogId;
  int? creatorId;
  String? name;
  String? sku;
  List<String>? tags;
  int? price;
  num? weight;
  String? image;
  CreatorDetails? creatorDetails;
  var id;
  String? businessName;

  Products(
      {this.catalogId,
      this.creatorId,
      this.name,
      this.sku,
      this.tags,
      this.price,
      this.weight,
      this.image,
      this.creatorDetails,
      this.id,
      this.businessName});

  Products.fromJson(Map<String, dynamic> json) {
    catalogId = json['catalog_id'];
    creatorId = json['creator_id'];
    name = json['name'];
    sku = json['sku'];
    tags = json['tags'].cast<String>();
    price = json['price'];
    weight = json['weight'];
    image = json['image'].toString().startsWith('http')
        ? json['image']
        : 'http://${json['image']}';
    creatorDetails = json['creator_details'] != null
        ? CreatorDetails.fromJson(json['creator_details'])
        : null;
    id = json['id'];
    businessName = json['business_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['catalog_id'] = catalogId;
    data['creator_id'] = creatorId;
    data['name'] = name;
    data['sku'] = sku;
    data['tags'] = tags;
    data['price'] = price;
    data['weight'] = weight;
    data['image'] = image;
    if (creatorDetails != null) {
      data['creator_details'] = creatorDetails?.toJson();
    }
    data['id'] = id;
    data['business_name'] = businessName;
    return data;
  }
}

class CreatorDetails {
  int? creatorId;
  String? businessName;
  String? sId;
  String? id;

  CreatorDetails({this.creatorId, this.businessName, this.sId, this.id});

  CreatorDetails.fromJson(Map<String, dynamic> json) {
    creatorId = json['creator_id'];
    businessName = json['business_name'];
    sId = json['_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['creator_id'] = creatorId;
    data['business_name'] = businessName;
    data['_id'] = sId;
    data['id'] = id;
    return data;
  }
}

class ShopAdv {
  late int advId;
  List<String>? images;
  List<String>? videos;
  late String type;
  var id;
  List<Imageswcta>? imageswcta;
  late String advType;

  ShopAdv(
      {required this.advId,
      this.images,
      this.videos,
      required this.type,
      this.id,
      this.imageswcta,
      required this.advType});

  ShopAdv.fromJson(Map<String, dynamic> json) {
    advId = json['adv_id'];
    images = json['images'].cast<String>();
    if (json['videos'] != null) {
      // ignore: prefer_void_to_null
      videos = <String>[];
      json['videos'].forEach((v) {
        videos?.add(v);
      });
    }
    type = json['type'];
    id = json['id'];
    if (json['imageswcta'] != null) {
      // ignore: unnecessary_new
      imageswcta = <Imageswcta>[];
      json['imageswcta'].forEach((v) {
        imageswcta?.add(Imageswcta.fromJson(v));
      });
    }
    advType = json['adv_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adv_id'] = this.advId;
    data['images'] = this.images;
    if (this.videos != null) {
      data['videos'] = this.videos?.map((v) => v);
    }
    data['type'] = this.type;
    data['id'] = this.id;
    if (this.imageswcta != null) {
      data['imageswcta'] = this.imageswcta?.map((v) => v.toJson()).toList();
    }
    data['adv_type'] = this.advType;
    return data;
  }
}
