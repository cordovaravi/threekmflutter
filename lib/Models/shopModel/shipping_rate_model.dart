class ShippingRateModel {
  String? status;
  int? deliveryRate;
  var taxPercent;
  String? distance;
  String? distance_raw;

  ShippingRateModel(
      {this.status, this.deliveryRate, this.distance, this.distance_raw});

  ShippingRateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    deliveryRate = json['delivery_rate'];
    taxPercent = json['tax_percent'];
    distance = json['distance'] ?? "";
    distance_raw = json['distance_raw'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['delivery_rate'] = this.deliveryRate;
    data['distance'] = this.distance;
    data['distance_raw'] = this.distance_raw;
    return data;
  }
}
