class CuisinesRestroList {
  CuisinesRestroList({
    this.status,
    this.message,
    this.error,
    this.data,
  });
  late final String? status;
  late final String? message;
  late final Null? error;
  late final Data? data;

  CuisinesRestroList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = null;
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['error'] = error;
    _data['data'] = data?.toJson();
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
    required this.data,
  });
  late final List<CuisinesRestaurant> data;

  Result.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => CuisinesRestaurant.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class CuisinesRestaurant {
  CuisinesRestaurant(
      {required this.id,
      required this.restaurantId,
      required this.creatorId,
      required this.businessName,
      required this.logo,
      required this.cover,
      required this.cuisines,
      required this.address,
      required this.status});
  late final String id;
  late final int restaurantId;
  late final int creatorId;
  late final String businessName;
  late final String logo;
  late final String cover;
  late final List<String> cuisines;
  late final Address address;
  late final bool status;

  CuisinesRestaurant.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    restaurantId = json['restaurant_id'];
    creatorId = json['creator_id'];
    businessName = json['business_name'];
    logo = json['logo'];
    cover = json['cover'];
    cuisines = List.castFrom<dynamic, String>(json['cuisines']);
    address = Address.fromJson(json['address']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['restaurant_id'] = restaurantId;
    _data['creator_id'] = creatorId;
    _data['business_name'] = businessName;
    _data['logo'] = logo;
    _data['cover'] = cover;
    _data['cuisines'] = cuisines;
    _data['address'] = address.toJson();
    return _data;
  }
}

class Address {
  Address({
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
  late final String pincode;
  late final double latitude;
  late final double longitude;
  late final String serviceArea;

  Address.fromJson(Map<String, dynamic> json) {
    flatNo = json['flat_no'] ?? "";
    street = json['street'] ?? "";
    landmark = json['landmark'] ?? "";
    area = json['area'] ?? "";
    city = json['city'] ?? "";
    state = json['state'] ?? "";
    country = json['country'] ?? "";
    pincode = json['pincode'] is int ? '${json['pincode']}' : "";
    latitude = json['latitude'] != null && json['latitude'] != ""
        ? json['latitude'] is String
            ? double.parse(json['latitude'])
            : json['latitude']
        : 0.0;
    longitude = json['longitude'] != null && json['longitude'] != ""
        ? json['longitude'] is String
            ? double.parse(json['longitude'])
            : json['longitude']
        : 0.0;
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
