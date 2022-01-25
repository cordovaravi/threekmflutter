class ProductListingModel {
  num? statusCode;
  Result? result;

  ProductListingModel({this.statusCode, this.result});

  ProductListingModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    result = json['Result'] != null ? Result.fromJson(json['Result']) : null;
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
  List<Products> products = [];
  num total = 0;
  List? menus;
  num? totalMenu;
  String? banner;
  List? subCategories;

  Result(
      {required this.products,
      required this.total,
      this.menus,
      this.totalMenu,
      this.banner,
      this.subCategories});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products.add(Products.fromJson(v));
      });
    }
    if (json['total'] is int) {
      total = json['total'];
    } else {
      total = json['total']['value'];
    }
    if (json['menus'] != null) {
      menus = [];
      json['menus'].forEach((v) {
        menus?.add(v);
      });
    }
    totalMenu = json['total_menu'];
    banner = json['banner'];
    if (json['sub_categories'] != null) {
      subCategories = [];
      json['sub_categories'].forEach((v) {
        subCategories?.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    if (menus != null) {
      data['menus'] = menus?.map((v) => v.toJson()).toList();
    }
    data['total_menu'] = this.totalMenu;
    data['banner'] = this.banner;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  num? catalogId;
  String? sku;
  String? name;
  List? categories;
  List<String>? tags;
  num? price;
  num? strikePrice;
  String? image;
  bool? hasVariations;
  num? masterStock;
  num? weight;
  bool? isInStock;
  bool? isExclusive;
  num? creatorId;
  String? businessName;
  String? variationText;
  String? partner;
  String? status;
  bool? isActive;
  bool? isDeleted;
  Pin? pin;

  Products(
      {this.catalogId,
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
      this.pin});

  Products.fromJson(Map<String, dynamic> json) {
    catalogId = json['catalog_id'];
    sku = json['sku'];
    name = json['name'];
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(v);
      });
    }
    tags = json['tags'].cast<String>();
    price = json['price'];
    strikePrice = json['strike_price'];
    image = json['image'];
    hasVariations = json['has_variations'];
    masterStock = json['master_stock'];
    weight = json['weight'];
    isInStock = json['is_in_stock'];
    isExclusive = json['is_exclusive'];
    creatorId = json['creator_id'];
    businessName = json['business_name'];
    variationText = json['variation_text'];
    partner = json['partner'];
    status = json['status'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    pin = json['pin'] != null ? Pin.fromJson(json['pin']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catalog_id'] = catalogId;
    data['sku'] = sku;
    data['name'] = name;
    if (categories != null) {
      data['categories'] = categories?.map((v) => v.toJson()).toList();
    }
    data['tags'] = tags;
    data['price'] = price;
    data['strike_price'] = strikePrice;
    data['image'] = image;
    data['has_variations'] = hasVariations;
    data['master_stock'] = masterStock;
    data['weight'] = weight;
    data['is_in_stock'] = isInStock;
    data['is_exclusive'] = isExclusive;
    data['creator_id'] = creatorId;
    data['business_name'] = businessName;
    data['variation_text'] = variationText;
    data['partner'] = partner;
    data['status'] = status;
    data['is_active'] = isActive;
    data['is_deleted'] = isDeleted;
    if (pin != null) {
      data['pin'] = pin?.toJson();
    }
    return data;
  }
}

class Pin {
  Location? location;

  Pin({location});

  Pin.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location?.toJson();
    }
    return data;
  }
}

class Location {
  num? lat;
  num? lon;

  Location({this.lat, this.lon});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}
