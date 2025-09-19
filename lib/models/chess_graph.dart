import 'package:hive/hive.dart';
import 'position_node.dart';

part 'chess_graph.g.dart';

@HiveType(typeId: 22)
class ChessGraph {
  @HiveField(0)
  final Map<String, PositionNode> nodes;
  @HiveField(1)
  final String rootNodeId;
  @HiveField(2)
  String? lastVisitedNodeId;

  ChessGraph({
    required this.nodes,
    required this.rootNodeId,
    this.lastVisitedNodeId,
  });

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
    'lastVisitedNodeId': lastVisitedNodeId,
  };

  factory ChessGraph.fromJson(Map<String, dynamic> json) {
    final nodesJson = json['nodes'] as Map<String, dynamic>;
    return ChessGraph(
      nodes: nodesJson.map(
        (key, value) => MapEntry(key, PositionNode.fromJson(value)),
      ),
      rootNodeId: json['rootNodeId'],
      lastVisitedNodeId: json['lastVisitedNodeId'],
    );
  }

  // dentro chess_graph.dart
  List<String> getMoveHistory(String nodeId) {
    List<String> moves = [];
    PositionNode? node = getNode(nodeId);

    while (node != null && node.incomingEdges.isNotEmpty) {
      final edge = node.incomingEdges.last;
      moves.add(edge.moveSan);
      node = getNode(edge.fromNodeId);
    }
    return moves;
  }

  // dentro chess_graph.dart
  List<String> getConfigurationHistory(String nodeId) {
    PositionNode? node = getNode(nodeId);
    List<String> configurations = [node!.fen];

    while (node != null && node.incomingEdges.isNotEmpty) {
      final edge = node.incomingEdges.last;
      node = getNode(edge.fromNodeId);
      configurations.add(node!.fen);
    }
    return configurations;
  }

  // Converti in Map per Hive
  Map<String, dynamic> toMap() {
    return {
      'rootNodeId': rootNodeId,
      'nodes': nodes.map((key, value) => MapEntry(key, value.toMap())),
      'lastVisitedNodeId': lastVisitedNodeId,
    };
  }

  // Ricostruisci da Map
  factory ChessGraph.fromMap(Map<String, dynamic> map) {
    return ChessGraph(
      rootNodeId: map['rootNodeId'],
      nodes: (map['nodes'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, PositionNode.fromMap(value)),
      ),
      lastVisitedNodeId: map['lastVisitedNodeId'],
    );
  }

  void updateLastPosition(String newNodeId) {
    lastVisitedNodeId = newNodeId;
  }
}
