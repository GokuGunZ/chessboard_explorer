// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exploration_statistics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExplorationStatisticsAdapter extends TypeAdapter<ExplorationStatistics> {
  @override
  final int typeId = 4;

  @override
  ExplorationStatistics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExplorationStatistics(
      movesPlayed: fields[0] as int,
      branchesExplored: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ExplorationStatistics obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.movesPlayed)
      ..writeByte(1)
      ..write(obj.branchesExplored);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExplorationStatisticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
