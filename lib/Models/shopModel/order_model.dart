class OrderModel {
  OrderModel({
    this.StatusCode,
    this.result,
    this.status,
    this.error,
  });
  late final int? StatusCode;
  late final Result? result;
  late final String? status;
  late final String? error;

  OrderModel.fromJson(Map<String, dynamic> json) {
    StatusCode = json['StatusCode'];
    if (json['Result'] != null) {
      result = Result.fromJson(json['Result']);
    }
    status = json['status'];

    error = json['error'];
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
    this.status,
    this.url,
    this.rzorderId,
    this.orderId,
    this.projectId,
  });
  late final String? status;
  late final String? url;
  late final String? rzorderId;
  late final String? orderId;
  late final int? projectId;

  Result.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    url = json['url'];
    rzorderId = json['rzorder_id'];
    orderId = json['order_id'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['url'] = url;
    _data['rzorder_id'] = rzorderId;
    _data['order_id'] = orderId;
    _data['project_id'] = projectId;
    return _data;
  }
}
