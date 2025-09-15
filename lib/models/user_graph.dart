// user_graph.dart
import 'chess_graph.dart';
import 'user_node_data.dart';

class UserGraph {
  final ChessGraph graph;
  final Map<String, UserNodeData> userData;

  UserGraph({required this.graph, this.userData = const {}});

  Map<String, dynamic> toJson() => {
    'graph': graph.toJson(),
    'userData': userData.map((key, value) => MapEntry(key, value.toJson())),
  };

  factory UserGraph.fromJson(Map<String, dynamic> json) => UserGraph(
    graph: ChessGraph.fromJson(json['graph']),
    userData:
        (json['userData'] as Map<String, dynamic>?)?.map(
          (key, value) => MapEntry(key, UserNodeData.fromJson(value)),
        ) ??
        {},
  );
}
