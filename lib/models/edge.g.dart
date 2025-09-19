// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EdgeAdapter extends TypeAdapter<Edge> {
  @override
  final int typeId = 20;

  @override
  Edge read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Edge(
      fromNodeId: fields[0] as String,
      toNodeId: fields[1] as String,
      moveUci: fields[2] as String,
      moveSan: fields[3] as String,
      moveColor: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Edge obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.fromNodeId)
      ..writeByte(1)
      ..write(obj.toNodeId)
      ..writeByte(2)
      ..write(obj.moveUci)
      ..writeByte(3)
      ..write(obj.moveSan)
      ..writeByte(4)
      ..write(obj.moveColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EdgeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
