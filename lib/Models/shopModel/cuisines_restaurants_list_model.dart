class AutoGenerate {
  AutoGenerate({
    required this.status,
    required this.message,
     this.error,
    required this.data,
  });
  late final String status;
  late final String message;
  late final Null error;
  late final Data data;
  
  AutoGenerate.fromJson(Map<String, dynamic> json){
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
    _data['data'] = data.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.result,
  });
  late final Result result;
  
  Data.fromJson(Map<String, dynamic> json){
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
  late final List<Restaurant> data;
  
  Result.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']).map((e)=>Restaurant.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e)=>e.toJson()).toList();
    return _data;
  }
}
class  Restaurant {
   Restaurant({
    required this.restaurantId,
    required this.creatorId,
    required this.businessName,
    required this.logo,
    required this.cover,
    required this.cuisines,
    required this.managerName,
    required this.managerPhone,
    required this.address,
     this.id,
  });
  late final int restaurantId;
  late final int creatorId;
  late final String businessName;
  late final String logo;
  late final String cover;
  late final List<String> cuisines;
  late final String managerName;
  late final String managerPhone;
  late final Address address;
  late final Null id;
  
   Restaurant.fromJson(Map<String, dynamic> json){
    restaurantId = json['restaurant_id'];
    creatorId = json['creator_id'];
    businessName = json['business_name'];
    logo = json['logo'];
    cover = json['cover'];
    cuisines = List.castFrom<dynamic, String>(json['cuisines']);
    managerName = json['manager_name'];
    managerPhone = json['manager_phone'];
    address = Address.fromJson(json['address']);
    id = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['restaurant_id'] = restaurantId;
    _data['creator_id'] = creatorId;
    _data['business_name'] = businessName;
    _data['logo'] = logo;
    _data['cover'] = cover;
    _data['cuisines'] = cuisines;
    _data['manager_name'] = managerName;
    _data['manager_phone'] = managerPhone;
    _data['address'] = address.toJson();
    _data['id'] = id;
    return _data;
  }
}

class Address {
  Address({
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.country,
  });
  late final String street;
  late final String area;
  late final String city;
  late final String state;
  late final String country;
  
  Address.fromJson(Map<String, dynamic> json){
    street = json['street'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['street'] = street;
    _data['area'] = area;
    _data['city'] = city;
    _data['state'] = state;
    _data['country'] = country;
    return _data;
  }
}