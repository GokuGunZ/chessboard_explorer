import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'screens/chess_board_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:chessboard_explorer/models/user_graph.dart';
import 'helper/graph_helper.dart';
import 'package:chessboard_explorer/models/chess_graph.dart';
import 'package:chessboard_explorer/models/position_node.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // inizializza Hive
  await Hive.initFlutter();
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
      home: FutureBuilder<UserGraph?>(
        future: loadGraph(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            print("📂 Caricato grafo esistente");
            return ChessBoardScreen(graph: snapshot.data!.graph);
          } else {
            print("🆕 Creo grafo nuovo");
            final userGraph = UserGraph(
              graph: ChessGraph(
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
            return ChessBoardScreen(graph: userGraph.graph);
          }
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ChessBoardController controller = ChessBoardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chess Trainer - Board MVP")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ChessBoard(
                controller: controller,
                boardColor: BoardColor.brown,
                boardOrientation: PlayerColor.white,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => controller.resetBoard(),
                child: const Text("Reset"),
              ),
              ElevatedButton(
                onPressed: () => controller.undoMove(),
                child: const Text("Undo"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
