// To parse this JSON data, do
//
//     final shopSearch = shopSearchFromJson(jsonString);

import 'dart:convert';

ShopSearch shopSearchFromJson(String str) =>
    ShopSearch.fromJson(json.decode(str));

class ShopSearch {
  ShopSearch({
    this.statusCode,
    this.result,
  });

  int? statusCode;
  Result? result;

  factory ShopSearch.fromJson(Map<String, dynamic> json) => ShopSearch(
        statusCode: json["StatusCode"] == null ? null : json["StatusCode"],
        result: json["Result"] == null ? null : Result.fromJson(json["Result"]),
      );
}

class Result {
  Result({
    this.products,
    this.total,
    this.menus,
    this.totalMenu,
    this.banner,
    this.subCategories,
  });

  List<Product>? products;
  int? total;
  List<dynamic>? menus;
  int? totalMenu;
  String? banner;
  List<dynamic>? subCategories;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        total: json["total"] == null ? null : json["total"],
        menus: json["menus"] == null
            ? null
            : List<dynamic>.from(json["menus"].map((x) => x)),
        totalMenu: json["total_menu"] == null ? null : json["total_menu"],
        banner: json["banner"] == null ? null : json["banner"],
        subCategories: json["sub_categories"] == null
            ? null
            : List<dynamic>.from(json["sub_categories"].map((x) => x)),
      );
}

class Product {
  Product({
    this.catalogId,
    this.sku,
    this.name,
    this.categories,
    this.tags,
    this.price,
    this.strikePrice,
    this.image,
    this.hasVariations,
    this.masterStock,
    this.weight,
    this.isInStock,
    this.isExclusive,
    this.creatorId,
    this.businessName,
    this.variationText,
    this.partner,
    this.status,
    this.isActive,
    this.isDeleted,
    this.pin,
  });

  int? catalogId;
  String? sku;
  String? name;
  List<dynamic>? categories;
  List<String>? tags;
  double? price;
  int? strikePrice;
  String? image;
  bool? hasVariations;
  int? masterStock;
  double? weight;
  bool? isInStock;
  bool? isExclusive;
  int? creatorId;
  String? businessName;
  String? variationText;
  Partner? partner;
  Status? status;
  bool? isActive;
  bool? isDeleted;
  Pin? pin;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        catalogId: json["catalog_id"] == null ? null : json["catalog_id"],
        sku: json["sku"] == null ? null : json["sku"],
        name: json["name"] == null ? null : json["name"],
        categories: json["categories"] == null
            ? null
            : List<dynamic>.from(json["categories"].map((x) => x)),
        tags: json["tags"] == null
            ? null
            : List<String>.from(json["tags"].map((x) => x)),
        price: json["price"] == null ? null : json["price"].toDouble(),
        strikePrice: json["strike_price"] == null ? null : json["strike_price"],
        image: json["image"] == null ? null : json["image"],
        hasVariations:
            json["has_variations"] == null ? null : json["has_variations"],
        masterStock: json["master_stock"] == null ? null : json["master_stock"],
        weight: json["weight"] == null ? null : json["weight"].toDouble(),
        isInStock: json["is_in_stock"] == null ? null : json["is_in_stock"],
        isExclusive: json["is_exclusive"] == null ? null : json["is_exclusive"],
        creatorId: json["creator_id"] == null ? null : json["creator_id"],
        businessName:
            json["business_name"] == null ? null : json["business_name"],
        variationText:
            json["variation_text"] == null ? null : json["variation_text"],
        partner:
            json["partner"] == null ? null : partnerValues.map[json["partner"]],
        status:
            json["status"] == null ? null : statusValues.map[json["status"]],
        isActive: json["is_active"] == null ? null : json["is_active"],
        isDeleted: json["is_deleted"] == null ? null : json["is_deleted"],
        pin: json["pin"] == null ? null : Pin.fromJson(json["pin"]),
      );
}

enum Partner { SAKAL }

final partnerValues = EnumValues({"sakal": Partner.SAKAL});

class Pin {
  Pin({
    this.location,
  });

  Location? location;

  factory Pin.fromJson(Map<String, dynamic> json) => Pin(
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
      );
}

class Location {
  Location({
    this.lat,
    this.lon,
  });

  double? lat;
  double? lon;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lon: json["lon"] == null ? null : json["lon"].toDouble(),
      );
}

enum Status { ACTIVATED }

final statusValues = EnumValues({"ACTIVATED": Status.ACTIVATED});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
