// edge.dart
class Edge {
  final String fromNodeId;
  final String toNodeId;
  final String moveUci; // es. "e2e4"
  final String moveSan; // es. "e4"
  final String moveColor;
  final Map<String, dynamic> metadata;

  Edge({
    required this.fromNodeId,
    required this.toNodeId,
    required this.moveUci,
    required this.moveSan,
    required this.moveColor,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'fromNodeId': fromNodeId,
    'toNodeId': toNodeId,
    'moveUci': moveUci,
    'moveSan': moveSan,
    'moveColor': moveColor,
    'metadata': metadata,
  };

  factory Edge.fromJson(Map<String, dynamic> json) => Edge(
    fromNodeId: json['fromNodeId'],
    toNodeId: json['toNodeId'],
    moveUci: json['moveUci'],
    moveSan: json['moveSan'],
    moveColor: json['moveColor'],
    metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
  );

  Map<String, dynamic> toMap() => {
    'fromNodeId': fromNodeId,
    'toNodeId': toNodeId,
    'moveUci': moveUci,
    'moveSan': moveSan,
    'moveColor': moveColor,
  };

  factory Edge.fromMap(Map<String, dynamic> map) => Edge(
    fromNodeId: map['fromNodeId'],
    toNodeId: map['toNodeId'],
    moveUci: map['moveUci'],
    moveSan: map['moveSan'],
    moveColor: map['moveColor'],
  );
}
