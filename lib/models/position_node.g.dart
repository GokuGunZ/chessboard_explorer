// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PositionNodeAdapter extends TypeAdapter<PositionNode> {
  @override
  final int typeId = 21;

  @override
  PositionNode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PositionNode(
      id: fields[0] as String,
      fen: fields[1] as String,
      depth: fields[2] as int,
      incomingEdges: (fields[3] as List).cast<Edge>(),
      outgoingEdges: (fields[4] as List).cast<Edge>(),
    );
  }

  @override
  void write(BinaryWriter writer, PositionNode obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fen)
      ..writeByte(2)
      ..write(obj.depth)
      ..writeByte(3)
      ..write(obj.incomingEdges)
      ..writeByte(4)
      ..write(obj.outgoingEdges);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PositionNodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
