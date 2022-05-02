class OrderDetailModel {
  OrderDetailModel({
    required this.StatusCode,
    required this.result,
  });
  late final int StatusCode;
  late final Result result;

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'] ?? 0;
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
    required this.order,
  });
  late final Order order;

  Result.fromJson(Map<String, dynamic> json) {
    order = Order.fromJson(json['order']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['order'] = order.toJson();
    return _data;
  }
}

class Order {
  Order({
    required this.projectId,
    required this.lineItems,
    required this.soldby,
    required this.sellerDp,
    required this.centerStatus,
    required this.centerColor,
    required this.centerTime,
    required this.delivery,
    required this.date,
    required this.month,
    required this.year,
    required this.deliveryLogs,
    required this.hasDelivery,
    required this.orderType,
    required this.cuisines,
    required this.address,
    required this.customer,
    required this.phone,
    required this.orderId,
    required this.type,
    required this.cart,
  });
  late final int projectId;
  late final List<LineItems> lineItems;
  late final String soldby;
  late final String sellerDp;
  late final String centerStatus;
  late final String centerColor;
  late final String centerTime;
  late final Delivery delivery;
  late final int date;
  late final int month;
  late final int year;
  late final List<dynamic> deliveryLogs;
  late final bool hasDelivery;
  late final String orderType;
  late final String cuisines;
  late final Address address;
  late final String customer;
  late final String phone;
  late final String orderId;
  late final String type;
  late final List<Cart> cart;

  Order.fromJson(Map<String, dynamic> json) {
    projectId = json['project_id'];
    lineItems = List.from(json['line_items'])
        .map((e) => LineItems.fromJson(e))
        .toList();
    soldby = json['soldby'];
    sellerDp = json['seller_dp'];
    centerStatus = json['center_status'];
    centerColor = json['center_color'];
    centerTime = json['center_time'];
    delivery = Delivery.fromJson(json['delivery']);
    date = json['date'];
    month = json['month'];
    year = json['year'];
    deliveryLogs = List.castFrom<dynamic, dynamic>(json['delivery_logs']);
    hasDelivery = json['has_delivery'] ?? false;
    orderType = json['order_type'];
    cuisines = json['cuisines'] ?? '';
    address = Address.fromJson(json['address']);
    customer = json['customer'];
    phone = json['phone'];
    orderId = json['order_id'];
    type = json['type'];
    cart = List.from(json['cart']).map((e) => Cart.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['project_id'] = projectId;
    _data['line_items'] = lineItems.map((e) => e.toJson()).toList();
    _data['soldby'] = soldby;
    _data['seller_dp'] = sellerDp;
    _data['center_status'] = centerStatus;
    _data['center_color'] = centerColor;
    _data['center_time'] = centerTime;
    _data['delivery'] = delivery.toJson();
    _data['date'] = date;
    _data['month'] = month;
    _data['year'] = year;
    _data['delivery_logs'] = deliveryLogs;
    _data['has_delivery'] = hasDelivery;
    _data['order_type'] = orderType;
    _data['cuisines'] = cuisines;
    _data['address'] = address.toJson();
    _data['customer'] = customer;
    _data['phone'] = phone;
    _data['order_id'] = orderId;
    _data['type'] = type;
    _data['cart'] = cart.map((e) => e.toJson()).toList();
    return _data;
  }
}

class LineItems {
  LineItems({
    required this.name,
    required this.image,
    required this.soldby,
    required this.variation,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });
  late final String name;
  late final String image;
  late final String soldby;
  late final String variation;
  late final num price;
  late final int quantity;
  late final num subtotal;

  LineItems.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    soldby = json['soldby'];
    variation = json['variation'];
    price = json['price'];
    quantity = json['quantity'];
    subtotal = json['subtotal'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['image'] = image;
    _data['soldby'] = soldby;
    _data['variation'] = variation;
    _data['price'] = price;
    _data['quantity'] = quantity;
    _data['subtotal'] = subtotal;
    return _data;
  }
}

class Delivery {
  Delivery({
    required this.time,
    required this.icon,
    required this.vehicle,
    required this.cost,
    required this.paidBy,
    required this.status,
    required this.color,
  });
  late final String time;
  late final String icon;
  late final String vehicle;
  late final int cost;
  late final String paidBy;
  late final String status;
  late final String color;

  Delivery.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    icon = json['icon'];
    vehicle = json['vehicle'];
    cost = json['cost'] ?? 0;
    paidBy = json['paid_by'];
    status = json['status'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['icon'] = icon;
    _data['vehicle'] = vehicle;
    _data['cost'] = cost;
    _data['paid_by'] = paidBy;
    _data['status'] = status;
    _data['color'] = color;
    return _data;
  }
}

class Address {
  Address({
    required this.addressId,
    required this.flatNo,
    required this.firstname,
    required this.lastname,
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.landmark,
    required this.country,
    required this.phoneNo,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.addressType,
    this.id,
  });
  late final int addressId;
  late final String flatNo;
  late final String firstname;
  late final String lastname;
  late final String street;
  late final String area;
  late final String city;
  late final String state;
  late final String landmark;
  late final String country;
  late final int phoneNo;
  late final int pincode;
  late final double latitude;
  late final double longitude;
  late final String addressType;
  late final Null id;

  Address.fromJson(Map<String, dynamic> json) {
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
    phoneNo = json['phone_no'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    addressType = json['address_type'];
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

class Cart {
  Cart({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
    required this.quantity,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.image,
    required this.sku,
  });
  late final int id;
  late final String name;
  late final num price;
  late var weight;
  late final int quantity;
  late final num subtotal;
  late var tax;
  late var total;
  late final String image;
  late final String sku;

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    weight = json['weight'];
    quantity = json['quantity'];
    subtotal = json['subtotal'];
    tax = json['tax'] ?? 0.0;
    total = json['total'] ?? 0;
    image = json['image'];
    sku = json['sku'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['price'] = price;
    _data['weight'] = weight;
    _data['quantity'] = quantity;
    _data['subtotal'] = subtotal;
    _data['tax'] = tax;
    _data['total'] = total;
    _data['image'] = image;
    _data['sku'] = sku;
    return _data;
  }
}
