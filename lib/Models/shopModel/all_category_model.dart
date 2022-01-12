class AllCategoryListModel {
  String? status = ' ';
  String? message;
  String? error;
  Data? data;

  AllCategoryListModel({ this.status, this.message, this.error, this.data});

  AllCategoryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['error'] = error;
    if (data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  int count = 0;
  List<Result>? result;

  Data({required this.count, this.result});

  Data.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    if (result != null) {
      data['result'] = result?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? categoryId;
  String? name;
  int? id;
  List<Childs>? childs;

  Result({this.categoryId, this.name, this.id, this.childs});

  Result.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    id = json['id'];
    if (json['childs'] != null) {
      childs = <Childs>[];
      json['childs'].forEach((v) {
        childs?.add(Childs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['name'] = name;
    data['id'] = id;
    if (childs != null) {
      data['childs'] = childs?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Childs {
  int? categoryId;
  String? name;
  int? id;

  Childs({categoryId, name, id});

  Childs.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}
