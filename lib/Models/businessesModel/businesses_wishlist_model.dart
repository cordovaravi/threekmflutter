import 'package:hive/hive.dart';

part 'businesses_wishlist_model.g.dart';

@HiveType(typeId: 1)
class BusinesseswishListHiveModel extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? logo;
  @HiveField(2)
  String? address;
  @HiveField(3)
  int? creatorId;

  BusinesseswishListHiveModel(
      {this.name, this.logo, this.address, this.creatorId});

  BusinesseswishListHiveModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    logo = json['logo'];
    address = json['address'];
    creatorId = json['creator_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['logo'] = this.logo;
    data['address'] = this.address;
    data['creator_id'] = this.creatorId;
    return data;
  }
}
