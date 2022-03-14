class CuisinesListModel {
  CuisinesListModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });
  late final String? status;
  late final String? message;
  late final Null error;
  late final Data? data;

  CuisinesListModel.fromJson(Map<String, dynamic> json) {
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
    _data['data'] = data?.toJson();
    return _data;
  }
}

class Data {
  Data({
    required this.result,
  });
  late final Result result;

  Data.fromJson(Map<String, dynamic> json) {
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
  late final List<CusinesItem> data;

  Result.fromJson(Map<String, dynamic> json) {
    data = List.from(json['data']).map((e) => CusinesItem.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class CusinesItem {
  CusinesItem({
    required this.name,
    required this.id,
    required this.photo,
  });
  late final String name;
  late final String id;
  late final String photo;

  CusinesItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['id'] = id;
    _data['photo'] = photo;
    return _data;
  }
}
