// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chess_graph.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChessGraphAdapter extends TypeAdapter<ChessGraph> {
  @override
  final int typeId = 22;

  @override
  ChessGraph read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChessGraph(
      nodes: (fields[0] as Map).cast<String, PositionNode>(),
      rootNodeId: fields[1] as String,
      lastVisitedNodeId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ChessGraph obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.nodes)
      ..writeByte(1)
      ..write(obj.rootNodeId)
      ..writeByte(2)
      ..write(obj.lastVisitedNodeId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChessGraphAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
