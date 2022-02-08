class OrderRealtimeDetailModel {
  OrderRealtimeDetailModel({
    required this.date,
    required this.deliveryBy,
    required this.restaurantId,
    required this.isBuzzerOn,
    required this.pickupTimeDisplay,
    required this.products,
    required this.orderStatus,
    required this.total,
    required this.leadTime,
    required this.deliveryDetails,
    required this.restaurantCover,
    required this.restaurantPhone,
    required this.customerPhone,
    required this.restaurantCuisine,
    required this.tax,
    required this.restaurantName,
    required this.shippingAmount,
    required this.deliveryLogs,
    required this.subTotal,
    required this.deliveryToName,
    required this.pickupTime,
    required this.time,
    required this.orderId,
    required this.customer,
    required this.deliveryCreated,
    this.status,
    required this.statusImage,
  });
  late final String date;
  late final String deliveryBy;
  late final int restaurantId;
  late final bool isBuzzerOn;
  late final String pickupTimeDisplay;
  late final List<Products> products;
  late final String orderStatus;
  late final int total;
  late final int leadTime;
  late final DeliveryDetails deliveryDetails;
  late final String restaurantCover;
  late final String restaurantPhone;
  late final String customerPhone;
  // late final List<String> restaurantCuisine;
  late final String restaurantCuisine;
  late var tax;
  late final String restaurantName;
  late final int shippingAmount;
  late final List<DeliveryLogs> deliveryLogs;
  late final int subTotal;
  late final String deliveryToName;
  late final PickupTime pickupTime;
  late final String time;
  late final int orderId;
  late final String customer;
  late final bool deliveryCreated;
  late final String? status;
  late final String statusImage;

  OrderRealtimeDetailModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    deliveryBy = json['delivery_by'];
    restaurantId = json['restaurant_id'];
    isBuzzerOn = json['is_buzzer_on'];
    pickupTimeDisplay = json['pickup_time_display'];
    products =
        List.from(json['products']).map((e) => Products.fromJson(e)).toList();
    orderStatus = json['order_status'];
    total = json['total'];
    leadTime = json['lead_time'];
    deliveryDetails = DeliveryDetails.fromJson(json['delivery_details']);
    restaurantCover = json['restaurant_cover'];
    restaurantPhone = json['restaurant_phone'];
    customerPhone = json['customer_phone'];
    restaurantCuisine = json['restaurant_cuisine'];
    tax = json['tax'];
    // restaurantCuisine =
    //     List.castFrom<dynamic, String>(json['restaurant_cuisine']);
    restaurantName = json['restaurant_name'];
    shippingAmount = json['shipping_amount'] ?? 0;
    if (json['delivery_logs'] != null) {
      deliveryLogs = List.from(json['delivery_logs'])
          .map((e) => DeliveryLogs.fromJson(e))
          .toList();
    } else {
      deliveryLogs = [];
    }

    subTotal = json['sub_total'];
    deliveryToName = json['delivery_to_name'];
    pickupTime = PickupTime.fromJson(json['pickup_time']);
    time = json['time'];
    orderId = json['order_id'];
    customer = json['customer'];
    deliveryCreated = json['delivery_created'];
    status = json['status'];
    statusImage = json['status_image'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['delivery_by'] = deliveryBy;
    _data['restaurant_id'] = restaurantId;
    _data['is_buzzer_on'] = isBuzzerOn;
    _data['pickup_time_display'] = pickupTimeDisplay;
    _data['products'] = products.map((e) => e.toJson()).toList();
    _data['order_status'] = orderStatus;
    _data['total'] = total;
    _data['lead_time'] = leadTime;
    _data['delivery_details'] = deliveryDetails.toJson();
    _data['restaurant_cover'] = restaurantCover;
    _data['restaurant_phone'] = restaurantPhone;
    _data['customer_phone'] = customerPhone;
    _data['restaurant_cuisine'] = restaurantCuisine;
    _data['restaurant_name'] = restaurantName;
    _data['shipping_amount'] = shippingAmount;
    _data['delivery_logs'] = deliveryLogs.map((e) => e.toJson()).toList();
    _data['sub_total'] = subTotal;
    _data['delivery_to_name'] = deliveryToName;
    _data['pickup_time'] = pickupTime.toJson();
    _data['time'] = time;
    _data['order_id'] = orderId;
    _data['customer'] = customer;
    _data['delivery_created'] = deliveryCreated;
    _data['status'] = status;
    _data['status_image'] = statusImage;
    return _data;
  }
}

class Products {
  Products({
    required this.quantity,
    required this.price,
    required this.name,
  });
  late final int quantity;
  late final int price;
  late final String name;

  Products.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    price = json['price'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['quantity'] = quantity;
    _data['price'] = price;
    _data['name'] = name;
    return _data;
  }
}

class DeliveryDetails {
  DeliveryDetails({
    this.pickupCompleteAt,
    required this.address,
    this.agentName,
    this.latitude,
    this.startedForDeliveryAt,
    this.taskId,
    this.agentPhone,
    this.eta,
    this.assignedAt,
    this.reachedForDeliveryAt,
    this.reachedPickupAt,
    this.deliveredAt,
    this.trackingUrl,
    this.longitude,
    required this.status,
  });
  late final String? pickupCompleteAt;
  late final String address;
  late final String? agentName;
  late final double? latitude;
  late final String? startedForDeliveryAt;
  late final String? taskId;
  late final String? agentPhone;
  late final String? eta;
  late final String? assignedAt;
  late final String? reachedForDeliveryAt;
  late final String? reachedPickupAt;
  late final String? deliveredAt;
  late final String? trackingUrl;
  late final double? longitude;
  late final String status;

  DeliveryDetails.fromJson(Map<String, dynamic> json) {
    pickupCompleteAt = json['pickup_complete_at'];
    address = json['address'];
    agentName = json['agent_name'];
    latitude = json['latitude'];
    startedForDeliveryAt = json['started_for_delivery_at'];
    taskId = json['task_id'];
    agentPhone = json['agent_phone'];
    eta = json['eta'];
    assignedAt = json['assigned_at'];
    reachedForDeliveryAt = json['reached_for_delivery_at'];
    reachedPickupAt = json['reached_pickup_at'];
    deliveredAt = json['delivered_at'];
    trackingUrl = json['tracking_url'];
    longitude = json['longitude'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pickup_complete_at'] = pickupCompleteAt;
    _data['address'] = address;
    _data['agent_name'] = agentName;
    _data['latitude'] = latitude;
    _data['started_for_delivery_at'] = startedForDeliveryAt;
    _data['task_id'] = taskId;
    _data['agent_phone'] = agentPhone;
    _data['eta'] = eta;
    _data['assigned_at'] = assignedAt;
    _data['reached_for_delivery_at'] = reachedForDeliveryAt;
    _data['reached_pickup_at'] = reachedPickupAt;
    _data['delivered_at'] = deliveredAt;
    _data['tracking_url'] = trackingUrl;
    _data['longitude'] = longitude;
    _data['status'] = status;
    return _data;
  }
}

class DeliveryLogs {
  DeliveryLogs({
    required this.time,
    required this.title,
  });
  late final String time;
  late final String title;

  DeliveryLogs.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['time'] = time;
    _data['title'] = title;
    return _data;
  }
}

class PickupTime {
  PickupTime({
    this.nanoseconds,
    this.seconds,
  });
  late final int? nanoseconds;
  late final int? seconds;

  PickupTime.fromJson(Map<String, dynamic> json) {
    nanoseconds = json['nanoseconds'] ?? 0;
    seconds = json['seconds'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['nanoseconds'] = nanoseconds;
    _data['seconds'] = seconds;
    return _data;
  }
}
