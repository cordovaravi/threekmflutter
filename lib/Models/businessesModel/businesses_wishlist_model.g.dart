// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'businesses_wishlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinesseswishListHiveModelAdapter
    extends TypeAdapter<BusinesseswishListHiveModel> {
  @override
  final int typeId = 1;

  @override
  BusinesseswishListHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinesseswishListHiveModel(
      name: fields[0] as String?,
      logo: fields[1] as String?,
      address: fields[2] as String?,
      creatorId: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, BusinesseswishListHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.logo)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.creatorId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinesseswishListHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
