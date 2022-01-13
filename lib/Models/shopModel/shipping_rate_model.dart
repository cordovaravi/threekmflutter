class ShippingRateModel {
  String? status;
  int? deliveryRate;

  ShippingRateModel({this.status, this.deliveryRate});

  ShippingRateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    deliveryRate = json['delivery_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['delivery_rate'] = this.deliveryRate;
    return data;
  }
}