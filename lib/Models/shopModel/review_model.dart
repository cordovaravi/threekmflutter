import '../shopModel/product_details_model.dart';

class UserReviewModel {
  String? status;
  String? message;
  String? error;
  Data? data;

  UserReviewModel({this.status, this.message, this.error, this.data});

  UserReviewModel.fromJson(Map<String, dynamic> json) {
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
    if (this.data != null) {
      data['data'] = this.data?.toJson();
    }
    return data;
  }
}

class Data {
  Result? result;

  Data({this.result});

  Data.fromJson(Map<String, dynamic> json) {
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (result != null) {
      data['result'] = result?.toJson();
    }
    return data;
  }
}

class Result {
  late Reviews review;

  Result({required this.review});

  Result.fromJson(Map<String, dynamic> json) {
    review =
        // json['review'] != null ?
        Reviews.fromJson(json['review']);
    // : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (review != null) {
      data['review'] = review.toJson();
    }
    return data;
  }
}

// class Review {
//   int reviewId;
//   int userId;
//   int rating;
//   String title;
//   String description;
//   List<String> images;
//   String date;
//   String user;
//   String avatar;

//   Review(
//       {this.reviewId,
//       this.userId,
//       this.rating,
//       this.title,
//       this.description,
//       this.images,
//       this.date,
//       this.user,
//       this.avatar});

//   Review.fromJson(Map<String, dynamic> json) {
//     reviewId = json['review_id'];
//     userId = json['user_id'];
//     rating = json['rating'];
//     title = json['title'];
//     description = json['description'];
//     images = json['images'].cast<String>();
//     date = json['date'];
//     user = json['user'];
//     avatar = json['avatar'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['review_id'] = this.reviewId;
//     data['user_id'] = this.userId;
//     data['rating'] = this.rating;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['images'] = this.images;
//     data['date'] = this.date;
//     data['user'] = this.user;
//     data['avatar'] = this.avatar;
//     return data;
//   }
// }
