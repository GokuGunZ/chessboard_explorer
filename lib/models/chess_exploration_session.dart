import 'chess_graph.dart';

class ChessExplorationSession {
  final String id; // UUID o timestamp
  final ChessGraph graph;
  final DateTime createdAt;
  final DateTime lastPlayedAt;

  ChessExplorationSession({
    required this.id,
    required this.graph,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastPlayedAt = lastPlayedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'graph': graph.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'lastPlayedAt': lastPlayedAt.toIso8601String(),
  };

  factory ChessExplorationSession.fromJson(Map<String, dynamic> json) {
    return ChessExplorationSession(
      id: json['id'],
      graph: ChessGraph.fromJson(json['graph']),
      createdAt: DateTime.parse(json['createdAt']),
      lastPlayedAt: DateTime.parse(json['lastPlayedAt']),
    );
  }
}
