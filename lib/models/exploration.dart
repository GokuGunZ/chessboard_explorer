import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/exploration_statistics.dart';
import 'package:hive/hive.dart';

part 'exploration.g.dart';

@HiveType(typeId: 1)
class Exploration {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final ChessGraph graph;

  @HiveField(3)
  final List<String> lastConfigurations; // ultime 3 mosse lineari

  @HiveField(4)
  final String tag;

  @HiveField(5)
  final bool isFavorite;

  @HiveField(6)
  final ExplorationStatistics statistics;

  Exploration({
    required this.id,
    required this.name,
    required this.graph,
    this.lastConfigurations = const [],
    this.tag = "",
    this.isFavorite = false,
    ExplorationStatistics? statistics,
  }) : statistics = statistics ?? ExplorationStatistics();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'graph': graph.toJson(),
    'lastConfigurations': lastConfigurations,
    'tag': tag,
    'isFavorite': isFavorite,
    'statistics': statistics.toJson(),
  };

  factory Exploration.fromJson(Map<String, dynamic> json) => Exploration(
    id: json['id'],
    name: json['name'],
    graph: ChessGraph.fromJson(json['graph']),
    lastConfigurations: List<String>.from(json['lastConfigurations'] ?? []),
    tag: json['tag'] ?? "",
    isFavorite: json['isFavorite'] ?? false,
    statistics: ExplorationStatistics.fromJson(
      json['statistics'] ?? <String, dynamic>{},
    ),
  );

  Exploration copyWith({
    String? id,
    String? name,
    ChessGraph? graph,
    List<String>? lastConfigurations,
    String? tag,
    bool? isFavorite,
    ExplorationStatistics? statistics,
  }) {
    return Exploration(
      id: id ?? this.id,
      name: name ?? this.name,
      graph: graph ?? this.graph,
      lastConfigurations: lastConfigurations ?? this.lastConfigurations,
      tag: tag ?? this.tag,
      isFavorite: isFavorite ?? this.isFavorite,
      statistics: statistics ?? this.statistics,
    );
  }
}
