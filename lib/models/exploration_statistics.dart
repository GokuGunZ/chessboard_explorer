import 'package:hive/hive.dart';

part 'exploration_statistics.g.dart';

@HiveType(typeId: 4)
class ExplorationStatistics {
  @HiveField(0)
  final int movesPlayed;

  @HiveField(1)
  final int branchesExplored;

  ExplorationStatistics({this.movesPlayed = 0, this.branchesExplored = 0});

  Map<String, dynamic> toJson() => {
    'movesPlayed': movesPlayed,
    'branchesExplored': branchesExplored,
  };

  factory ExplorationStatistics.fromJson(Map<String, dynamic> json) =>
      ExplorationStatistics(
        movesPlayed: json['movesPlayed'] ?? 0,
        branchesExplored: json['branchesExplored'] ?? 0,
      );
}
