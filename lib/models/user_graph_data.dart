import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/exploration.dart';
import 'package:hive/hive.dart';

part 'user_graph_data.g.dart';

@HiveType(typeId: 0)
class UserGraphData {
  @HiveField(0)
  ChessGraph globalGraph;

  @HiveField(1)
  List<Exploration> explorations;

  UserGraphData({required this.globalGraph, this.explorations = const []});

  Map<String, dynamic> toJson() => {
    'globalGraph': globalGraph.toJson(),
    'explorations': explorations.map((e) => e.toJson()).toList(),
  };

  factory UserGraphData.fromJson(Map<String, dynamic> json) => UserGraphData(
    globalGraph: ChessGraph.fromJson(json['globalGraph']),
    explorations: (json['explorations'] as List<dynamic>? ?? [])
        .map((e) => Exploration.fromJson(e))
        .toList(),
  );

  UserGraphData updateWith({
    ChessGraph? globalGraph,
    List<Exploration>? explorations,
  }) {
    this.globalGraph = globalGraph ?? this.globalGraph;
    this.explorations = explorations ?? this.explorations;
    return this;
  }

  UserGraphData copyWith({
    ChessGraph? globalGraph,
    List<Exploration>? explorations,
  }) {
    return UserGraphData(
      globalGraph: globalGraph ?? this.globalGraph,
      explorations: explorations ?? this.explorations,
    );
  }
}
