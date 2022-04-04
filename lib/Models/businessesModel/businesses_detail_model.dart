class BusinessesDetailModel {
  BusinessesDetailModel({
    required this.status,
    this.message,
    this.error,
    required this.data,
  });
  late final String status;
  late final Null message;
  late final Null error;
  late final Data data;

  BusinessesDetailModel.fromJson(Map<String, dynamic> json) {
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
    required this.creator,
    required this.products,
  });
  late final Creator creator;
  late final List<BusinessProductModel> products;

  Result.fromJson(Map<String, dynamic> json) {
    creator = Creator.fromJson(json['creator']);
    if (json['products'] != null) {
      products = <BusinessProductModel>[];
      json['products'].forEach((v) {
        products.add(BusinessProductModel.fromJson(v));
      });
    }
    ;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['creator'] = creator.toJson();
    _data['products'] = products;
    return _data;
  }
}

class Creator {
  Creator({
    required this.creatorId,
    required this.businessName,
    required this.logo,
    required this.cover,
    required this.about,
    required this.email,
    required this.phoneNo,
    required this.alternateContacts,
    required this.firstname,
    required this.lastname,
    required this.address,
    required this.urlKey,
    required this.tags,
    this.id,
    required this.image,
    required this.rating,
    required this.star,
    required this.reviews,
    required this.coverImages,
    required this.addressObj,
    required this.whatsappNo,
  });
  late final int creatorId;
  late final String businessName;
  late final String logo;
  late final String cover;
  late final String about;
  late final String email;
  late final String phoneNo;
  late final AlternateContacts alternateContacts;
  late final String firstname;
  late final String lastname;
  late final String address;
  late final String urlKey;
  late final List<String> tags;
  late final Null id;
  late final String image;
  late final String rating;
  late final bool star;
  late final List<dynamic> reviews;
  late final List<String> coverImages;
  late final AddressObj addressObj;
  late final String whatsappNo;

  Creator.fromJson(Map<String, dynamic> json) {
    creatorId = json['creator_id'];
    businessName = json['business_name'];
    logo = json['logo'];
    cover = json['cover'];
    about = json['about'];
    email = json['email'];
    phoneNo = json['phone_no'];
    if (json['alternate_contacts'] != null) {
      alternateContacts =
          AlternateContacts.fromJson(json['alternate_contacts']);
    }
    firstname = json['firstname'];
    lastname = json['lastname'];
    address = json['address'];
    urlKey = json['url_key'];
    tags = List.castFrom<dynamic, String>(json['tags']);
    id = null;
    image = json['image'];
    rating = json['rating'];
    star = json['star'];
    reviews = List.castFrom<dynamic, dynamic>(json['reviews']);
    coverImages = List.castFrom<dynamic, String>(json['cover_images']);
    addressObj = AddressObj.fromJson(json['address_obj']);
    whatsappNo = json['whatsapp_no'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['creator_id'] = creatorId;
    _data['business_name'] = businessName;
    _data['logo'] = logo;
    _data['cover'] = cover;
    _data['about'] = about;
    _data['email'] = email;
    _data['phone_no'] = phoneNo;
    _data['alternate_contacts'] = alternateContacts.toJson();
    _data['firstname'] = firstname;
    _data['lastname'] = lastname;
    _data['address'] = address;
    _data['url_key'] = urlKey;
    _data['tags'] = tags;
    _data['id'] = id;
    _data['image'] = image;
    _data['rating'] = rating;
    _data['star'] = star;
    _data['reviews'] = reviews;
    _data['cover_images'] = coverImages;
    _data['address_obj'] = addressObj.toJson();
    _data['whatsapp_no'] = whatsappNo;
    return _data;
  }
}

class AlternateContacts {
  AlternateContacts({
    required this.whatsapp,
  });
  late final String whatsapp;

  AlternateContacts.fromJson(Map<String, dynamic> json) {
    if (json['whatsapp_number'] != null) {
      whatsapp = json['whatsapp_number'];
    }
    if (json['whatsapp'] != null) {
      whatsapp = json['whatsapp'];
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['whatsapp'] = whatsapp;
    return _data;
  }
}

class AddressObj {
  AddressObj({
    required this.flatNo,
    required this.street,
    required this.landmark,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.serviceArea,
  });
  late final String flatNo;
  late final String street;
  late final String landmark;
  late final String area;
  late final String city;
  late final String state;
  late final String country;
  late var pincode;
  late final double latitude;
  late final double longitude;
  late final String serviceArea;

  AddressObj.fromJson(Map<String, dynamic> json) {
    flatNo = json['flat_no'];
    street = json['street'] ?? "";
    landmark = json['landmark'] ?? "";
    area = json['area'];
    city = json['city'] ?? "";
    state = json['state'] ?? "";
    country = json['country'];
    pincode = json['pincode'];
    latitude = json['latitude'] ?? 0.0;
    longitude = json['longitude'] ?? 0.0;
    serviceArea = json['service_area'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['flat_no'] = flatNo;
    _data['street'] = street;
    _data['landmark'] = landmark;
    _data['area'] = area;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    _data['pincode'] = pincode;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['service_area'] = serviceArea;
    return _data;
  }
}

class BusinessProductModel {
  BusinessProductModel({
    required this.catalogId,
    required this.name,
    required this.price,
    required this.image,
    required this.hasDiscount,
    required this.discountType,
    required this.discountValue,
    required this.discountDates,
    required this.discountStartDate,
    required this.discountEndDate,
    required this.urlkey,
    this.id,
  });
  late final int catalogId;
  late final String name;
  late final int price;
  late final String image;
  late final bool hasDiscount;
  late final String discountType;
  late final num discountValue;
  late final bool discountDates;
  late final String discountStartDate;
  late final String discountEndDate;
  late final String urlkey;
  late final Null id;

  BusinessProductModel.fromJson(Map<String, dynamic> json) {
    catalogId = json['catalog_id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    hasDiscount = json['has_discount'];
    discountType = json['discount_type'];
    if (json['discount_value'] != null) {
      discountValue = json['discount_value'];
    }
    discountDates = json['discount_dates'];
    discountStartDate = json['discount_start_date'];
    discountEndDate = json['discount_end_date'];
    urlkey = json['urlkey'];
    id = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['catalog_id'] = catalogId;
    _data['name'] = name;
    _data['price'] = price;
    _data['image'] = image;
    _data['has_discount'] = hasDiscount;
    _data['discount_type'] = discountType;
    _data['discount_value'] = discountValue;
    _data['discount_dates'] = discountDates;
    _data['discount_start_date'] = discountStartDate;
    _data['discount_end_date'] = discountEndDate;
    _data['urlkey'] = urlkey;
    _data['id'] = id;
    return _data;
  }
}
