// user_node_data.dart
import 'tag.dart';

class UserNodeData {
  final String nodeId;
  final List<Tag> tags;
  final int? score;
  final bool onHold;

  UserNodeData({
    required this.nodeId,
    this.tags = const [],
    this.score,
    this.onHold = false,
  });

  Map<String, dynamic> toJson() => {
    'nodeId': nodeId,
    'tags': tags.map((t) => t.toJson()).toList(),
    'score': score,
    'onHold': onHold,
  };

  factory UserNodeData.fromJson(Map<String, dynamic> json) => UserNodeData(
    nodeId: json['nodeId'],
    tags:
        (json['tags'] as List<dynamic>?)
            ?.map((e) => Tag.fromJson(e))
            .toList() ??
        [],
    score: json['score'],
    onHold: json['onHold'] ?? false,
  );
}
