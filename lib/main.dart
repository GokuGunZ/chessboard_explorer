import 'package:chessboard_explorer/models/edge.dart';
import 'package:chessboard_explorer/models/exploration.dart';
import 'package:chessboard_explorer/models/exploration_statistics.dart';
import 'package:chessboard_explorer/models/user_data.dart';
import 'package:flutter/material.dart';
import 'screens/chess_board_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chessboard_explorer/models/user_graph_data.dart';
import 'helper/graph_helper.dart';
import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/position_node.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inizializza Hive
  await Hive.initFlutter();
  Hive.registerAdapter(EdgeAdapter());
  Hive.registerAdapter(PositionNodeAdapter());
  Hive.registerAdapter(ChessGraphAdapter());
  Hive.registerAdapter(ExplorationAdapter());
  Hive.registerAdapter(UserGraphDataAdapter());
  Hive.registerAdapter(UserDataAdapter());
  Hive.registerAdapter(ExplorationStatisticsAdapter());
  await Hive.openBox('userGraph');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chessboard Explorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: FutureBuilder<UserGraphData?>(
        future: loadGraph(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            print("📂 Caricato grafo esistente");
            return ChessBoardScreen(
              userGraphData: snapshot.data!,
              graph: snapshot.data!.globalGraph,
            );
          } else {
            print("🆕 Creo grafo nuovo");
            final userGraph = UserGraphData(
              globalGraph: ChessGraph(
                nodes: {
                  "root": PositionNode(
                    id: "root",
                    fen:
                        "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
                    depth: 0,
                  ),
                },
                rootNodeId: "root",
              ),
            );
            return ChessBoardScreen(
              userGraphData: userGraph,
              graph: userGraph.globalGraph,
            );
          }
        },
      ),
    );
  }
}
