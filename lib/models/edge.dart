import 'package:hive/hive.dart';

part 'edge.g.dart';

@HiveType(typeId: 20)
class Edge {
  @HiveField(0)
  final String fromNodeId;
  @HiveField(1)
  final String toNodeId;
  @HiveField(2)
  final String moveUci;
  @HiveField(3)
  final String moveSan;
  @HiveField(4)
  final String moveColor;

  Edge({
    required this.fromNodeId,
    required this.toNodeId,
    required this.moveUci,
    required this.moveSan,
    required this.moveColor,
  });

  Map<String, dynamic> toJson() => {
    'fromNodeId': fromNodeId,
    'toNodeId': toNodeId,
    'moveUci': moveUci,
    'moveSan': moveSan,
    'moveColor': moveColor,
  };

  factory Edge.fromJson(Map<String, dynamic> json) => Edge(
    fromNodeId: json['fromNodeId'],
    toNodeId: json['toNodeId'],
    moveUci: json['moveUci'],
    moveSan: json['moveSan'],
    moveColor: json['moveColor'],
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
