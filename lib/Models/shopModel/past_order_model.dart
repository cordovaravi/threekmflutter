class PastOrderModel {
  PastOrderModel({
    this.StatusCode,
    this.result,
  });
  late final int? StatusCode;
  late final Result? result;

  PastOrderModel.fromJson(Map<String, dynamic> json) {
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
    required this.orders,
  });
  late final List<Orders> orders;

  Result.fromJson(Map<String, dynamic> json) {
    orders = List.from(json['orders']).map((e) => Orders.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['orders'] = orders.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Orders {
  Orders({
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

  Orders.fromJson(Map<String, dynamic> json) {
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
  late final int price;
  late final int quantity;
  late final int subtotal;

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
    required this.paidBy,
    required this.status,
    required this.color,
  });
  late final String time;
  late final String icon;
  late final String vehicle;
  late final String paidBy;
  late final String status;
  late final String color;

  Delivery.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    icon = json['icon'];
    vehicle = json['vehicle'];
    paidBy = json['paid_by'];
    status = json['status'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['icon'] = icon;
    _data['vehicle'] = vehicle;
    _data['paid_by'] = paidBy;
    _data['status'] = status;
    _data['color'] = color;
    return _data;
  }
}
