import 'package:hive_flutter/hive_flutter.dart';
import '../models/chess_graph.dart';
import '../models/position_node.dart';

// Salva il grafo nella box Hive
Future<void> saveGraphLocally(ChessGraph graph) async {
  final box = Hive.box('userGraph');
  await box.put('graphData', graph.toMap());
  print("Grafo salvato: ${graph.nodes.length} nodi");
}

// Carica il grafo dalla box Hive
ChessGraph loadGraphLocally() {
  final box = Hive.box('userGraph');
  final data = box.get('graphData');

  if (data != null) {
    // Conversione ricorsiva di tutte le mappe annidate
    Map<String, dynamic> convertMap(Map m) {
      final newMap = <String, dynamic>{};
      m.forEach((key, value) {
        if (value is Map) {
          newMap[key.toString()] = convertMap(value);
        } else if (value is List) {
          newMap[key.toString()] = value
              .map((e) => e is Map ? convertMap(e) : e)
              .toList();
        } else {
          newMap[key.toString()] = value;
        }
      });
      return newMap;
    }

    final mapData = convertMap(data as Map);
    return ChessGraph.fromMap(mapData);
  } else {
    // Nodo root iniziale vuoto
    final root = PositionNode(id: 'root', fen: 'start', depth: 0);
    return ChessGraph(rootNodeId: 'root', nodes: {'root': root});
  }
}
