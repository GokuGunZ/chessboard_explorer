// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_graph_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserGraphDataAdapter extends TypeAdapter<UserGraphData> {
  @override
  final int typeId = 0;

  @override
  UserGraphData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserGraphData(
      globalGraph: fields[0] as ChessGraph,
      explorations: (fields[1] as List).cast<Exploration>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserGraphData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.globalGraph)
      ..writeByte(1)
      ..write(obj.explorations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserGraphDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
