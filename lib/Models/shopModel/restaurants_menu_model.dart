class RestaurentMenuModel {
  RestaurentMenuModel({
    required this.StatusCode,
    this.result,
  });
  late final int StatusCode;
  Result? result;

  RestaurentMenuModel.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];
    result = Result.fromJson(json['Result']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['StatusCode'] = StatusCode;
    _data['Result'] = result?.toJson();
    return _data;
  }
}

class Result {
  Result({
    required this.menu,
    required this.creator,
  });
  late final List<Menu> menu;
  late final Creator creator;
  late final List<Menu> isVegMenu = [];
  late final List<Menu> isNonVegMenu = [];

  Result.fromJson(Map<String, dynamic> json) {
    menu = List.from(json['menu']).map((e) => Menu.fromJson(e)).toList();
    creator = Creator.fromJson(json['creator']);
    menu.map((e) {
      e.menus.map((ee) {
        ee.isVeg ? isVegMenu.add(e) : isNonVegMenu.add(e);
      });
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['menu'] = menu.map((e) => e.toJson()).toList();
    _data['creator'] = creator.toJson();
    return _data;
  }
}

class Menu {
  Menu({
    required this.id,
    required this.name,
    required this.menus,
    //required this.isExpanded,
  });
  late final int id;
  late final String name;
  late final List<Menus> menus;
  bool isExpanded = true;

  Menu.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'];
    menus = List.from(json['menus']).map((e) => Menus.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['menus'] = menus.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Menus {
  Menus({
    required this.menuId,
    required this.creatorId,
    required this.categories,
    required this.name,
    required this.minPlates,
    required this.maxPlates,
    required this.isVeg,
    required this.spiceIndex,
    required this.displayPrice,
    required this.price,
    required this.weight,
    required this.halfPrice,
    required this.image,
    this.id,
  });
  late final int menuId;
  late final int creatorId;
  late final List<int> categories;
  late final String name;
  late final int minPlates;
  late final int maxPlates;
  late final bool isVeg;
  late final int spiceIndex;
  late final int displayPrice;
  late final int price;
  late final double weight;
  late final int halfPrice;
  late final String image;
  late var id;

  Menus.fromJson(Map<String, dynamic> json) {
    menuId = json['menu_id'];
    creatorId = json['creator_id'];
    categories = List.castFrom<dynamic, int>(json['categories']);
    name = json['name'];
    minPlates = json['min_plates'];
    maxPlates = json['max_plates'];
    isVeg = json['is_veg'];
    spiceIndex = json['spice_index'];
    displayPrice = json['display_price'];
    price = json['price'];
    weight = json['weight'];
    halfPrice = json['half_price'];
    image = json['image'];
    id = json['id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['menu_id'] = menuId;
    _data['creator_id'] = creatorId;
    _data['categories'] = categories;
    _data['name'] = name;
    _data['min_plates'] = minPlates;
    _data['max_plates'] = maxPlates;
    _data['is_veg'] = isVeg;
    _data['spice_index'] = spiceIndex;
    _data['display_price'] = displayPrice;
    _data['price'] = price;
    _data['weight'] = weight;
    _data['half_price'] = halfPrice;
    _data['image'] = image;
    _data['id'] = id;
    return _data;
  }
}

class Creator {
  Creator({
    required this.creatorId,
    required this.businessName,
    required this.logo,
    required this.cover,
    required this.email,
    required this.phoneNo,
    required this.firstname,
    required this.lastname,
    required this.address,
    required this.city,
    this.id,
  });
  late final int creatorId;
  late final String businessName;
  late final String logo;
  late final String cover;
  late final String email;
  late final String phoneNo;
  late final String firstname;
  late final String lastname;
  late final Address address;
  late final String city;
  late var id;

  Creator.fromJson(Map<String, dynamic> json) {
    creatorId = json['creator_id'];
    businessName = json['business_name'];
    logo = json['logo'];
    cover = json['cover'];
    email = json['email'];
    phoneNo = json['phone_no'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    address = Address.fromJson(json['address']);
    city = json['city'];
    id = json['id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['creator_id'] = creatorId;
    _data['business_name'] = businessName;
    _data['logo'] = logo;
    _data['cover'] = cover;
    _data['email'] = email;
    _data['phone_no'] = phoneNo;
    _data['firstname'] = firstname;
    _data['lastname'] = lastname;
    _data['address'] = address.toJson();
    _data['city'] = city;
    _data['id'] = id;
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
  late var pincode;
  late final double latitude;
  late final double longitude;
  late final String serviceArea;

  Address.fromJson(Map<String, dynamic> json) {
    flatNo = json['flat_no'];
    street = json['street'];
    landmark = json['landmark'];
    area = json['area'];
    city = json['city'] ?? "";
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
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
