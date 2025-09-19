import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/exploration.dart';
import 'package:chessboard_explorer/models/position_node.dart';
import 'package:chessboard_explorer/models/user_data.dart';
import 'package:chessboard_explorer/models/user_graph_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// ----------------------
/// Gestione UserData globale
/// ----------------------

Future<void> saveUserData(UserData userData) async {
  final box = await Hive.openBox<UserData>('userData');
  await box.put('global', userData);
}

Future<UserData> loadUserData() async {
  final box = await Hive.openBox<UserData>('userData');
  final data = box.get('global');

  if (data != null) return data;

  // fallback: nuovo utente con grafo vuoto
  return UserData(
    userGraphData: UserGraphData(
      globalGraph: ChessGraph(
        rootNodeId: 'root',
        nodes: {
          "root": PositionNode(
            id: "root",
            fen: "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
            depth: 0,
          ),
        },
      ),
    ),
    preferredExplorations: [],
  );
}

/// ----------------------
/// Helper per accesso diretto a sezioni interne
/// ----------------------

Future<UserGraphData> loadUserGraphData() async {
  final userData = await loadUserData();
  return userData.userGraphData;
}

Future<List<String>> loadPreferredExplorations() async {
  final userData = await loadUserData();
  return userData.preferredExplorations;
}

/// ----------------------
/// Operazioni di aggiornamento parziale
/// ----------------------

Future<void> saveUserGraphData(UserGraphData graph) async {
  final userData = await loadUserData();
  final updated = userData.copyWith(userGraph: graph);
  await saveUserData(updated);
}

Future<void> addExploration(Exploration exploration) async {
  final userData = await loadUserData();
  // Rimuovo eventuale duplicato per ID uguale
  final updatedExplorations = [
    ...userData.userGraphData.explorations.where((e) => e.id != exploration.id),
    exploration,
  ];
  final updatedGraph = userData.userGraphData.copyWith(
    explorations: updatedExplorations,
  );
  final updatedUserData = userData.copyWith(userGraph: updatedGraph);
  await saveUserData(updatedUserData);
}

Future<List<Exploration>> loadExplorations() async {
  final userData = await loadUserData();
  return userData.userGraphData.explorations;
}

Future<void> deleteExploration(String id) async {
  final userData = await loadUserData();
  final updatedGraph = userData.userGraphData.copyWith(
    explorations: userData.userGraphData.explorations
        .where((e) => e.id != id)
        .toList(),
  );
  final updated = userData.copyWith(userGraph: updatedGraph);
  await saveUserData(updated);
}

Future<void> toggleFavoriteExploration(String id) async {
  final userData = await loadUserData();
  final isFav = userData.preferredExplorations.contains(id);

  final updated = userData.copyWith(
    preferredExplorations: isFav
        ? userData.preferredExplorations.where((e) => e != id).toList()
        : [...userData.preferredExplorations, id],
  );

  await saveUserData(updated);
}
