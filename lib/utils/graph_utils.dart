import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/exploration.dart';
import 'package:chessboard_explorer/models/position_node.dart';
import 'package:uuid/uuid.dart';

ChessGraph getEmptyGraph() {
  return ChessGraph(
    nodes: {
      "root": PositionNode(
        id: "root",
        fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        depth: 0,
      ),
    },
    rootNodeId: "root",
  );
}

Exploration generateNewExploration([
  String explorationName = "Nuova Esplorazione",
]) {
  return Exploration(
    id: const Uuid().v7(),
    name: explorationName,
    graph: getEmptyGraph(),
  );
}
