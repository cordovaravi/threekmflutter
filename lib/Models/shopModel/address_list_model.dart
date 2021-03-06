class AddressListModel {
  AddressListModel({
    this.status,
    this.message,
    this.addresses,
  });
  late final String? status;
  late final String? message;
  late final List<Addresses>? addresses;

  AddressListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    addresses =
        List.from(json['addresses']).map((e) => Addresses.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['addresses'] = addresses?.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Addresses {
  Addresses({
    this.addressId,
    this.flatNo,
    this.firstname,
    this.lastname,
    this.street,
    this.area,
    this.city,
    this.state,
    this.landmark,
    this.country,
    this.phoneNo,
    this.pincode,
    this.latitude,
    this.longitude,
    this.addressType,
    this.id,
  });
  late final int? addressId;
  late final String? flatNo;
  late final String? firstname;
  late final String? lastname;
  late final String? street;
  late final String? area;
  late final String? city;
  late final String? state;
  late final String? landmark;
  late final String? country;
  late final int? phoneNo;
  late final int? pincode;
  late final double? latitude;
  late final double? longitude;
  late final String? addressType;
  late var id;

  Addresses.fromJson(Map<String, dynamic> json) {
    addressId = json['address_id'];
    flatNo = json['flat_no'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    street = json['street'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    landmark = json['landmark'];
    country = json['country'];
    phoneNo = json['phone_no'] ?? 0;
    pincode = json['pincode'] ?? 0;
    latitude = json['latitude'];
    longitude = json['longitude'];
    addressType = json['address_type'] ?? "home";
    id = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['address_id'] = addressId;
    _data['flat_no'] = flatNo;
    _data['firstname'] = firstname;
    _data['lastname'] = lastname;
    _data['street'] = street;
    _data['area'] = area;
    _data['city'] = city;
    _data['state'] = state;
    _data['landmark'] = landmark;
    _data['country'] = country;
    _data['phone_no'] = phoneNo;
    _data['pincode'] = pincode;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    _data['address_type'] = addressType;
    _data['id'] = id;
    return _data;
  }
}
