class ProductDetailsModel {
  int? statusCode;
  Result? result;

  ProductDetailsModel({this.statusCode, this.result});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    result = Result.fromJson(json['Result']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StatusCode'] = statusCode;
    if (result != null) {
      data['Result'] = result?.toJson();
    }
    return data;
  }
}

class Result {
  late Product product;
  late final List<Variations>? variations;
  List<Reviews>? reviews;

  Result({required this.product, this.variations, this.reviews});

  Result.fromJson(Map<String, dynamic> json) {
    product = Product.fromJson(json['product']);
    if (json['variations'] != null) {
      variations = List.from(json['variations'])
          .map((e) => Variations.fromJson(e))
          .toList();
      // variations = [];
      // json['variations'].forEach((v) {
      //   variations?.add(v);
      // });
    }
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews?.add(Reviews.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (product != null) {
      data['product'] = this.product.toJson();
    }
    if (variations != null) {
      data['variations'] = variations?.map((v) => v.toJson()).toList();
    }
    if (reviews != null) {
      data['reviews'] = reviews?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  late int catalogId;
  late int creatorId;
  late String name;
  late String description;
  late String sku;
  late List<String> tags;
  late int leadTime;
  late int price;
  late num weight;
  late String image;
  late List<String> images;
  late bool nationwideDelivery;
  late int nationwideDeliveryCost;
  late bool hasVariations;
  late bool manageStock;
  late bool isInStock;
  late int masterStock;
  late bool hasDiscount;
  late String discountType;
  late num discountValue;
  late bool discountDates;
  late String discountStartDate;
  late String discountEndDate;
  late bool isActive;
  late String urlkey;
  late String status;
  late CreatorDetails creatorDetails;
  late var id;
  late final int strikePrice;
  late final int ogAmount;
  late String businessName;

  Product(
      {required this.catalogId,
      required this.creatorId,
      required this.name,
      required this.description,
      required this.sku,
      required this.tags,
      required this.leadTime,
      required this.price,
      required this.weight,
      required this.image,
      required this.images,
      required this.nationwideDelivery,
      required this.nationwideDeliveryCost,
      required this.hasVariations,
      required this.manageStock,
      required this.isInStock,
      required this.masterStock,
      required this.hasDiscount,
      required this.discountType,
      required this.discountValue,
      required this.discountDates,
      required this.discountStartDate,
      required this.discountEndDate,
      required this.isActive,
      required this.urlkey,
      required this.status,
      required this.creatorDetails,
      required this.id,
      required this.strikePrice,
      required this.ogAmount,
      required this.businessName});

  Product.fromJson(Map<String, dynamic> json) {
    catalogId = json['catalog_id'];
    creatorId = json['creator_id'];
    name = json['name'];
    description = json['description'];
    sku = json['sku'];
    // tags = json['tags'].cast<String>();
    if (json['tags'] != null) {
      tags = <String>[];
      (json['tags'] as List).forEach((tag) {
        tags.add(tag);
      });
    }
    leadTime = json['lead_time'];
    price = json['price'];
    weight = json['weight'];
    image = json['image'];
    // images = json['images'].forEach((e)=>{

    // });
    if (json['images'] != null) {
      images = <String>[];
      (json['images'] as List).forEach((v) {
        v.startsWith('http') ? images.add(v) : images.add('http://$v');
      });
    }
    nationwideDelivery = json['nationwide_delivery'];
    nationwideDeliveryCost = json['nationwide_delivery_cost'] ?? 0;
    hasVariations = json['has_variations'];
    manageStock = json['manage_stock'];
    isInStock = json['is_in_stock'];
    masterStock = json['master_stock'];
    hasDiscount = json['has_discount'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'] ?? 0;
    discountDates = json['discount_dates'];
    discountStartDate = json['discount_start_date'];
    discountEndDate = json['discount_end_date'];
    isActive = json['is_active'];
    urlkey = json['urlkey'];
    status = json['status'];
    creatorDetails = CreatorDetails.fromJson(json['creator_details']);
    id = json['id'];
    strikePrice = json['strike_price'];
    ogAmount = json['og_amount'] ?? 0;
    businessName = json['business_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catalog_id'] = catalogId;
    data['creator_id'] = creatorId;
    data['name'] = name;
    data['description'] = description;
    data['sku'] = sku;
    data['tags'] = tags;
    data['lead_time'] = leadTime;
    data['price'] = price;
    data['weight'] = weight;
    data['image'] = image;
    data['images'] = images;
    data['nationwide_delivery'] = nationwideDelivery;
    data['nationwide_delivery_cost'] = nationwideDeliveryCost;
    data['has_variations'] = hasVariations;
    data['manage_stock'] = manageStock;
    data['is_in_stock'] = isInStock;
    data['master_stock'] = masterStock;
    data['has_discount'] = hasDiscount;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['discount_dates'] = discountDates;
    data['discount_start_date'] = discountStartDate;
    data['discount_end_date'] = discountEndDate;
    data['is_active'] = isActive;
    data['urlkey'] = urlkey;
    data['status'] = status;
    if (creatorDetails != null) {
      data['creator_details'] = creatorDetails.toJson();
    }
    data['id'] = id;
    data['strike_price'] = strikePrice;
    data['og_amount'] = ogAmount;
    data['business_name'] = businessName;
    return data;
  }
}

class CreatorDetails {
  late int creatorId;
  late String businessName;
  late String logo;
  late String firstname;
  late String lastname;
  late String sId;
  late String id;

  CreatorDetails(
      {required this.creatorId,
      required this.businessName,
      required this.logo,
      required this.firstname,
      required this.lastname,
      required this.sId,
      required this.id});

  CreatorDetails.fromJson(Map<String, dynamic> json) {
    creatorId = json['creator_id'];
    businessName = json['business_name'];
    logo = json['logo'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    sId = json['_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['creator_id'] = creatorId;
    data['business_name'] = businessName;
    data['logo'] = logo;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['_id'] = sId;
    data['id'] = id;
    return data;
  }
}

class Reviews {
  late int reviewId;
  late int userId;
  late int rating;
  late String title;
  late String description;
  late List<String> images;
  late int deliveryRating;
  late var id;
  late String date;
  late String user;
  late String avatar;

  Reviews(
      {required this.reviewId,
      required this.userId,
      required this.rating,
      required this.title,
      required this.description,
      required this.images,
      required this.deliveryRating,
      required this.id,
      required this.date,
      required this.user,
      required this.avatar});

  Reviews.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    userId = json['user_id'];
    rating = json['rating'];
    title = json['title'];
    description = json['description'];
    if (json['images'] != null) {
      images = <String>[];
      json['images'].forEach((v) {
        images.add(v);
      });
    }
    deliveryRating = json['delivery_rating'];
    id = json['id'];
    date = json['date'];
    user = json['user'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['review_id'] = reviewId;
    data['user_id'] = userId;
    data['rating'] = rating;
    data['title'] = title;
    data['description'] = description;
    if (images != null) {
      data['images'] = images.map((v) => v).toList();
    }
    data['delivery_rating'] = deliveryRating;
    data['id'] = id;
    data['date'] = date;
    data['user'] = user;
    data['avatar'] = avatar;
    return data;
  }
}

class Variations {
  Variations({
    required this.variationId,
    required this.price,
    required this.weight,
    required this.imagesLinks,
    required this.isInStock,
    required this.masterStock,
    required this.isActive,
    required this.options,
    this.id,
    required this.ogAmount,
  });
  late final int variationId;
  late final int price;
  late var weight;
  late final List<dynamic> imagesLinks;
  late final bool isInStock;
  late var masterStock;
  late final bool isActive;
  late final Map<String, dynamic> options;
  late final Null id;
  late final int ogAmount;

  Variations.fromJson(Map<String, dynamic> json) {
    variationId = json['variation_id'];
    price = json['price'];
    weight = json['weight'];
    imagesLinks = List.castFrom<dynamic, dynamic>(json['images_links']);
    isInStock = json['is_in_stock'];
    masterStock = json['master_stock'] ?? 0;
    isActive = json['is_active'];
    options = json['options'];
    id = null;
    ogAmount = json['og_amount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['variation_id'] = variationId;
    _data['price'] = price;
    _data['weight'] = weight;
    _data['images_links'] = imagesLinks;
    _data['is_in_stock'] = isInStock;
    _data['master_stock'] = masterStock;
    _data['is_active'] = isActive;
    _data['options'] = options;
    _data['id'] = id;
    _data['og_amount'] = ogAmount;
    return _data;
  }
}
