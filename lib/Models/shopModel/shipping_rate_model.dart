class ShippingRateModel {
  String? status;
  int? deliveryRate;
  var taxPercent;

  ShippingRateModel({this.status, this.deliveryRate});

  ShippingRateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    deliveryRate = json['delivery_rate'];
    taxPercent = json['tax_percent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['delivery_rate'] = this.deliveryRate;
    return data;
  }
}
