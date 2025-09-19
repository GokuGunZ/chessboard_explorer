import 'package:chess/chess.dart' as ch;
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:hive/hive.dart';
import 'dart:convert';

import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/position_node.dart';
import 'package:chessboard_explorer/models/edge.dart';
import 'package:chessboard_explorer/models/user_graph_data.dart';

/// Aggiorna il grafo con la nuova mossa
String applyMoveToGraph(
  ChessGraph graph,
  String currentNodeId,
  String fenNuova,
) {
  final currentNode = graph.getNode(currentNodeId);
  if (currentNode == null) {
    throw Exception("Nodo corrente non trovato: $currentNodeId");
  }

  final game = ch.Chess.fromFEN(currentNode.fen);

  // trova la mossa effettuata
  final legalMoves = game.generate_moves();
  ch.Move? playedMove;

  for (final m in legalMoves) {
    game.move(m);
    if (game.fen == fenNuova) {
      playedMove = m;
      game.undo();
      break;
    }
    game.undo();
  }

  if (playedMove == null) {
    throw Exception("Mossa non trovata tra quelle legali");
  }

  final newNodeId = fenNuova.hashCode.toString();

  if (!graph.nodes.containsKey(newNodeId)) {
    final newNode = PositionNode(
      id: newNodeId,
      fen: fenNuova,
      depth: currentNode.depth + 1,
    );
    graph.addNode(newNode);
  }

  final edge = Edge(
    fromNodeId: currentNodeId,
    toNodeId: newNodeId,
    moveUci: getUci(playedMove),
    moveSan: getSan(playedMove),
    moveColor: getColor(playedMove.color),
  );

  final updatedCurrent = PositionNode(
    id: currentNode.id,
    fen: currentNode.fen,
    depth: currentNode.depth,
    incomingEdges: currentNode.incomingEdges,
    outgoingEdges: [...currentNode.outgoingEdges, edge],
  );

  final updatedNewNode = PositionNode(
    id: newNodeId,
    fen: fenNuova,
    depth: currentNode.depth + 1,
    incomingEdges: [...graph.nodes[newNodeId]!.incomingEdges, edge],
    outgoingEdges: graph.nodes[newNodeId]!.outgoingEdges,
  );

  graph.nodes[currentNodeId] = updatedCurrent;
  graph.nodes[newNodeId] = updatedNewNode;

  return newNodeId;
}

String getUci(ch.Move move) {
  var uci = "${move.fromAlgebraic}${move.toAlgebraic}";
  if (move.promotion != null) {
    uci += move.promotion!.name[0].toLowerCase();
  }
  return uci;
}

String getColor(Color color) {
  return color == Color.WHITE ? "w" : "b";
}

String getSan(ch.Move move) {
  final pieceLetter = move.piece == ch.PieceType.PAWN
      ? ""
      : move.piece.name[0].toUpperCase();
  final capture = move.captured != null ? "x" : "";
  final to = move.toAlgebraic;
  final promotion = move.promotion != null
      ? "=${move.promotion!.name[0].toUpperCase()}"
      : "";
  return "$pieceLetter$capture$to$promotion";
}

/// Salva UserGraph su Hive (json string)
Future<void> saveGraph(UserGraphData userGraph) async {
  final box = Hive.box('userGraph'); // usa box già aperto
  final jsonString = jsonEncode(userGraph.toJson());
  await box.put('graph', jsonString);
  print("💾 Grafo salvato con ${userGraph.globalGraph.nodes.length} nodi");
}

Future<UserGraphData?> loadGraph() async {
  final box = Hive.box('userGraph');
  final jsonString = box.get('graph');
  if (jsonString == null) {
    print("⚠️ Nessun grafo trovato in Hive");
    return null;
  }
  try {
    final graph = UserGraphData.fromJson(jsonDecode(jsonString));
    print("✅ Grafo caricato con ${graph.globalGraph.nodes.length} nodi");
    return graph;
  } catch (e) {
    print("❌ Errore nel parsing grafo: $e");
    return null;
  }
}
