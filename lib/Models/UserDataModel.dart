// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  UserModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        status: json["status"] == null ? null : json["status"],
        message: json["message"],
        error: json["error"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  Data({
    this.result,
  });

  Result? result;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null ? null : Result.fromJson(json["result"]),
      );
}

class Result {
  Result({
    this.user,
    this.message,
  });

  User? user;
  String? message;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        message: json["message"] == null ? null : json["message"],
      );
}

class User {
  User({
    this.userUserId,
    this.firstname,
    this.lastname,
    this.phoneNo,
    this.countryCode,
    this.email,
    this.password,
    this.avatar,
    this.otp,
    this.about,
    this.socialLinks,
    this.otpExpiry,
    this.creatorId,
    this.isCreator,
    this.isActive,
    this.createdDate,
    this.updatedDate,
    this.context,
    this.status,
    this.isDeleted,
    this.partner,
    this.isVerified,
    this.gender,
    this.dob,
    this.userType,
    this.device,
    this.id,
    this.v,
    this.userId,
  });

  int? userUserId;
  String? firstname;
  String? lastname;
  String? phoneNo;
  String? countryCode;
  String? email;
  String? password;
  String? avatar;
  int? otp;
  dynamic about;
  SocialLinks? socialLinks;
  DateTime? otpExpiry;
  int? creatorId;
  bool? isCreator;
  bool? isActive;
  DateTime? updatedDate;
  DateTime? createdDate;
  dynamic context;
  String? status;
  bool? isDeleted;
  List<String>? partner;
  bool? isVerified;
  String? gender;
  DateTime? dob;
  String? userType;
  String? device;
  String? id;
  int? v;
  String? userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        userUserId: json["user_id"] == null ? null : json["user_id"],
        firstname: json["firstname"] == null ? null : json["firstname"],
        lastname: json["lastname"] == null ? null : json["lastname"],
        phoneNo: json["phone_no"] == null ? null : json["phone_no"],
        countryCode: json["country_code"] == null ? null : json["country_code"],
        email: json["email"] == null ? null : json["email"],
        password: json["password"] == null ? null : json["password"],
        avatar: json["avatar"] == null ? null : json["avatar"],
        otp: json["otp"] == null ? null : json["otp"],
        about: json["about"],
        socialLinks: json["social_links"] == null
            ? null
            : SocialLinks.fromJson(json["social_links"]),
        otpExpiry: json["otp_expiry"] == null
            ? null
            : DateTime.parse(json["otp_expiry"]),
        creatorId: json["creator_id"] == null ? null : json["creator_id"],
        isCreator: json["is_creator"] == null ? null : json["is_creator"],
        isActive: json["is_active"] == null ? null : json["is_active"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updatedDate: json["updated_date"] == null
            ? null
            : DateTime.parse(json["updated_date"]),
        context: json["context"],
        status: json["status"] == null ? null : json["status"],
        isDeleted: json["is_deleted"] == null ? null : json["is_deleted"],
        partner: json["partner"] == null
            ? null
            : List<String>.from(json["partner"].map((x) => x)),
        isVerified: json["is_verified"] == null ? null : json["is_verified"],
        gender: json["gender"] == null ? null : json["gender"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        userType: json["user_type"] == null ? null : json["user_type"],
        device: json["device"] == null ? null : json["device"],
        id: json["_id"] == null ? null : json["_id"],
        v: json["__v"] == null ? null : json["__v"],
        userId: json["id"] == null ? null : json["id"],
      );
}

class SocialLinks {
  SocialLinks({
    this.twitter,
    this.facebook,
    this.linkedin,
    this.instagram,
    this.googleplus,
  });

  String? twitter;
  String? facebook;
  String? linkedin;
  String? instagram;
  String? googleplus;

  factory SocialLinks.fromJson(Map<String, dynamic> json) => SocialLinks(
        twitter: json["twitter"] == null ? null : json["twitter"],
        facebook: json["facebook"] == null ? null : json["facebook"],
        linkedin: json["linkedin"] == null ? null : json["linkedin"],
        instagram: json["instagram"] == null ? null : json["instagram"],
        googleplus: json["googleplus"] == null ? null : json["googleplus"],
      );
}
