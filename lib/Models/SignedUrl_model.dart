// To parse this JSON data, do
//
//     final signedUrlModel = signedUrlModelFromJson(jsonString);

import 'dart:convert';

SignedUrlModel signedUrlModelFromJson(String str) =>
    SignedUrlModel.fromJson(json.decode(str));

class SignedUrlModel {
  SignedUrlModel({
    this.status,
    this.message,
    this.error,
    this.data,
  });

  String? status;
  dynamic message;
  dynamic error;
  Data? data;

  factory SignedUrlModel.fromJson(Map<String, dynamic> json) => SignedUrlModel(
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
    this.uploadUrl,
    this.resourceUrl,
  });

  String? uploadUrl;
  String? resourceUrl;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        uploadUrl: json["uploadURL"] == null ? null : json["uploadURL"],
        resourceUrl: json["resourceUrl"] == null ? null : json["resourceUrl"],
      );
}
