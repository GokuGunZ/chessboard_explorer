// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exploration.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExplorationAdapter extends TypeAdapter<Exploration> {
  @override
  final int typeId = 1;

  @override
  Exploration read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exploration(
      id: fields[0] as String,
      name: fields[1] as String,
      graph: fields[2] as ChessGraph,
      lastConfigurations: (fields[3] as List).cast<String>(),
      tag: fields[4] as String,
      isFavorite: fields[5] as bool,
      statistics: fields[6] as ExplorationStatistics?,
    );
  }

  @override
  void write(BinaryWriter writer, Exploration obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.graph)
      ..writeByte(3)
      ..write(obj.lastConfigurations)
      ..writeByte(4)
      ..write(obj.tag)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.statistics);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExplorationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
