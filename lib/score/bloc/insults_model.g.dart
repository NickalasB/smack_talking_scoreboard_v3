// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insults_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InsultsModelAdapter extends TypeAdapter<InsultsModel> {
  @override
  final int typeId = 0;

  @override
  InsultsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InsultsModel()
      ..playerInsults = (fields[1] as List).cast<String>()
      ..tieInsults = (fields[2] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, InsultsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.playerInsults)
      ..writeByte(2)
      ..write(obj.tieInsults);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InsultsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
