import 'package:threekm/Models/shopModel/restaurants_model.dart';

class BiryaniRestroModel {
  BiryaniRestroModel({
    required this.StatusCode,
    required this.result,
  });
  late final int StatusCode;
  late final Result result;

  BiryaniRestroModel.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];
    result = Result.fromJson(json['Result']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = StatusCode;
    _data['Result'] = result.toJson();
    return _data;
  }
}

class Result {
  Result({
    required this.creators,
  });
  late final List<Creators> creators;

  Result.fromJson(Map<String, dynamic> json) {
    creators =
        List.from(json['creators']).map((e) => Creators.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['creators'] = creators.map((e) => e.toJson()).toList();
    return _data;
  }
}

// class Creators {
//   Creators({
//     required this.creatorId,
//     required this.businessName,
//     required this.logo,
//     required this.cover,
//     required this.address,
//     required this.restaurant,
//     this.id,
//   });
//   late final int creatorId;
//   late final String businessName;
//   late final String logo;
//   late final String cover;
//   late final Address address;
//   late final Restaurant restaurant;
//   late final Null id;

//   Creators.fromJson(Map<String, dynamic> json) {
//     creatorId = json['creator_id'];
//     businessName = json['business_name'];
//     logo = json['logo'];
//     cover = json['cover'];
//     address = Address.fromJson(json['address']);
//     restaurant = Restaurant.fromJson(json['restaurant']);
//     id = null;
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['creator_id'] = creatorId;
//     _data['business_name'] = businessName;
//     _data['logo'] = logo;
//     _data['cover'] = cover;
//     _data['address'] = address.toJson();
//     _data['restaurant'] = restaurant.toJson();
//     _data['id'] = id;
//     return _data;
//   }
// }

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
    flatNo = json['flat_no'];
    street = json['street'];
    landmark = json['landmark'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    serviceArea = json['service_area'];
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

class Restaurant {
  Restaurant({
    required this.creatorId,
    required this.cuisines,
    required this.status,
    required this.id,
  });
  late final int creatorId;
  late final List<String> cuisines;
  late final bool status;

  late final String id;

  Restaurant.fromJson(Map<String, dynamic> json) {
    creatorId = json['creator_id'];
    cuisines = List.castFrom<dynamic, String>(json['cuisines']);
    status = json['status'];

    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['creator_id'] = creatorId;
    _data['cuisines'] = cuisines;
    _data['status'] = status;

    _data['id'] = id;
    return _data;
  }
}
