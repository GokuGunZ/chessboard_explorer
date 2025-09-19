import 'package:chessboard_explorer/models/exploration.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as UI;
import 'package:flutter_chess_board/flutter_chess_board.dart';

import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/position_node.dart';
import 'package:chessboard_explorer/screens/chess_graph_screen.dart';
import 'package:chessboard_explorer/helper/graph_helper.dart';
import 'package:chessboard_explorer/helper/local_storage_helper.dart';
import 'package:chessboard_explorer/models/user_graph_data.dart';

// ignore: must_be_immutable
class ExplorationScreen extends StatefulWidget {
  final UserGraphData userGraphData;
  Exploration exploration;
  final String explorationName;

  ExplorationScreen({
    super.key,
    required this.userGraphData,
    required this.exploration,
    this.explorationName = "Nuova Esplorazione",
  });

  @override
  State<ExplorationScreen> createState() => _ExplorationScreenState();
}

class _ExplorationScreenState extends State<ExplorationScreen>
    with SingleTickerProviderStateMixin {
  bool showGraph = false;
  late AnimationController _controller;
  late Animation<double> _boardHeightFactor;
  late ChessBoardController chessboardController;
  late PositionNode currentNode;
  final GlobalKey<ChessGraphScreenState> graphKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    chessboardController = ChessBoardController();

    currentNode = widget.exploration.graph.getNode(
      widget.exploration.graph.lastVisitedNodeId ??
          widget.exploration.graph.rootNodeId,
    )!;
    chessboardController.loadFen(currentNode.fen);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _boardHeightFactor = Tween<double>(
      begin: 1.0,
      end: 0.4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _onMove() async {
    final newFen = chessboardController.getFen();
    try {
      // Aggiorna il grafo dell'esplorazione
      final newNodeId = applyMoveToGraph(
        widget.exploration.graph,
        currentNode.id,
        newFen,
      );

      widget.exploration.graph.updateLastPosition(newNodeId);
      setState(() {
        currentNode = widget.exploration.graph.getNode(newNodeId)!;
      });

      graphKey.currentState?.updateSelectedNode(currentNode.id);
      graphKey.currentState?.rebuildGraph();

      // Calcola ultime 3 mosse
      final configurationsHistory = widget.exploration.graph
          .getConfigurationHistory(currentNode.id);
      final lastConfigurations = configurationsHistory.length <= 4
          ? configurationsHistory.reversed.toList()
          : configurationsHistory.sublist(0, 4).reversed.toList();

      // Aggiorna exploration corrente
      widget.exploration = widget.exploration.copyWith(
        graph: widget.exploration.graph,
        lastConfigurations: lastConfigurations,
      );

      // Aggiorna il grafo globale fondendo le mosse dell'esplorazione
      final mergedGlobalGraph = mergeGraphs(
        widget.userGraphData.globalGraph,
        widget.exploration.graph,
      );
      mergedGlobalGraph.updateLastPosition(newNodeId);

      // Crea nuovo UserGraphData aggiornato
      widget.userGraphData.updateWith(
        globalGraph: mergedGlobalGraph,
        explorations: [
          ...widget.userGraphData.explorations.where(
            (e) => e.id != widget.exploration.id,
          ),
          widget.exploration,
        ],
      );

      // Salva su Hive
      await saveUserGraphData(widget.userGraphData);
    } catch (e) {
      debugPrint("Errore applyMoveToGraph: $e");
    }
  }

  void toggleGraph() {
    setState(() {
      showGraph = !showGraph;
      if (showGraph) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _onNodeTap(PositionNode tappedNode) {
    chessboardController.loadFen(tappedNode.fen);
    setState(() {
      currentNode = tappedNode;
    });

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
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => SizedBox(
                  height:
                      MediaQuery.of(context).size.height *
                      _boardHeightFactor.value,
                  child: ChessBoard(
                    controller: chessboardController,
                    enableUserMoves: true,
                    onMove: _onMove,
                  ),
                ),
              ),
            ),
            if (showGraph)
              Expanded(
                flex: 3,
                child: ChessGraphScreen(
                  key: graphKey,
                  graph: widget.exploration.graph,
                  onNodeTap: _onNodeTap,
                  selectedNodeId: currentNode.id,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: toggleGraph,
                child: Text(showGraph ? 'Nascondi grafo' : 'Mostra grafo'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Funzione helper per fondere due grafi
  ChessGraph mergeGraphs(ChessGraph global, ChessGraph exploration) {
    final mergedNodes = Map<String, PositionNode>.from(global.nodes);

    exploration.nodes.forEach((id, node) {
      if (!mergedNodes.containsKey(id)) {
        mergedNodes[id] = node;
      } else {
        final existing = mergedNodes[id]!;
        mergedNodes[id] = PositionNode(
          id: existing.id,
          fen: existing.fen,
          depth: existing.depth,
          incomingEdges: [
            ...existing.incomingEdges,
            ...node.incomingEdges.where(
              (e) => !existing.incomingEdges.any(
                (ex) => ex.toNodeId == e.toNodeId,
              ),
            ),
          ],
          outgoingEdges: [
            ...existing.outgoingEdges,
            ...node.outgoingEdges.where(
              (e) => !existing.outgoingEdges.any(
                (ex) => ex.toNodeId == e.toNodeId,
              ),
            ),
          ],
        );
      }
    });

    return ChessGraph(nodes: mergedNodes, rootNodeId: global.rootNodeId);
  }
}
