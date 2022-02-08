import 'package:hive/hive.dart';

part 'cart_hive_model.g.dart';

@HiveType(typeId: 0)
class CartHiveModel extends HiveObject {
  @HiveField(0)
  String? image;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? price;
  @HiveField(3)
  int quantity = 1;
  @HiveField(4)
  int? id;
  @HiveField(5)
  int? variationId;
  @HiveField(6)
  num? weight;
  @HiveField(7)
  int? creatorId;
  @HiveField(8)
  String? creatorName;

  CartHiveModel(
      {this.image,
      this.name,
      this.price,
      this.quantity = 1,
      this.id,
      this.variationId,
      this.weight,
      this.creatorId,
      this.creatorName});

  CartHiveModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'] ?? 1;
    id = json['id'];
    variationId = json['variationId'];
    weight = json['weight'];
    creatorId = json['creatorId'];
    creatorName = json['creatorName'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['name'] = name;
    _data['price'] = price;
    _data['quantity'] = quantity;
    _data['id'] = id;
    _data['variationId'] = variationId;
    _data['weight'] = weight;
    _data['creatorId'] = creatorId;
    _data['creatorName'] = creatorName;
    return _data;
  }
}
