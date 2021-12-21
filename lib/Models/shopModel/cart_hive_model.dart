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
  int? quantity;
  @HiveField(4)
  int? id;
  @HiveField(5)
  int? variationId;

  CartHiveModel(
      {this.image,
      this.name,
      this.price,
      this.quantity,
      this.id,
      this.variationId});

  CartHiveModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? "";
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    id = json['id'];
    variationId = json['variationId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['name'] = name;
    _data['price'] = price;
    _data['quantity'] = quantity;
    _data['id'] = id;
    _data['variationId'] = variationId;
    return _data;
  }
}
