import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'package:flutter_chess_board/flutter_chess_board.dart';

import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/position_node.dart';
import 'package:chessboard_explorer/screens/chess_graph_screen.dart';
import 'package:chessboard_explorer/helper/graph_helper.dart';
import 'package:chessboard_explorer/models/user_graph.dart';

class ChessBoardScreen extends StatefulWidget {
  final ChessGraph graph;

  const ChessBoardScreen({super.key, required this.graph});

  @override
  State<ChessBoardScreen> createState() => _ChessBoardScreenState();
}

class _ChessBoardScreenState extends State<ChessBoardScreen> {
  late ChessBoardController controller;
  late PositionNode currentNode;
  final GlobalKey<ChessGraphScreenState> graphKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = ChessBoardController();

    // Nodo root come punto di partenza
    currentNode = widget.graph.getNode(widget.graph.rootNodeId)!;
    controller.loadFen(currentNode.fen);
  }

  void _onMove() async {
    final newFen = controller.getFen();
    try {
      final newNodeId = applyMoveToGraph(widget.graph, currentNode.id, newFen);

      setState(() {
        currentNode = widget.graph.getNode(newNodeId)!;
      });

      // 🔥 ricostruisce il grafo con il nuovo selectedNodeId
      graphKey.currentState?.updateSelectedNode(currentNode.id);
      graphKey.currentState?.rebuildGraph();

      // Persiste su Hive come JSON
      final existing = await loadGraph();
      final toSave = existing != null
          ? UserGraph(graph: widget.graph, userData: existing.userData)
          : UserGraph(graph: widget.graph);
      await saveGraph(toSave);
    } catch (e) {
      debugPrint("Errore applyMoveToGraph: $e");
    }
  }

  void _onNodeTap(PositionNode tappedNode) {
    controller.loadFen(tappedNode.fen);
    setState(() {
      currentNode = tappedNode;
    });

    // 🔥 aggiorna la vista grafo
    graphKey.currentState?.updateSelectedNode(currentNode.id);
    graphKey.currentState?.rebuildGraph();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: AlignmentGeometry.xy(0, -0.5),
          colors: [Colors.blueGrey, UI.Color.fromARGB(230, 43, 43, 43)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Chess Explorer",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: ChessBoard(
                controller: controller,
                enableUserMoves: true,
                onMove: _onMove,
              ),
            ),
            Expanded(
              flex: 3,
              child: ChessGraphScreen(
                key: graphKey,
                graph: widget.graph,
                onNodeTap: _onNodeTap,
                selectedNodeId:
                    currentNode.id, // 🔥 passiamo il nodo selezionato
              ),
            ),
          ],
        ),
      ),
    );
  }
}
