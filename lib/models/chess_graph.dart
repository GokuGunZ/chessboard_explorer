// chess_graph.dart
import 'position_node.dart';

class ChessGraph {
  final Map<String, PositionNode> nodes;
  final String rootNodeId;

  ChessGraph({required this.nodes, required this.rootNodeId});

  PositionNode? getNode(String id) => nodes[id];

  void addNode(PositionNode node) {
    nodes[node.id] = node;
  }

  // esempio base: calcolo cammino (TODO: BFS completo)
  List<String> findPath(String fromNodeId, String toNodeId) {
    // TODO: implementazione con BFS
    return [];
  }

  Map<String, dynamic> toJson() => {
    'nodes': nodes.map((key, value) => MapEntry(key, value.toJson())),
    'rootNodeId': rootNodeId,
  };

  factory ChessGraph.fromJson(Map<String, dynamic> json) {
    final nodesJson = json['nodes'] as Map<String, dynamic>;
    return ChessGraph(
      nodes: nodesJson.map(
        (key, value) => MapEntry(key, PositionNode.fromJson(value)),
      ),
      rootNodeId: json['rootNodeId'],
    );
  }

  // Converti in Map per Hive
  Map<String, dynamic> toMap() {
    return {
      'rootNodeId': rootNodeId,
      'nodes': nodes.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  // Ricostruisci da Map
  factory ChessGraph.fromMap(Map<String, dynamic> map) {
    return ChessGraph(
      rootNodeId: map['rootNodeId'],
      nodes: (map['nodes'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, PositionNode.fromMap(value)),
      ),
    );
  }
}
