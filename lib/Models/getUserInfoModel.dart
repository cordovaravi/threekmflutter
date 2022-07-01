class GetUserInfoModel {
  GetUserInfoModel({
     this.status,
     this.message,
     this.error,
     this.data,
  });
  late final String? status;
  late final Null message;
  late final Null error;
  late final Data? data;
  
  GetUserInfoModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = null;
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
  
  Data.fromJson(Map<String, dynamic> json){
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
    required this.userId,
    required this.firstname,
    required this.lastname,
    required this.phoneNo,
    required this.countryCode,
    required this.email,
    required this.avatar,
     this.context,
    required this.isVerified,
    required this.isEmailVerified,
    required this.isDocumentVerified,
    required this.gender,
    required this.dob,
    required this.bloodGroup,
    required this.languages,
    required this.usersAddress,
     this.id,
  });
  late final int userId;
  late final String firstname;
  late final String lastname;
  late final String phoneNo;
  late final String countryCode;
  late final String email;
  late final String avatar;
  late final Null context;
  late final bool isVerified;
  late final bool isEmailVerified;
  late final bool isDocumentVerified;
  late final String gender;
  late final String dob;
  late final String bloodGroup;
  late final List<String> languages;
  late final List<dynamic> usersAddress;
  late final Null id;
  
  Result.fromJson(Map<String, dynamic> json){
    userId = json['user_id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phoneNo = json['phone_no'];
    countryCode = json['country_code'];
    email = json['email'];
    avatar = json['avatar'];
    context = null;
    isVerified = json['is_verified'];
    isEmailVerified = json['is_email_verified'];
    isDocumentVerified = json['is_document_verified'];
    gender = json['gender'];
    dob = json['dob'];
    bloodGroup = json['blood_group'];
    languages = List.castFrom<dynamic, String>(json['languages']);
    usersAddress = List.castFrom<dynamic, dynamic>(json['users_address']);
    id = null;
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['firstname'] = firstname;
    _data['lastname'] = lastname;
    _data['phone_no'] = phoneNo;
    _data['country_code'] = countryCode;
    _data['email'] = email;
    _data['avatar'] = avatar;
    _data['context'] = context;
    _data['is_verified'] = isVerified;
    _data['is_email_verified'] = isEmailVerified;
    _data['is_document_verified'] = isDocumentVerified;
    _data['gender'] = gender;
    _data['dob'] = dob;
    _data['blood_group'] = bloodGroup;
    _data['languages'] = languages;
    _data['users_address'] = usersAddress;
    _data['id'] = id;
    return _data;
  }
}