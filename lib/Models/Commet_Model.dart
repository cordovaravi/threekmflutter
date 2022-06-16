// To parse this JSON data, do
//
//     final allComments = allCommentsFromJson(jsonString);

import 'dart:convert';

List<AllComments> allCommentsFromJson(String str) => List<AllComments>.from(
    json.decode(str).map((x) => AllComments.fromJson(x)));

class AllComments {
  AllComments({
    this.commentId,
    this.comment,
    this.userId,
    this.isself,
    this.id,
    this.username,
    this.avatar,
    this.timeLapsed,
  });

  int? commentId;
  String? comment;
  int? userId;
  //DateTime? createdDate;
  bool? isself;
  dynamic id;
  String? username;
  String? avatar;
  String? timeLapsed;

  factory AllComments.fromJson(Map<String, dynamic> json) => AllComments(
        commentId: json["comment_id"],
        comment: json["comment"],
        userId: json["user_id"],
        //createdDate: DateTime.parse(json["created_date"]),
        isself: json["is_self"] != null ? json["is_self"] : null,
        id: json["id"],
        username: json["username"],
        avatar: json["avatar"],
        timeLapsed: json["time_lapsed"],
      );
}
