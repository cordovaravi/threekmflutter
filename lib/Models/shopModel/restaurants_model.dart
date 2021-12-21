import 'package:threekm/Models/shopModel/shop_home_model.dart';


class RestaurantsModel {
  late int statusCode;
  late Result result;

  RestaurantsModel({required this.statusCode, required this.result});

  RestaurantsModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['StatusCode'];
    result = Result.fromJson(json['Result']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StatusCode'] = this.statusCode;
    if (this.result != null) {
      data['Result'] = this.result.toJson();
    }
    return data;
  }
}

class Result {
  List<Trending>? trending;
  List<Advertisements>? advertisements;
  List<Creators>? creators;

  Result({this.trending, this.advertisements, this.creators});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['trending'] != null) {
      trending = <Trending>[];
      json['trending'].forEach((v) {
        trending!.add(new Trending.fromJson(v));
      });
    }
    if (json['advertisements'] != null) {
      advertisements = <Advertisements>[];
      json['advertisements'].forEach((v) {
        advertisements!.add(new Advertisements.fromJson(v));
      });
    }
    if (json['creators'] != null) {
      creators = <Creators>[];
      json['creators'].forEach((v) {
        creators!.add(new Creators.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trending != null) {
      data['trending'] = this.trending!.map((v) => v.toJson()).toList();
    }
    if (this.advertisements != null) {
      data['advertisements'] =
          this.advertisements!.map((v) => v.toJson()).toList();
    }
    if (this.creators != null) {
      data['creators'] = this.creators!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Trending {
  String? name;
  String? image;
  List<String>? tag;

  Trending({this.name, this.image, this.tag});

  Trending.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    tag = json['tag'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['tag'] = this.tag;
    return data;
  }
}

class Creators {
  int? creatorId;
  String? businessName;
  String? logo;
  String? cover;
  Address? address;
  Restaurant? restaurant;
  num? id;

  Creators(
      {this.creatorId,
      this.businessName,
      this.logo,
      this.cover,
      this.address,
      this.restaurant,
      this.id});

  Creators.fromJson(Map<String, dynamic> json) {
    creatorId = json['creator_id'];
    businessName = json['business_name'];
    logo = json['logo'];
    cover = json['cover'];
    address =
        json['address'] != null ? new Address.fromJson(json['address']) : null;
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creator_id'] = this.creatorId;
    data['business_name'] = this.businessName;
    data['logo'] = this.logo;
    data['cover'] = this.cover;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    data['id'] = this.id;
    return data;
  }
}

class Address {
  String? flatNo;
  String? street;
  String? landmark;
  String? area;
  String? city;
  String? state;
  String? country;
  var pincode;
  double? latitude;
  double? longitude;
  String? serviceArea;

  Address(
      {this.flatNo,
      this.street,
      this.landmark,
      this.area,
      this.city,
      this.state,
      this.country,
      this.pincode,
      this.latitude,
      this.longitude,
      this.serviceArea});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flat_no'] = this.flatNo;
    data['street'] = this.street;
    data['landmark'] = this.landmark;
    data['area'] = this.area;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['service_area'] = this.serviceArea;
    return data;
  }
}

class Restaurant {
  int? creatorId;
  List<String>? cuisines;
  String? sId;
  String? id;

  Restaurant({this.creatorId, this.cuisines, this.sId, this.id});

  Restaurant.fromJson(Map<String, dynamic> json) {
    creatorId = json['creator_id'];
    cuisines = json['cuisines'].cast<String>();
    sId = json['_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creator_id'] = this.creatorId;
    data['cuisines'] = this.cuisines;
    data['_id'] = this.sId;
    data['id'] = this.id;
    return data;
  }
}
