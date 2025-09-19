import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/position_node.dart';
import 'package:chessboard_explorer/widgets/mini_chessboard.dart'; // nuovo widget
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class ChessGraphScreen extends StatefulWidget {
  final ChessGraph graph;
  final Function(PositionNode) onNodeTap;
  final String? selectedNodeId; // nodo attualmente selezionato

  const ChessGraphScreen({
    super.key,
    required this.graph,
    required this.onNodeTap,
    this.selectedNodeId,
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
      ..siblingSeparation = 15
      ..levelSeparation = 35
      ..subtreeSeparation = 10
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT;

    nodeWidgets = {};
    _buildGraph();
  }

  void _buildGraph() {
    nodeWidgets.clear();
    graphView.nodes.clear();
    graphView.edges.clear();

    final selectedNodeId = _selectedNodeId ?? widget.graph.rootNodeId;
    final currentNode =
        widget.graph.getNode(selectedNodeId) ??
        widget.graph.getNode(widget.graph.rootNodeId)!;

    // Vicini diretti
    Set<String> nearNodes = {};
    nearNodes.addAll(currentNode.outgoingEdges.map((e) => e.toNodeId));
    nearNodes.addAll(currentNode.incomingEdges.map((e) => e.fromNodeId));

    widget.graph.nodes.forEach((id, pNode) {
      Widget nodeWidget;

      // Nodo selezionato
      if (pNode.id == selectedNodeId) {
        nodeWidget = MiniChessboard(
          fen: pNode.fen,
          size: 120,
          highlightColor: Colors.deepPurpleAccent.withOpacity(0.5),
        );
      } else if (true) {
        nodeWidget = MiniChessboard(fen: pNode.fen, size: 100);
      }
      // Vicini o nodo root
      else if (nearNodes.contains(pNode.id) ||
          pNode.id == widget.graph.rootNodeId) {
        nodeWidget = MiniChessboard(fen: pNode.fen, size: 65);
      }
      // Nodi vicini
      else if (pNode.depth < currentNode.depth + 1 &&
          pNode.depth > currentNode.depth - 1) {
        nodeWidget = MiniChessboard(fen: pNode.fen, size: 50);
      }
      // Nodo lontano → mostra solo mossa
      else {
        String moveLabel = pNode.incomingEdges.isNotEmpty
            ? pNode.incomingEdges.last.moveSan
            : "";
        nodeWidget = Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black),
          ),
          child: Center(
            child: Text(moveLabel, style: const TextStyle(fontSize: 12)),
          ),
        );
      }

      // Gesture per selezione
      nodeWidget = GestureDetector(
        onTap: () => widget.onNodeTap(pNode),
        child: nodeWidget,
      );

      nodeWidgets[pNode.id] = Node(nodeWidget);
    });

    // Aggiungiamo nodi al Graph
    for (var n in nodeWidgets.values) {
      graphView.addNode(n);
    }

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

  String? _selectedNodeId;

  void updateSelectedNode(String nodeId) {
    _selectedNodeId = nodeId;
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
      boundaryMargin: const EdgeInsets.all(1000),
      minScale: 0.01,
      maxScale: 5.0,
      child: GraphView(
        graph: graphView,
        algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
        builder: (Node node) {
          return node.key as Widget;
        },
      ),
    );
  }
}
