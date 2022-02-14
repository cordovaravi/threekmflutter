// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartHiveModelAdapter extends TypeAdapter<CartHiveModel> {
  @override
  final int typeId = 0;

  @override
  CartHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartHiveModel(
      image: fields[0] as String?,
      name: fields[1] as String?,
      price: fields[2] as num?,
      quantity: fields[3] as int,
      id: fields[4] as int?,
      variation_id: fields[5] as int?,
      weight: fields[7] as num?,
      creatorId: fields[8] as int?,
      creatorName: fields[9] as String?,
      variation_name: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CartHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.variation_id)
      ..writeByte(6)
      ..write(obj.variation_name)
      ..writeByte(7)
      ..write(obj.weight)
      ..writeByte(8)
      ..write(obj.creatorId)
      ..writeByte(9)
      ..write(obj.creatorName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
