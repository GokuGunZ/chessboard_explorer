// main_drawer.dart
import 'package:chessboard_explorer/models/user_graph_data.dart';
import 'package:chessboard_explorer/screens/chess_board_screen.dart';
import 'package:chessboard_explorer/screens/exploration_list_screen.dart';
import 'package:chessboard_explorer/utils/graph_utils.dart';
import 'package:flutter/material.dart';
import '../screens/exploration_screen.dart';

class MainDrawer extends StatelessWidget {
  final UserGraphData userGraphData;

  const MainDrawer({super.key, required this.userGraphData});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Text(
              'Chess Explorer',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Nuova esplorazione'),
            onTap: () {
              TextEditingController _newExplorationName =
                  TextEditingController();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Nuova esplorazione"),
                  content: TextField(
                    controller: _newExplorationName,
                    decoration: InputDecoration(label: Text("Nome")),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => {
                        Navigator.of(context).pop(),
                        Navigator.of(context).pop(),
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ExplorationScreen(
                              userGraphData: userGraphData,
                              exploration: generateNewExploration(
                                _newExplorationName.text,
                              ),
                            ),
                          ),
                        ),
                      },
                      child: Text("Crea esplorazione"),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Esplorazione completa'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChessBoardScreen(
                    userGraphData: userGraphData,
                    graph: userGraphData.globalGraph,
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Lista esplorazioni'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      ExplorationListScreen(userGraphData: userGraphData),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
