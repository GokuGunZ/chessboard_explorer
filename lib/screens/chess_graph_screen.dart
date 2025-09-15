import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/position_node.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class ChessGraphScreen extends StatefulWidget {
  final ChessGraph graph;
  final ChessBoardController mainController;
  final Function(PositionNode) onNodeTap;

  const ChessGraphScreen({
    super.key,
    required this.graph,
    required this.mainController,
    required this.onNodeTap,
  });

  @override
  State<ChessGraphScreen> createState() => ChessGraphScreenState();
}

class ChessGraphScreenState extends State<ChessGraphScreen> {
  final Graph graphView = Graph();
  late BuchheimWalkerConfiguration builder;
  late Map<String, Node> nodeWidgets;

  @override
  void initState() {
    super.initState();
    builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = 70
      ..levelSeparation = 100
      ..subtreeSeparation = 30
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;

    nodeWidgets = {};
    _buildGraph();
  }

  void _buildGraph() {
    nodeWidgets.clear();
    graphView.nodes.clear();
    graphView.edges.clear();

    // Creiamo un Node per ogni PositionNode
    widget.graph.nodes.forEach((id, pNode) {
      final nodeWidget = GestureDetector(
        onTap: () => widget.onNodeTap(pNode),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text("${pNode.depth}", style: const TextStyle(fontSize: 12)),
          ),
        ),
      );

      nodeWidgets[id] = Node(nodeWidget);
    });

    // Aggiungiamo nodi al Graph
    nodeWidgets.values.forEach((n) => graphView.addNode(n));

    // Creiamo archi basati sugli outgoingEdges
    widget.graph.nodes.forEach((id, pNode) {
      final fromNode = nodeWidgets[id]!;
      for (final edge in pNode.outgoingEdges) {
        final toNode = nodeWidgets[edge.toNodeId]!;
        final paint = Paint()
          ..color = edge.moveColor == "w" ? Colors.white : Colors.black
          ..strokeWidth = 2;
        graphView.addEdge(fromNode, toNode, paint: paint);
      }
    });
  }

  void rebuildGraph() {
    setState(() {
      _buildGraph();
    });
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.01,
      maxScale: 5.0,
      child: GraphView(
        graph: graphView,
        algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
        builder: (Node node) {
          return node as Widget;
        },
      ),
    );
  }
}
