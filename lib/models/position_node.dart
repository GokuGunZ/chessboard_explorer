// position_node.dart
import 'edge.dart';

class PositionNode {
  final String id;
  final String fen;
  final int depth;
  final List<Edge> incomingEdges;
  final List<Edge> outgoingEdges;

  PositionNode({
    required this.id,
    required this.fen,
    required this.depth,
    this.incomingEdges = const [],
    this.outgoingEdges = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fen': fen,
    'depth': depth,
    'incomingEdges': incomingEdges.map((e) => e.toJson()).toList(),
    'outgoingEdges': outgoingEdges.map((e) => e.toJson()).toList(),
  };

  factory PositionNode.fromJson(Map<String, dynamic> json) => PositionNode(
    id: json['id'],
    fen: json['fen'],
    depth: json['depth'],
    incomingEdges:
        (json['incomingEdges'] as List<dynamic>?)
            ?.map((e) => Edge.fromJson(e))
            .toList() ??
        [],
    outgoingEdges:
        (json['outgoingEdges'] as List<dynamic>?)
            ?.map((e) => Edge.fromJson(e))
            .toList() ??
        [],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'fen': fen,
    'depth': depth,
    'outgoingEdges': outgoingEdges.map((e) => e.toMap()).toList(),
    'incomingEdges': incomingEdges.map((e) => e.toMap()).toList(),
  };

  factory PositionNode.fromMap(Map<String, dynamic> map) => PositionNode(
    id: map['id'],
    fen: map['fen'],
    depth: map['depth'],
    outgoingEdges: (map['outgoingEdges'] as List<dynamic>)
        .map((e) => Edge.fromMap(e))
        .toList(),
    incomingEdges: (map['incomingEdges'] as List<dynamic>)
        .map((e) => Edge.fromMap(e))
        .toList(),
  );
}
